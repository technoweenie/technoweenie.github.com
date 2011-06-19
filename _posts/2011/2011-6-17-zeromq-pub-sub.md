---
layout: post
title: "ZeroMQ Pub Sub... How does it work?"
---

I read [Nick Quaranto's blog post about Redis Pub
Sub][thoughtbot pub sub], and thought I'd port the examples to ZeroMQ to
show how easy it is.  As I've said in previous posts, ZeroMQ is a great
networking library, and pub/sub is one of the patterns you can use.

[thoughtbot pub sub]: http://robots.thoughtbot.com/post/6325247416/redis-pub-sub-how-does-it-work

Redis is amazing though.  I'm not trying to say anything bad about
Nick's approach (and [Radish](http://radishapp.com/) is really awesome).  Why would you use ZeroMQ over Redis?

* You want to do quick messaging between hosts, processes, or even
  threads.
* You want to use a different transport besides TCP: multicast,
  in-process, inter-process.  The code doesn't change (besides the
  bind/connect calls).
* You want to take advantage of other ZeroMQ messaging patterns to
  (request/reply, push/pull, etc).
* You don't want certain components to talk to the central Redis
  servers.
* You don't want to deal with connection errors.  ZeroMQ publishers and
  subscribers can start up in any order.  They'll connect and reconnect
  behind the scenes.
* ZeroMQ PUB sockets will buffer messages if a SUB socket
  drops and reconnects.  Read more about [reliable pub sub](http://localhost:4000/2011/6/19/reliable-zeromq-pub-sub/)

Why would you use Redis over ZeroMQ?

* You _only_ need pub/sub, you have Redis already.  Fewer networking
  components is obviously simpler and better.

At GitHub, we use a lot of Redis, but we have one clear case where
ZeroMQ would be better suited: our
Service Hooks server.  Since the code is [open source](https://github.com/github/github-services), the server it runs on is completely isolated from everything else.  We could setup another Redis server, but it's overkill just to enable message passing between the main GitHub app and the Services app.  We currently use HTTP calls, but could just as easily use ZeroMQ.

## Demo

I ported Nick's code to a simple [ZeroMQ chat demo](https://gist.github.com/1031540).  It works the same:  A user connects and publishes messages to a channel, and subscribed users receive them.

## Publish

This uses the zmq gem to bind a SUB socket to port 5555.  You can tweak
this to play with some of the other network transports too, like
multicast or inproc.  I'm not using JSON in this example, though it is
of course possible with ZeroMQ.

{% highlight ruby %}
# pub.rb
require 'zmq'

context = ZMQ::Context.new
chan    = ARGV[0]
user    = ARGV[1]
pub     = context.socket ZMQ::PUB
pub.bind 'tcp://*:5555'

while msg = STDIN.gets
  msg.strip!
  pub.send "#{chan} #{user} #{msg}"
end
{% endhighlight %}

One slight difference here is that the channel is sent as part of the
message.  Redis lets you send the channel as a separate parameter, but
ZeroMQ just includes it in the beginning of the message.

You can run the script the same too:

    $ ruby pub.rb rubyonrails technoweenie
    Hello world

This sends a ZeroMQ message like this:

    rubyonrails technoweenie Hello World

## Subscribe

Now, let's write something to receive and display these published
messages.

{% highlight ruby %}
# sub.rb
require 'zmq'

context = ZMQ::Context.new
chans   = %w(rubyonrails ruby-lang)
sub     = context.socket ZMQ::SUB

sub.connect 'tcp://127.0.0.1:5555'
chans.each { |ch| sub.setsockopt ZMQ::SUBSCRIBE, ch }

while line = sub.recv
  chan, user, msg = line.split ' ', 3
  puts "##{chan} [#{user}]: #{msg}"
end
{% endhighlight %}

ZeroMQ is a c++ library built just for messaging, so it hides away the
complexities of receiving them behind the blocking `recv` call.
Therefore, you don't have to worry about setting up callbacks for
`message` events or anything like that, unless you use an asynchronous
ZeroMQ library (EventMachine, Node.js, etc).

This works exactly like the Redis example:

    $ ruby pub.rb rubyonrails qrush
    Whoa!
    `rake routes` right?

    $ ruby pub.rb rubyonrails turbage
    How do I list routes?
    Oh, duh. thanks bro.

    $ ruby pub.rb ruby-lang qrush
    I think it's Array#include? you really want.

    $ ruby sub.rb
    #rubyonrails - [qrush]: Whoa!
    #rubyonrails - [turbage]: How do I list routes?
    #ruby-lang - [qrush]: I think it's Array#include? you really want.
    #rubyonrails - [qrush]: `rake routes` right?
    #rubyonrails - [turbage]: Oh, duh. thanks bro.

## Advanced Pub/Sub

[sustrik](http://news.ycombinator.com/user?id=sustrik) on HN [mentioned](http://news.ycombinator.com/item?id=2665824) a
whitepaper on forwarding subscriptions through the network.  Check out
the [Design of PUB/SUB subsystem in ØMQ][whitepaper] whitepaper for a
look at a larger pub/sub architecture.

[whitepaper]: http://www.250bpm.com/pubsub

If this sounds interesting to you, check out [Jakub Stastny's post: "Why Rubyists Should Care About Messaging"][messaging].  If you're hungry for more after that, the [ZeroMQ Guide](http://zguide.zeromq.org/page:all) goes into way more detail.  It's very well done, but might create an obsession around messaging :)

You can comment on this through the [HN discussion](http://news.ycombinator.com/item?id=2665824)...

[messaging]: http://www.rubyinside.com/why-rubyists-should-care-about-messaging-a-high-level-intro-5017.html
