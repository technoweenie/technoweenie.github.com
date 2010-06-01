--- 
layout: post
title: Is [my show] on yet?
---
Not long after I first deployed [isLOSTonyet](http://islostonyet.com), [seaofclouds](http://twitter.com/seaofclouds) sent me a github message about his own LOST countdown site.   I explained my grand vision for my site, and suggested we join forces.  Luckily, he too liked the idea of tracking fellow LOST geeks on Twitter, and was able come up with a beautiful design for the new site.

![is lost on yet? screenshot](http://techno-weenie.net/assets/2009/1/18/Is_LOST__Season_5__on_yet_.jpg)

Yes, that is a custom drawn polar bear.  Awesome.

The site got a major upgrade on my flight back from my holiday trip.  Instead of relying on a static response to the countdown, the site sifts through a listing of episodes to find the next one.  [Writing a twitter bot](http://github.com/technoweenie/islostonyet.com/blob/5b937afcdbb7f3e31f243cf6416c6d834b8c1e66/lib/is_lost_on_yet/post.rb#L20-44) is also extremely easy now that all the api calls support the since_id parameter.  I still wish that Twitter would give us http callback support, though.

While developing IsLOSTOnYet, we realized BSG was coming back last week, and was able to deploy a companion [IsBSGOnYet](http://isbsgonyet.com/) site too.  There's a 24 themed one coming too...  

If you're a hardcore fan of any of these shows, I hope you're able to participate and get some enjoyment out of it.
