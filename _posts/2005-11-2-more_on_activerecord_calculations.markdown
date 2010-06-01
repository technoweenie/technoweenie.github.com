--- 
layout: post
title: more on ActiveRecord Calculations
---
Well, everyone that saw my Calculations plugin had the same thing to say: the higher order methods suck.  Passing the group by and having values as options is closer to the established find() method signature.  Let this be a lesson to any API designers: go for *familiarity* and *conventions* over clever tricks.

It also made the library simpler and shorter.  Why do I like to make things difficult?

If you've already been using it, change your method calls from:

<pre><code>Order.calculate(:sum, :cost).group_by(:country).having { |x| x > 75 }</code></pre>

to

<pre><code>Order.calculate(:sum, :cost,
  :group => :country,
  :having => 'sum(cost) > 75')</code></pre>

If you live life on the rails edge, here's how to install it:

<pre></code>ruby script/plugin install http://techno-weenie.net/svn/projects/calculations</code></pre>
