---
layout: post
title: My PUT Requests Bug Me
---

So here I am, writing documentation for some new [GitHub API sweetness](http://dev.github.com), when
something strikes me.  Why are we using PUT requests for updates?
Should it bug me that my API uses the PUT verb?

## The Conventional Wisdom

I was actively contributing to the Rails Core team when Rails had its [sweaty
HTTP lovefest](http://weblog.rubyonrails.org/2007/1/19/rails-1-2-rest-admiration-http-lovefest-and-utf-8-celebrations) in Rails v1.2.x.  This introduced the REST concepts to a lot of Rails developers in a real applicable form.  Not only _can_ I build a sweet REST service, it's provided for me as long as I stay on the golden path... Huzzah!

{% highlight ruby %}
class PostsController < ActionController::Base
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    respond_to do |format|
      format.html
      format.json { render :json => @post }
    end
  end
end
{% endhighlight %}

This wasn't an accident.  David (and the rest of us) were all heavily inspired
by the Atom Publishing Protocol.  Look at how they specify [updates to
resources](http://bitworking.org/projects/atom/rfc5023.html#edit):

    Client                                     Server
      |                                           |
      |  1.) PUT to Member URI                    |
      |      Member Representation                |
      |------------------------------------------>|
      |                                           |
      |  2.) 200 OK                               |
      |<------------------------------------------|

It's a simplistic flow chart, but it clearly shows how PUT requests are
used to update the resources.  Joe Gregorio (one of the AtomPub
creators) used a similar setup for [RESTLog](http://bitworking.org/news/RESTLog_Specification).
[RESTLog is a blogging system](http://bitworking.org/news/RESTLog_Overview) that stored posts as `<item>` RSS fragments.
At the time, I didn't really understand what REST meant, I was more
focused in [trying to get RSS to work](http://diveintomark.org/archives/2004/02/04/incompatible-rss).

## Mixed Messages

I think this is where things got confused.  AtomPub and RESTLog assume
you're using the PUT verb to replace the contents of the resource on
every request.  However, typical API updates don't require the full XML
or JSON data.

    POST /items
    {"title": "a", "body": "b"}

    PUT /items/1
    {"title": "a!"}

What does [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html) say about this?

> The fundamental difference between the POST and PUT requests is reflected in the different meaning of the Request-URI. The URI in a POST request identifies the resource that will handle the enclosed entity... In contrast, the URI in a PUT request identifies the entity enclosed with the request -- the user agent knows what URI is intended and the server MUST NOT attempt to apply the request to some other resource.

Section 9.6 doesn't really mention partial updates anywhere.  It mainly
says that PUT requests are idempotent, and uses the URL to identify the
resource.  So who says PUT is for complete replacements only?
[RFC 5789](http://tools.ietf.org/html/rfc5789):

> In a PUT request, the enclosed entity
> is considered to be a modified version of the resource stored on the
> origin server, and the client is requesting that the stored version
> be _replaced_.  With PATCH, however, the enclosed entity contains a set
> of instructions describing how a resource currently residing on the
> origin server _should be modified to produce a new version_.

## Should I Care?

In my [adhoc Twitter poll](http://twitter.com/technoweenie/status/63203978145579009), the responses I got were divided by those
saying I should care (and use PATCH), or asking what was wrong with PUT.

I've dealt with a lot of API bugs, and I can only think of a single one
that had to do with the PUT verb specifically: Browsers can only send
GET or PUT requests.  Depending on the server, user agents can work
around this by using POST and specifying the "real" verb with a
[`_method` parameter](https://github.com/rack/rack/blob/master/lib/rack/methodoverride.rb) or the [`X-HTTP-Method-Override` header](http://code.google.com/apis/gdata/docs/2.0/basics.html).

Other then that, does it hurt anyone that certain API endpoints expect
the PUT verb?  **No**.

However, I've been working on GitHub API v3 as a clean slate.  It gave
me a chance to infuse more REST concepts into things.  So, I weighed my
options.

* How many users will be affected?
* What's the chance that they will update their code to match changes to
  the API?
* Is there an easy way to maintain backwards compatibility?

Fortunately, API v3 documentation was only given out to a few eager beta
testers.  So, I knew right away that the number of users was small, with
a high probability that they'd notice changes and update their code
accordingly.  I really wanted to avoid the case where I break some old
script on a server somewhere, that no one remembers the login info for.

In this specific case, I also had a way to keep the old behavior.  I
hacked up a [quick Sinatra extension](https://gist.github.com/e73ef466841e7769b48e)
to let me easily define actions that respond to multiple verbs.  I also
spoke with the Sinatra team in [adding this to Sinatra itself](https://github.com/sinatra/sinatra/issues/253).
