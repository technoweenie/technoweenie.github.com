--- 
layout: post
title: WTF does that cron do?
---
I'll be the first to admit that I'm not a great system administrator.  I was a windows guy for so long, so my only exposure to linux was haggling with shared hosting accounts to run my stupid php apps.  While my linux/administration skills have grown by leaps and bounds in the last few years, I still get caught up on something as simple as cron jobs.  The syntax is very terse, and probably easy to parse for computers.  For the rest of us...  Well, what the hell does this mean?

<pre><code>*/6 * * * * rake ts:index:delta</code></pre>

![Google is no help](http://techno-weenie.net/assets/2009/3/15/Google.jpg)

According to my new project, [CronWTF](http://cronwtf.github.com/), that "runs `rake ts:index:delta` at minutes :00, :06, :12, :18, :24, :30, :36, :42, :48, :54, every hour."

Okay, to be honest, it's not _that_ hard to read.  Most of the time my jobs run multiple times a day, so I'm only dealing with the first 2 fields (minutes and hours).  The real reason I wrote this was for punishment for royally botching up the cron job for the [Calendar About Nothing](http://calendaraboutnothing.com/).  

I wanted to run the update task every four hours:

<pre><code>* */4 * * * rake seinfeld:update</code></pre>

Then, my server would periodically run out of memory and my host would have to reboot it.  I happened to be on the server during one of these ruby storms and noticed a bunch of rake processes piling up.  Then I parsed the crontab that I had written:  Runs `rake seinfeld:update` **every minute**, on hours 0, 4, 8, 12, 16, 20, every day.

Shit!  My intensive job scanning 400 github feeds was running 60 times every 4 hours.  So, the seeds of [CronWTF](http://cronwtf.github.com/) were planted.  I wanted it browser based, so the library is pure javascript with no knowledge of browsers, frameworks, etc.  My next step is to make this accessible from the command line through spidermonkey.  I could even make it available to ruby apps through the [ruby/spidermonkey](http://github.com/wycats/ruby-spidermonkey/tree) bridge.  I don't know how it'd be useful, but who cares?
