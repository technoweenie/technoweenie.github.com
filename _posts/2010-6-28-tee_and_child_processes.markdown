--- 
layout: post
title: Tee and Child Processes
---

My first node.js project at GitHub is a replacement download server.  I wanted to remove the extra moving pieces required to get it to work.  Currently, the download server works like this:

1. You click a link like http://github.com/technoweenie/faraday/tarball/master to download an archive. 
2. The Rails action schedules a job in Resque to build the archive.  Some git repos can get over 100MB, so we can't exactly do this in the Rails process.
3. Once the job is scheduled, you're sent to waitdownload.github.com to wait for your prize.  The process simply checks for the existence of a memcache key to let it know the download is ready.
4. Waitdownload redirects to download.github.com, an nginx server, to serve the file.