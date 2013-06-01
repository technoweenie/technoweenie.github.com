--- 
layout: post
title: Mongrel Upload Progress Documentation
---
The functionality has been working for about two months, but I've just now gotten around to writing up documentation for the "Mongrel Upload Progress Plugin":http://mongrel.rubyforge.org/docs/upload_progress.html.  If you want to try this out now before the Mongrel 0.3.13.4 release, here's how you can build it manually:

<pre><code>gem install mongrel --source=http://mongrel.rubyforge.org/releases/

svn co svn://rubyforge.org/var/svn/mongrel/trunk/projects/mongrel_upload_progress
cd mongrel_upload_progress
rake install
</code></pre>

The final command will build the mongrel_upload progress gem locally and install it for you.  At this point, you can continue on with the "Upload Progress Documentation":http://mongrel.rubyforge.org/docs/upload_progress.html.  I also have a "screencast":http://s3.amazonaws.com/techno-weenie-screencasts/mongrel_drb.mov of myself, playing with the DRb interface. 
