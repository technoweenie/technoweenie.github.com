--- 
layout: post
title: The Lie
---
I do agree with Francis on [about everything else](http://fhwang.net/2009/02/09/On-fixtures-and-first-time-testers) though: Fixtures do suck, and testing is really fucking hard.  By the time you realize you're getting into Fixture Hell, moving your monstrosity of an application off fixtures is a daunting task.  My solution (and currently the ENTP way): [Machinist](http://github.com/notahat/machinist).

The problem I've had with fixtures, is that having one large set means that tiny tweaks can break tests all over the place.  Also, working with YAML makes me a sad monkey.  [Fixture Scenarios](http://code.google.com/p/fixture-scenarios/) helped solve the first problem, but not the second.  

I then worked on [Model Stubbing](http://github.com/technoweenie/model_stubbing).  My idea was that I could introduce stubbing definitions (groups of sample data) with a rubyish syntax.  You could use a single stubbing definition for the app, or create one for a specific test case (from scratch, or by inheriting from an existing definition).  This flopped too.  Despite my efforts, this too dragged a project into Model Stubbing Hell.

I'm not even going to get too much into the rspec mocking.  When I see code that stubs `find` or `save`, I cringe.  Though after talking with David a bit, this was more a case of something being lost in translation.  You should be replacing your mocks with live code once it's implemented.  It's a tool for ping-pong programming, not making your tests fast and fragile.

So, this bring us to Machinist.  It doesn't do anything magical, it just creates valid records based on a blueprint that you define:

<pre><code>Post.blueprint do
  title "Example Post"
  body  "Lorem ipsum dolor sit amet"
end

Comment.blueprint do
  post
  author { Sham.name }
  body   "Lorem ipsum dolor sit amet"
end</code></pre>

The problem here, though, is that factories and manual record creations tend to slow down your tests greatly.  I try to use `before(:all)` to help, but I definitely miss a lot of the work that fixtures go through to keep tests speedy.

What can Rails do to help the situation?  Personally, I'd support the notion of dropping fixtures all together.  But, as someone that hasn't used fixtures since before foxy fixtures were introduced, I'm not at all bothered by having to ignore them.  Though there is one solution:

[Time Travel :)]((http://techno-weenie.net/assets/2009/2/9/donkeywheel.jpg) (linked for spoiler prevention)

*Updated:* Removed the season 5 spoiler... I figured any LOST junkie would've seen it already, but apparently some of you are more patient than I am.   
