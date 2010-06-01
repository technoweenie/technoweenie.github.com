--- 
layout: post
title: svn moved
---
-I'm in the middle of moving servers (waiting for DNS it seems).  If you've noticed that http://techno-weenie.net/svn/projects doesn't work, it's because I'm having some issues getting the litespeed proxy context working.-

-Until I get all that straightened out, please use http://svn.techno-weenie.net/svn/projects/ (which is a few versions old, I'll update tomorrow).-

Everything is setup now.  Both this weblog and Rails Weenie are now running on a Litespeed + Mongrel backend.  The only casualty is my old svn location.  Everything is now available at "http://svn.techno-weenie.net/projects/":http://svn.techno-weenie.net/projects/.

<pre><code>
rick@project-mayhem-2:~/p/mephisto% svn info
Path: .
URL: http://techno-weenie.net/svn/projects/mephisto
Repository Root: http://techno-weenie.net/svn/projects
...

rick@project-mayhem-2:~/p/mephisto% svn switch --relocate http://techno-weenie.net/svn/projects/mephisto http://svn.techno-weenie.net/projects/mephisto

rick@project-mayhem-2:~/p/mephisto% svn info
Path: .
URL: http://svn.techno-weenie.net/projects/mephisto
Repository Root: http://svn.techno-weenie.net/projects
</code></pre>
