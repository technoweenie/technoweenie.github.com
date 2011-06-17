--- 
layout: post
title: death by spam
---
I didn't plan to add this before the first Mephisto release, but Mephisto now has integrated "Akismet":http://akismet.com/ spam blocking.  Mephisto has been smooth sailing for a while now.  Despite some rough patches in the UI, a few unimplemented functions, and an embarrassing lack of documentation, I would have said Mephisto was ready for an initial release.  But then I noticed one of my posts getting some spam.  I noticed the "Fluxiom blog":http://blog.fluxiom.com/ getting a *lot* of spam (yes, it's on Mephisto).

So, I sat down one night and hacked in basic Akismet support.  It was actually very easy, using "David Czarnecki's ruby lib":http://www.blojsom.com/blog/nerdery/2005/12/02/Akismet-API-in-Ruby.html.  All you need is a wordpress.com API key, and you're set.  

Having done this, I worry about locking Mephisto into the Akismet service.  Am I now forcing any commercial users of Mephisto to pay for a commercial license for Akismet?  I would rather have something built-in and free naturally, I just have no desire to get into a little "spamming arms race":http://www.intertwingly.net/blog/2006/05/30/Captcha-this.  It doesn't seem like there's much you can do that some spammers won't find a way around. 
