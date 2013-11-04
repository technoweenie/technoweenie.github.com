---
layout: post
title: Key/value logs in Go
---

I shipped GitHub's first user-facing Go app a month ago: the [Releases API
upload endpoint][upload-api].  It's a really simple, low traffic service to dip
our toes in the Go waters.  Before I could even think about shipping it though,
I had to answer these questions:

* How can I deploy a Go app?
* Will it be fast enough?
* Will I have any visibility into it?

The first two questions are simple enough.  I worked with some Ops people on
getting Go support in our Boxen and Puppet recipes.  Considering how much time
this app would spend in network requests, I knew that raw execution speed wasn't
going to be a factor. To help answer question 3, I wrote [grohl][g], a
combination logging, error reporting, and metrics library.

    import "github.com/technoweenie/grohl"

A few months ago, we started using the [scrolls][s] Ruby gem for logging on
GitHub.com.  It's a simple logger that writes out key/value logs:

    app=myapp deploy=production fn=trap signal=TERM at=exit status=0

Logs are then indexed, giving us the ability to search logs for the first time.
The next thing we did was added a unique `X-GitHub-Request-Id` header to every
API request.  This same request is sent down to internal systems, exception
reporters, and auditors.  We can use this to trace user problems across the
entire system.

I knew my Go app had to be tied into the same systems to give me visibility:
our exception tracker, statsd to record metrics into Graphite, and
our log index.  I wrote grohl to be the single source of truth for the app.  Its
default behavior is to just log everything, with the expectation that something
would process them.  Relevant lines are indexed, metrics are graphed, and
exceptions are reported.

At GitHub, we're not quite there yet.  So, grohl exposes both an [error reporting][errors]
interface, and a [statter][statter] interface (designed to work with [g2s][g2s]).
Maybe you want to push metrics directly to statsd, or you want to push errors
to a [custom HTTP endpoint][haystack].  It's also nice that I can double check
my app's metrics and error reporting without having to spin up external services.
They just show up in the development log like anything else.

[upload-api]: http://developer.github.com/v3/repos/releases/#upload-a-release-asset
[g]: https://github.com/technoweenie/grohl
[s]: https://github.com/asenchi/scrolls
[errors]: https://github.com/technoweenie/grohl/blob/149d36ce630d7867ac5289be58b3eef7f92297ab/errors.go#L9-L11
[statter]: https://github.com/technoweenie/grohl/blob/149d36ce630d7867ac5289be58b3eef7f92297ab/statter.go#L10-L16
[g2s]: github.com/peterbourgon/g2s
[haystack]: https://github.com/github/go-opstocat/blob/master/haystack.go
