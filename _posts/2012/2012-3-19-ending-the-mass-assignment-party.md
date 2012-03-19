---
layout: post
title: Ending the Mass Assignment Party
---

At GitHub, we've been going over various policies and patterns we use to ship
features.  One of the specific things is how we deal with mass assignment
issues.  There are 3 main ways we've handled it in the past:

* Add `ActiveRecord::Base.attr_accessible` to whitelist the attributes we can
set.  This is a great safety net, but leaves the controller looking unsafe:

{% highlight ruby %}
def create
  @post = Post.create params[:post]
end
{% endhighlight %}

* Slice the parameters hash in the controller.  You can do
[something simple](https://gist.github.com/1975644) or
[build some protection into Rails controllers](https://gist.github.com/1974187).
This has the advantage of looking safer in the controller, isn't DRY.

{% highlight ruby %}
def create
  @post = Post.create post_hash
end

def post_hash
  params[:post].slice :title, :body
end
{% endhighlight %}

* You can wrap access to your data model around another abstraction layer.
  You can go with something [completely custom](https://gist.github.com/1978312),
  or use something like [Django Forms](https://docs.djangoproject.com/en/dev/ref/forms/api/) 
  as another approach.

Having a common pattern is a great idea, as well as other organizational
patterns in use (testing, code review, etc).  But, we felt like we needed
something that would _force_ compliance with safe handling of user input in web
controllers.  Something that works with what we're already doing, but can't be
thwarted by someone writing lazy code.  Keep in mind, this person may be
someone from the past, that already shipped the code long before common
patterns were in place.

The [TaintedHash](https://github.com/technoweenie/tainted_hash) is what we came
up with. It's a simple proxy to a protected inner Hash, that only exposes keys
that are requested by name.  If you're going to be passing the hash into
anything that iterates through its values, you'll have to tell it which keys to
expose:

{% highlight ruby %}
# You can set properties manually:
Post.new :title => params[:post][:title]

# You can still slice
hash = params[:post].slice :title
Post.new(hash)

# You can't do this anymore:
Post.new params[:post]

# ... unless you tell it to expose some keys
params[:post].expose(:title)
Post.new params[:post]
{% endhighlight %}

It's a tiny class with no dependencies that hooks into Rails 2.3 with a simple
before filter:

{% highlight ruby %}
def wrap_params_with_tainted_hash
  @_params = TaintedHash.new(@_params.to_hash)
end
{% endhighlight %}

It's meant to be very low level and simple.  It does work well with existing
ActiveRecord accessible attributes:

{% highlight ruby %}
Post.new params[:post].expose(*Post.attr_accessible)
{% endhighlight %}

One other TaintedHash goal is that broken rules need to be easily called
out by `ack`.

{% highlight ruby %}
# #original_hash and #expose_all are probably easy to find through `ack`
Post.new params.original_hash['post']

Post.new params[:post].expose_all
{% endhighlight %}

Currently the only place we use `#original_hash` at all is to give the relevant
params to the Rails url writer.  If the right keys aren't exposed, Rails can't
build our URLs since there are no exposed values to iterate through.

This has been active on GitHub for over a week.  If it works out, we'll probably
look at introducing it or something like it to our other various ruby apps that
are running in production. The branch did expose areas that weren't tested well 
enough.  To help in the conversion of the entire app, I added code to raise 
test exceptions in after filters if Hashes had any keys left over.  In production,
we simply logged any unexposed keys that were missed.

