--- 
layout: post
title: the return
---
If you've checked out "Rails Weenie":http://rails.techno-weenie.net lately, you'll see some pretty drastic changes.  Now that it's on a stable hosting solution (Mongrel + Lightspeed), I feel a little more inclined to work on it.  I did some thinking about my basic goals for the site and decided to start making some enhancements.  

* First thing I did was simplify the layout.  I've felt for awhile that the sidebar took too much screen real estate, so I removed it and went with a basic single column layout.  My main goal is to make it as easy to read as possible.

* I've also done some work with the code snippets.  One potentially useful feature is that all code blocks are now available on an empty page.

* I also want to encourage more of a community aspect with the site.  I've done a bit of work on the user profiles (check out the ajax user panels).  Expect to see some added profile attributes too.

This is all fine and dandy, but I have some challenges left to tackle:

* My second goal is to make it easy to find what you're looking for.  The current search feature sucks.  I'll look into whether Hyper Estraier or Postgresql full text indexing is an option.  Ways to classify (tagging) and rate content would be very helpful too.  While taking the tagging a step further, I thought it would be interesting to show suggested questions to answer based on questions you've already answered.

* What do I do about stale questions?  I'm currently hiding unanswered questions older than 30 days.  I'll eventually bring in a "stale" area, or add some basic querying to the main questions page.  How can I handle this?  Start choosing answers, or bringing in moderators to do the same?  Maybe I could add some community voting features?  Or I could offer bonus points for digging up and answering old questions?

* I need some interesting ways to show user stats.  My "date slider demo":http://rails.techno-weenie.net/stats is still alive, but could use some more interesting data than # of articles created per day.

I'm really glad more people seem to be using the site though.  If you have any ideas you'd like to share, feel free to comment below or leave some "private feedback":http://rails.techno-weenie.net/feedback.  I don't have a real concrete plan, however.  I've just been taking it one step at a time and knocking out bugs/features as I feel like it.  
