--- 
layout: post
title: debugging your RJS calls
---
So, Rails Weenie has been having these odd comment posting issues for awhile now.  I've been trying to reproduce it locally, but comments post every time, and all my unit tests pass.  What's a guy to do?

I took Sam's "Ajax Responder":http://project.ioni.st/post/280#post-280 sample and ran with it.  I wrote a "very basic responder":http://rails.techno-weenie.net/tip/2005/12/20/debugging_your_rjs_calls that simply logs your ajax calls.  And after all that, I can't reproduce the problem on the live site now.  Hmm.  Is it fixed now?
