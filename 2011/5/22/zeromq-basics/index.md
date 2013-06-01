---
layout: post
title: ZeroMQ Basics
---

A few weeks ago, I had one of those sleepless nights that comes with
travelling several timezones ahead of what you're used to.  I picked the
[ZeroMQ (ØMQ) Guide][guide] as reading material to lull me into a deep sleep.  Bad
move: I had a **Bing** moment with ØMQ, and stayed up playing with network
services on my laptop until it was time for my son to go to school the next
day.

[guide]: http://zguide.zeromq.org/page:all

I have to admit, the name "ZeroMQ" was a little misleading for me.  I think
that's because most other message queues are very similar: something
pushes messages into a big, centralized queue, and workers pop
messages off the front.  ØMQ is really just a networking library.
Sockets the way you want them to work.  I think Zed Shaw put it best in
his [Pycon talk][pycon]: ØMQ can replace your internal HTTP REST
services.  HWhaaat?!?

[pycon]: http://blip.tv/pycon-us-videos-2009-2010-2011/pycon-2011-advanced-network-architectures-with-zeromq-4896861

## First, a Quick Primer

ZeroMQ is a c++ library providing asynchronous messaging over a variety
of transports (inproc, IPC, TCP, OpenPGM, etc).  It has bindings for
over 20 languages.  ØMQ has simple socket patterns that can be used
together to build more complex architectures.

* Request and Reply sockets are the simplest type, providing synchronous
messaging between two systems.
* Push and Pull sockets let you distribute messages to multiple workers.
  A Push socket will distribute sent messages to its Pull clients evenly.
* Publish sockets broadcast messages to any Subscribe sockets that may be listening.
* Dealer and Router sockets (or `X_REP`/`X_REQ` in older versions of
ØMQ) handle asynchronous messaging.  They require a bit of knowledge
of ØMQ addressing to really grok.

## Replacing REST

When you're designing large systems, it makes sense to break things out
into smaller pieces that communicate across some common protocol.  A lot
of people champion the REST/JSON combo because it's easy, it works well,
and it's available _everywhere_.

ØMQ is like that too.  It works nearly the same in every supported
language.  You can use JSON, MessagePack, [tagged netstrings][tnetstrings],
etc.  You get cool socket types that aren't really possible with REST
(pub/sub, push/pull).

You do end up having to build your own protocol a bit.  You end up
losing the richness of HTTP (verbs, URIs, headers).  You're also unable
to expose these services outside your private network due to some
asserts in the ØMQ code.  

[tnetstrings]: http://tnetstrings.org/

## Dakee: the Request/Reply Chat

[Dakee][dakee] is a simple chat bot that uses REQ and REP sockets to
communicate with another user.  The names come from
[Collabedit][collabedit], which is what [Towski][towski] and I used to
write the initial versions.

[dakee]: https://github.com/technoweenie/zcollab/blob/master/dakee.js
[collabedit]: http://collabedit.com/
[towski]: https://github.com/towski

The script binds a REP socket to 5555, and connects a REQ socket to the
other user's REP socket.

{% highlight javascript %}
var context = require('zeromq')
  , req     = context.createSocket('req')
  , rep     = context.createSocket('rep')
  , ip      = process.env.CLIENT_IP || '192.168.1.25'

// ...

req.connect("tcp://" + ip + ":5555")
rep.bindSync("tcp://*:5555")
{% endhighlight %}

Received messages are printed to standard output.  Messages from
standard input are sent out on the REP socket if it needs a response, or
to the REQ socket.

It makes for an unusually useless private chat system, but it manages to
highlight the behavior of the REQ and REP sockets pretty well.  The
node.js event loop actually works against ØMQ in this case, allowing you
to send multiple messages to the REQ socket.  However, the other client
won't see these extra messages until they've replied to your first one.

Why is the REQ/REP pair of socket types synchronous like this?  One
factor is simplicity.  The REP socket keeps you from having to know
which REQ socket it needs to reply to.  If you want more flexibility,
you'll have to look at the Dealer and Router socket types.

## ZeroMQ in the Wild

The only projects I know of that use ØMQ are [Mongrel2](http://mongrel2.org/home)
and [Storm](http://tech.backtype.com/preview-of-storm-the-hadoop-of-realtime-proce).  Mongrel2 is a web server that uses ZeroMQ to talk to
backend handlers written in [any language](http://mongrel2.org/home#languages).
Storm is still vaporware, but it sounds like it uses ØMQ in a similar
fashion.

## What next?

I'm continually amazed at the wealth of information in the [ZeroMQ
Guide][guide].  I'd highly recommend checking it out if you want a new
perspective on message queue systems.  The code examples are mostly in
c, but each lists ported examples in other languages.  If a language
gets all of the samples ported, it is awarded with a full translation
(so far only PHP and Lua have succeeded).  I'd love to see full Ruby and
Node.js translations too (I took the easy ones, sorry!).  Porting these
examples are a great way to figure out how ØMQ works.
