--- 
layout: post
title: ActiveDocument
---
This is just a quick post, but I've started playing around with "thrudb":http://code.google.com/p/thrudb/, and naturally, writing a ruby library for it.  It's still incredibly rough.  The indexing code is busted since I started testing with a mock manager class instead of the actual thing, so about all it does is saves and fetches records at the moment. 

You can get the code from:

<pre><code>
git://git.caboo.se/activedocument.git.
</code></pre>

Note:  I have an experimental json branch and a sample app to "pit the 2 data stores against each other":http://weblog.techno-weenie.net/2008/1/14/benchmarking-activedocument-vs-activerecord.
