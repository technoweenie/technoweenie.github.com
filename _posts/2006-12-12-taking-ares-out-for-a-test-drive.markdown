--- 
layout: post
title: Taking ARes Out For a Test Drive
---
For those that don’t know, ActiveResource is a client-side XML consumer for APIs created by the latest Rails restful additions. Consider it your reward for figuring out how to wield map.resources appropriately and restructuring parts of your app around it. That’s right, follow these rules, and you’ll get most of a server API and a client library for free.

h2. Installation

Since ActiveResource isn’t released, how do we start playing with it? Probably the easiest way (until a gem is released) is by checking out the whole rails trunk and requiring both ActiveSupport and ActiveResource:

<pre><code>$ svn co http://dev.rubyonrails.org/svn/rails/trunk 
$ irb
> require 'activesupport/lib/active_support'
> require 'activeresource/lib/active_resource'</code></pre>

Note: if you don’t already have a checkout of the rails trunk somewhere, all you actually need are ActiveSupport and ActiveResource.

h2. Building a Client API Library for Beast

If you’re still following along with us in irb, you can go ahead and create the ActiveResource classes and start using it. First, we’ll create a base class that will set up the Beast site URL, as well as the optional user/password if you want to make changes.

<macro:code lang="ruby">class BeastResource < ActiveResource::Base
  # any recent trunk version of Beast will work here
  self.site = 'http://beast.caboo.se'
  # site.user = 'rick'
  # site.password = 'secret sauce'
end</macro:code>

Now that we have that, we can create classes for the four main resources we’ll be dealing with: users, forums, topics, and posts. Users and forums will be straight forward. Topics and Posts, however, are nested resources. They will need a site value that matches the path prefix set by map.resources in Beast.

<macro:code lang="ruby">
class User < BeastResource
end

class Forum < BeastResource
end

class Topic < BeastResource
  self.site += '/forums/:forum_id'
end

class Post < BeastResource
  self.site += '/forums/:forum_id/topics/:topic_id'
end</macro:code>

That’s all there is to it. Now, let’s play around.

<macro:code lang="ruby">
f = Forum.find 1
# notice that since Topic has a prefix, we must pass the forum_id.  
# This is so it can make the request to /forums/1/topics/1.xml
t = Topic.find 1, :forum_id => f.id
p = Post.find 1, :forum_id => f.id, :topic_id => t.id
u = User.find p.user_id
</macro:code>

If that all worked, you should be able to experiment with Beast. If you create any posts, please do so in the Testing forum.

<macro:code lang="ruby">
forums = Forum.find :all
testing = forums.detect { |f| f.name == 'Testing' }

# initialize takes two parameters in ActiveResource.  One for the model parameters, and one for the prefix parameters.
topic = Topic.new({
  :title => 'Testing out ARes', 
  :body  => 'Testing 1, 2, 3!'}, 
{ :forum_id => testing.id  })
</macro:code>

You may notice a few odd things here. First, #initialize takes a second hash param for the prefix options. This is so it can POST to /forums/5/topics.xml. Also, if you look at the "schema for a topic":http://beast.caboo.se/forums/5/topics/695.xml, there is no body attribute. Beast cheats a little bit here and creates both a topic and the first post from one request.

ActiveResource doesn’t know the schema and will basically send whatever you give it. If you’re a little mischievous, you may try making requests to change the posts-count, updated-at, and other “unchangeable” fields. Luckily, Beast protects its attributes with attr_accessible, so this won’t be an issue.

That’s about it for part one of this series. Hopefully you have a little more understanding of where we’re at with ActiveResource, and have had a chance to knock it around a bit. In future articles, I’ll talk about how to customize your Resources for custom applications, how to correctly build API support that ActiveResource can understand, and go into what work remains for ActiveResource. If you want to see how it works from the server side, check out "Beast":http://beast.caboo.se/forums/1/topics/381.
