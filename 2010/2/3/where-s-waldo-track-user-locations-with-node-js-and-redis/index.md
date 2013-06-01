--- 
layout: post
title: "Where's Waldo: Track user locations with Node.js and Redis"
---
[Where's Waldo](http://github.com/technoweenie/wheres-waldo) is my little node.js/Redis project to keep track of users in an app.  Say hi!

![hi waldo!](http://img.skitch.com/20100203-qsax2wfqss8sbb5eqjfwsxsgy3.png)

Tracking hits on every request can get costly, and I didn't want to hold up the more important server processes with this.  So, it felt like a good fit for a quick asynchronous web server.  Node.js and Redis fit the bill perfectly.

Here's a sample from a development build of my [Tender Support](http://tenderapp.com) product.  You can probably tell where I'm going with this...

![sample](http://img.skitch.com/20100118-py3rmqkfw51d4ra6im7ump6wyk.png)

If you can't tell: you'll be able to see who is reading the same discussion that you're currently on.

If you want to play along at home, [install Node.js](http://nodejs.org), [download the source](http://github.com/technoweenie/wheres-waldo), and [fire it up](https://gist.github.com/16786e61a9e1559d0aab)!

First, you track a location of a user.  Each `curl` call below returns some JSON.  The result call I'm showing below is actually output from the example node.js script above.  

<pre><code>curl "http://127.0.0.1:3456/waldo/track?location=home&name=rick"
TRACK rick => home</code></pre>

Now, you can locate that user:

<pre><code>curl "http://127.0.0.1:3456/waldo/locate?name=rick"
LOCATE rick => home</code></pre>

You probably won't be doing this that much, though.  Let's list the users in "home" after adding a few more users:

<pre><code>curl "http://127.0.0.1:3456/waldo/track?location=home&name=bob"
TRACK bob => home
curl "http://127.0.0.1:3456/waldo/track?location=home&name=fred"
TRACK fred => home
curl "http://127.0.0.1:3456/waldo/list?location=home"
LIST home => bob, fred, rick</code></pre>

How's all this work?  Each track call stores two redis keys: `waldo:USER` and `waldo:LOCATION:USER`.  From this, we can see where a user is, and how many users are in a location.  In Redis commands, the above might look something like this:

<pre><code># tracking rick at home
SET waldo:rick home
SET waldo:home:rick 1

# locate rick
GET waldo:rick # returns home

# list users at home
KEYS waldo:home:* # returns "waldo:home:rick"

# track rick at desk
DEL waldo:home:rick
SET waldo:rick desk
SET waldo:desk:rick</code></pre>

Why didn't I use one of the nicer redis data types like a list or a set?  I can expire these individual keys.  In 5 minutes, the `waldo:rick` and `waldo:home:rick` keys are dropped.  This keeps the location lists from growing out of hand.

This isn't used in production just yet.  I can see a big problem off the bat.  The API is easily hackable. I don't know what someone would gain out of it, but you could just plug in your own users and locations and hack the results.  I'll probably be adding some kind of token authentication verification to make sure that only confirmed sites can update Waldo.

While working on Waldo, I came across a different implementation of a similar problem: [Luke Melia's "Who's Online?" lib](http://www.lukemelia.com/blog/archives/2010/01/17/redis-in-practice-whos-online/).  It uses Redis sets to track user IDs, and set unions to determine which of _your friends_ are online.  That's another very cool use of Redis.
