---
layout: post
title: IE9 DELETES stuff
---

So, [Kyle](http://twitter.com/kneath) and I discovered IE9 understands
real DELETE requests.  Kudos!  This is significant because of the big
blocker that restful web services have run into with browsers: They only
understand GET/HEAD and POST.  

<center>
<a href="http://en.wikipedia.org/wiki/Planetary_(comics)">
<img src="/images/2011/timetravel.jpg" />
</a>
</center>

Using more of the HTTP methods lets us keep the URLs cleaner.  Web 
browsers don't understand PUT/PATCH/DELETE, so a workaround was needed.  Rails looks at a 
`_method` GET parameter on POST requests to determine what HTTP verb it should
be recognized as.  The [GData API](http://code.google.com/apis/gdata/docs/2.0/basics.html#UpdatingEntry)
supports this behavior through the `X-HTTP-Method-Override` header.

A typical Rails controller might look like this:

{% highlight ruby %}
class WidgetsController < ApplicationController
  # DELETE /widgets/1
  def destroy
    @widget.destroy
    redirect_to '/widgets'
  end
end
{% endhighlight %}

If you don't like Rails, just close your eyes and think of your favorite
web framework...

This action works great for a simple form in a browser.  You click
"Submit",
it POSTs to the server, and then you end up back at the root page.
Then, you can add some jQuery to spice things up for newer browsers.
Progressive enhancement and all that.

{% highlight javascript %}
$('.remove-widget').click(function() {
  $.del(this.href, function() {
    // celebrate, disable a spinner, etc
  })
  return false
})
{% endhighlight %}

This works great in all modern browsers, except IE9.  We discovered that not
only does IE9 send a real DELETE request, it also _follows the redirect_
with another DELETE.  If that redirect points to another resource, you
can get a dangerous cascading effect.

[RFC 2616][RFC 2616] is not clear about what to do in this case, but strongly
suggests that redirects are not automatically followed unless coming
from a [safe method](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html).

> If the 302 status code is received in response to a request other than GET 
> or HEAD, the user agent MUST NOT automatically redirect the request unless
> it can be confirmed by the user, since this might change the conditions under
> which the request was issued.

[RFC 2616]: http://tools.ietf.org/html/rfc2616#section-10.3.3

Standard practice for browsers over the years is that redirects from
POST requests are followed with a GET request.  GET/HEAD requests are
[usually safe][google web accelerator], so this seems like reasonable
behavior.  It's expected by web developers, and consistent across
browsers.

I can't imagine that this behavior in IE9 was on purpose.  It feels like
an edge case that slipped through an if statement because `"DELETE" !=
"POST"`.  I've submitted feedback to the IE9 team about this issue.  I'm curious
to see what they say.  I really like the idea of browsers supporting
more HTTP methods, but I'd like them to be a little cautious too.  

So, if your application might be responding to ajax requests with
redirects, you should probably start sending back `200 OK`...

[google web accelerator]: http://37signals.com/svn/archives2/google_web_accelerator_hey_not_so_fast_an_alert_for_web_app_designers.php
[p]: http://en.wikipedia.org/wiki/Planetary_(comics)

<center>
<a href="http://en.wikipedia.org/wiki/Planetary_(comics)">
<img src="/images/2011/strangeworld.jpg" />
</a>
</center>

Discuss this post on [Hacker News](http://news.ycombinator.com/item?id=2903493).
