---
layout: post
title: Dropbear: Dropbox "clone"
---

After reading the ZeroMQ guide several times, I really wanted to hack on
a non trivial app.  Somehow I settled on a deceptively simple Dropbox
clone.  Though, I say "clone" not because I want to move my content off
Dropbox.  It's a simple way to describe the kind of system I'm
attempting to build.

Here's the source to [DropBear](https://gist.github.com/122849a52c5b33c5d890).

It's more of a gross hack, as my dev process had to be greatly
accelerated to be ready for tonight's Riak meetup.  Clearly I shouldn't tell my
half-baked ideas to Mark Phillips (of Basho).  Only the fully baked
ones.  I have some [slides](http://dl.dropbox.com/u/3561619/talks/zeromq-riak-technoweenie.pdf).

Essentially, DropBear clients push their files to a DropBear server
using ZeroMQ PUSH/PULL sockets.  The server dumps the file in Riak and
notifies other clients.  The server using PUB/SUB sockets to distribute
the changes to other clients.  I basically copied the [high level ZeroMQ
architecture](http://mongrel2.org/static/mongrel2-manual.html#x1-670005.3) that
mongrel2 uses.

I made two critical errors in writing the DropBear prototype:

First, I originally tried to get the clients and the server to talk through
ZeroMQ ROUTER sockets.  It _almost_ worked, but I ran into some weird
issues.  I met some [dotcloud](http://www.dotcloud.com/) devs at the
Riak meetup (who use a ton of ZeroMQ).  They explained why my
understanding of ROUTER sockets was completely wrong.  I ended up having
to redesign and rewrite DropBear to use the PUSH/PULL and PUB/SUB
sockets.

Second, I used EventMachine.  The ZeroMQ bindings work well, but the callback
structure was awkward.  I went with EM because I really wanted the
the clients and server to be single processes each.  I actually went
with the Node.js bindings originally, but ran into what looks like a bug
with the PUB/SUB sockets.  So, I had to port it to EM.  However, most of
the examples in the guide are tiny scripts that work a single socket.

* [Weather update server](http://zguide.zeromq.org/rb:wuserver)
* [Weather update client](http://zguide.zeromq.org/rb:wuclient)

Those ruby examples translate really closely to other languages too
([c](http://zguide.zeromq.org/c:wuserver),
[lua](http://zguide.zeromq.org/lua:wuserver), [python](http://zguide.zeromq.org/py:wuserver)).
Even the node.js bindings are [fairly](http://zguide.zeromq.org/js:wuserver) [close](http://zguide.zeromq.org/js:wuclient)
(though the blocking `recv` call is replaced by emitted `message` events).  I
love how each script is so tiny, and describes its exact function in a
small comment at the top of the file.

It's not so much that the EventMachine bindings are bad, but it feels
like this is how ZeroMQ is meant to be used.  Talking with [Sebastien](https://twitter.com/#!/sebp)
(from dotcloud) confirmed it.  Lots of tiny scripts that use ZeroMQ
messages the way Erlang uses messages to communicate.

As a project, DropBear is pretty much a failure.  But the experience
building it taught me a lot about how ZeroMQ should work.  It's always
fun to play around in new environments, especially when they challenge
the way you think about writing code.
