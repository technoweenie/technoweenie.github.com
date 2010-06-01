--- 
layout: post
title: rails best practices part two
---
There's a discussion on the ROR(Ruby on Rails) list about optimizing database access.  "David":http://loudthinking.com posted "some ideas":http://one.textdrive.com/pipermail/rails/2005-March/004159.html for a per-request cache of Active Record (AR) objects.

I actually thought about implementing something like that by overriding the find() calls in my AR objects, but I went ahead and implemented "this method":http://www.loudthinking.com/arc/000235.html.  It worked great.
