--- 
layout: post
title: new homepage with merged feeds
---
I've started using a couple more services for providing content on this site.  First, there's my totally awesome "comics photostream":http://www.flickr.com/photos/technoweenie/tags/comics/ by "flickr":http://www.flickr.com/.  Since I'm a heavy user of Bloglines, I've been wanting a way to easily keep a track of important items I read.  I knew about its Clip Blog feature, but did not know it was available in RSS.

I would rather present that data merged into one feed on the page, rather then having multiple columns for each feed.  I sat down and wrote a simple Atom/RSS merge script with "magpie":http://magpierss.sourceforge.net/.  It was more difficult then planned because I was presenting multiple feeds in multiple formats, formatted different depending on what type of data it is.  

Of course, a better plan popped into my head, use a service to translate my non-Atom feeds.  I looked into "FeedBurner":http://feedburner.com, which recently released some new features:  "linkblog splicing":http://www.burningdoor.com/feedburner/archives/000689.html and "flickr integration":http://www.burningdoor.com/feedburner/announce/feedburner_flickr_release_20040714.html.   Exactly what I needed.  

My homepage now includes all three feeds, but the individual feeds are still available.  
