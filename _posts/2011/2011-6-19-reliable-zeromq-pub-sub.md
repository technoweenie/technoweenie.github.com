---
layout: post
title: "Reliable ZeroMQ Pub Sub"
---

After Friday's [ZeroMQ Pub Sub post][pub sub], Jérôme Petazzoni [taught
me a bit more about ZeroMQ][tweet].

[pub sub]:http://techno-weenie.net/2011/6/17/zeromq-pub-sub/
[tweet]: http://twitter.com/jpetazzo/status/81777168979468290

<!-- http://twitter.com/jpetazzo/status/81777168979468290 --> <style type='text/css'>.bbpBox81777168979468290 {background:url(http://a3.twimg.com/profile_background_images/22130819/twi.png) #000000;padding:20px;} p.bbpTweet{background:#fff;padding:10px 12px 10px 12px;margin:0;min-height:48px;color:#000;font-size:18px !important;line-height:22px;-moz-border-radius:5px;-webkit-border-radius:5px} p.bbpTweet span.metadata{display:block;width:100%;clear:both;margin-top:8px;padding-top:12px;height:40px;border-top:1px solid #fff;border-top:1px solid #e6e6e6} p.bbpTweet span.metadata span.author{line-height:19px} p.bbpTweet span.metadata span.author img{float:left;margin:0 7px 0 0px;width:38px;height:38px} p.bbpTweet a:hover{text-decoration:underline}p.bbpTweet span.timestamp{font-size:12px;display:block}</style> <div class='bbpBox81777168979468290'><p class='bbpTweet'>@<a class="tweet-url username" href="http://twitter.com/technoweenie" rel="nofollow">technoweenie</a> Once a PUB/SUB socket is connected, it *IS* reliable. Use socket identity to be sure not to lose any message on reconnects.<span class='timestamp'><a title='Fri Jun 17 17:36:11 +0000 2011' href='http://twitter.com/jpetazzo/status/81777168979468290'>less than a minute ago</a> via web <a href='http://twitter.com/intent/favorite?tweet_id=81777168979468290'><img src='http://si0.twimg.com/images/dev/cms/intents/icons/favorite.png' /> Favorite</a> <a href='http://twitter.com/intent/retweet?tweet_id=81777168979468290'><img src='http://si0.twimg.com/images/dev/cms/intents/icons/retweet.png' /> Retweet</a> <a href='http://twitter.com/intent/tweet?in_reply_to=81777168979468290'><img src='http://si0.twimg.com/images/dev/cms/intents/icons/reply.png' /> Reply</a></span><span class='metadata'><span class='author'><a href='http://twitter.com/jpetazzo'><img src='http://a2.twimg.com/profile_images/65895691/avatar_normal.jpg' /></a><strong><a href='http://twitter.com/jpetazzo'>Jérôme Petazzoni</a></strong><br/>jpetazzo</span></span></p></div> <!-- end of tweet -->

Wow, so even ZeroMQ PUB sockets queue messages to subscribers.  It looks
like they get buffered in memory.  You can configure the [`ZMQ_HWM`
option][ZMQ_HWM] (`ZMQ::HWM` in ruby) to limit how many messages will be buffered.  You can
also set the [`ZMQ_SWAP` option][ZMQ_SWAP] to set the size of an on-disk
swap for messages that cross the high water mark.

[ZMQ_HWM]: http://api.zeromq.org/2-1-1:zmq-setsockopt#toc3
[ZMQ_SWAP]: http://api.zeromq.org/2-1-1:zmq-setsockopt#toc4

Armed with this bit of knowledge, I updated the [publisher
script][pub.rb] to set an identity of `channel-username`:

{% highlight ruby %}
context = ZMQ::Context.new
chan    = ARGV[0]
user    = ARGV[1]
pub     = context.socket ZMQ::PUB
pub.setsockopt ZMQ::IDENTITY, "#{chan}-#{user}"

pub.bind 'tcp://*:5555'
{% endhighlight %}

To really highlight reliable pub/sub, I wrote a [custom publisher
script][pinger.rb]
that just pings every second.

{% highlight ruby %}
require 'zmq'
context = ZMQ::Context.new
pub = context.socket ZMQ::PUB
pub.setsockopt ZMQ::IDENTITY, 'ping-pinger'
pub.bind 'tcp://*:5555'

i=0
loop do
  pub.send "ping pinger #{i+=1}" ; sleep 1
end
{% endhighlight %}

[Updating the subscriber][sub.rb] should've been just as simple, but the `while`
statement didn't allow for good error handling:

{% highlight ruby %}
while msg = STDIN.gets
  msg.strip!
  pub.send "#{chan} #{user} #{msg}"
end
{% endhighlight %}

Any interruption in the process would lose a single message.  I instead
used a method:

{% highlight ruby %}
def process(line = nil)
  line ||= @socket.recv
  chan, user, msg = line.split ' ', 3
  puts "##{chan} [#{user}]: #{msg}"
  true
rescue SignalException
  process(line) if line
  false
end
{% endhighlight %}

This way any exception doesn't interrupt the processing of a message.
Here's what the loop looks like now:

{% highlight ruby %}
subscriber = Subscriber.new ARGV[0]
subscriber.connect ZMQ::Context.new, 'tcp://127.0.0.1:5555'
subscriber.subscribe_to 'rubyonrails', 'ruby-lang', 'ping'

loop do
  unless subscriber.process
    subscriber.close
    puts "Quitting..."
    exit
  end
end
{% endhighlight %}

[pub.rb]: https://gist.github.com/1031540#file_pub.rb
[sub.rb]: https://gist.github.com/1031540#file_sub.rb
[pinger.rb]: https://gist.github.com/1031540#file_pinger.rb

This is what the console output looks like:

    #ping [pinger]: 21
    #ping [pinger]: 22
    ^CQuitting...
    ruby-1.9.2-p180 ~p/zcollab/pubsub git:(master) ✗$ ruby sub.rb abc
    #ping [pinger]: 23
    #ping [pinger]: 24

I still run into rare cases where the Interrupt is raised inside the
`socket.recv` call.  For a more advanced script, you could also try
[trapping signals][igvita] to control how your script exits.

[igvita]: http://www.igvita.com/2008/07/22/unix-signals-for-live-debugging/

You can comment on this through the [HN discussion](http://news.ycombinator.com/item?id=2671372)...
