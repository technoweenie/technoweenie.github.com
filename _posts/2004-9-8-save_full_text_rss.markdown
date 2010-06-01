--- 
layout: post
title: save full text RSS!
---
Scoble "reports":http://radio.weblogs.com/0001011/2004/09/08.html#a8195 that "blogs.msdn.com":http://blogs.msdn.com gets full-text RSS feeds turned off.  Reason?  Insane bandwidth consumption.  It's not so much that RSS is broken really.  But, you get thousands of clients grabbing feeds multiple times a day (default for most aggregators is every hour), and of course you'll have bandwidth issues.  This goes for RSS, Atom, HTML, etc.

There are some things that can be done, such as compression and "conditional HTTP GET":http://fishbowl.pastiche.org/2002/10/21/http_conditional_get_for_rss_hackers (which are both features of HTTP).  You need servers that compress feeds and send Last-modified and Etag headers, and you need clients that can decompress and send If-Modified-Since headers.  

From what I can tell, Microsoft is doing their part.  Whether clients are misbehaving is another (more important) issue.

The funny thing about the internet, is we've been here before.  Syndicated feeds aren't new, and there's already a mechanism to scale content:  nntp.  Bloglines works in a similar way.  You subscribe to feeds, and Bloglines handles all the fetching for you.  Bloglines only has to contact blogs.msdn.com once for all the main feed subscribers.

Mark's "Winer Watcher":http://brian.carnell.com/articles/2003/07/000014.html was very interesting:

bq. "Winer initially complained about all of the bandwidth being used since Winer Watch was polling his RSS feed very 5 minutes. Pilgrim responded that he was using a set of distributed mirrors from people who were already checking Scripting.Com's RSS feed once an hour anyway, so the system would have no impact on Scripting.Com's bandwidth." -- "Brian Carnell":http://brian.carnell.com/articles/2003/07/000014.html

All I ask is if you don't provide full-text RSS feeds, *please* provide good titles and summaries!  
