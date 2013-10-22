---
layout: post
title: One HTTP Handler to rule them all
---

Justinas Stankevičius wrote a post about [writing HTTP middleware](http://justinas.org/writing-http-middleware-in-go/)
in Go.  Having seen how Rack changed the Ruby web framework landscape, I'm glad
Go has simple HTTP server interfaces baked in.

GitHub itself runs as a set of about 15 Rack middleware (depending on the exact
environment that it boots in).  They are setup in a nice declarative format:

{% highlight ruby %}
# GitHub app middleware pipeline
use InvalidCookieDropper
use Rack::ContentTypeCleaner
use Rails::Rack::Static unless %w[staging production].include?(Rails.env)

# Enable Rack middleware for capturing (or generating) request id's
use Rack::RequestId
{% endhighlight %}

However, Rack actually assembles the objects like this:

{% highlight ruby %}
InvalidCookieDropper.new(
  Rack::ContentTypeCleaner.new(
    Rack::RequestId.New(app)
  )
)
{% endhighlight %}

This wraps every request in a nested call stack, which gets exposed in any
stack traces:

    lib/rack/request_id.rb:20:in `call'
    lib/rack/content_type_cleaner.rb:11:in `call'
    lib/rack/invalid_cookie_dropper.rb:24:in `call'
    lib/github/timer.rb:47:in `block in call'

[go-httppipe](https://github.com/technoweenie/go-httppipe) uses an approach that
simply loops through a slice of `http.Handler` objects, and returns after one of
them calls `WriteHeader()`.

{% highlight go %}
pipe := httppipe.New(
  invalidcookiedropper.New(),
  contenttypecleaner.New()
  requestid.New(),
  myapp.New(),
)

http.Handle("/", pipe)
{% endhighlight %}

This is how `http.StripPrefix` currently wraps another handler:

{% highlight go %}
func StripPrefix(prefix string, h Handler) Handler {
  if prefix == "" {
    return h
  }
  return HandlerFunc(func(w ResponseWriter, r *Request) {
    if p := strings.TrimPrefix(r.URL.Path, prefix); len(p) < len(r.URL.Path) {
      r.URL.Path = p
      h.ServeHTTP(w, r)
    } else {
      NotFound(w, r)
    }
  })
}
{% endhighlight %}

It could be rewritten like this:

{% highlight go %}
type StripPrefixHandler struct {
  Prefix string
}

func (h *StripPrefixHandler) ServeHTTP(w ResponseWriter, r *Request) {
  if h.Prefix == "" {
    return
  }
  
  if p := strings.TrimPrefix(r.URL.Path, h.Prefix); len(p) < len(r.URL.Path) {
    r.URL.Path = p
  }
}

func StripPrefix(prefix string) Handler {
  return &StripPrefixHandler{prefix}
}
{% endhighlight %}

Notice that we don't have to worry about calling an inner handler, or falling
back to `NotFound()`.  The httppipe package takes care of that.
