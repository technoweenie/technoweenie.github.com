--- 
layout: post
title: RSS Updates for my Subversion Repositories
---
"Chris":http://ozmm.org/ was the latest person to ask me about RSS updates for Mephisto.  I did a little looking, and I found this nifty "svnlog xslt":http://codingmonkeys.de/map/log/articles/2003/10/07/svnlog-xslt from a coding monkey.  Only problem was, it creates a feed for a whole repository.  However, my public one is made up of several projects and a lot of plugins.  (I don't normally advocate setting up One Repository to Rule Them All, but it requires a textdrive support ticket so they can set the permissions for anonymous read-only.)  In the end, I made 3 copies of the xslt to tweak the title, and wrote a shell script for a cron job:

<pre><code>/usr/local/bin/svn log file:///usr/home/technoweenie/svn/projects/$1 --limit 15 -v --xml > /usr/home/technoweenie/tmp-$1.xml
/usr/local/bin/xsltproc /usr/home/technoweenie/bin/svnlog/$1.xslt /usr/home/technoweenie/tmp-$1.xml > /usr/home/technoweenie/public_html/changesets/$1.xml
rm /usr/home/technoweenie/tmp-$1.xml</code></pre>

Point your browsers to "http://techno-weenie.net/changesets/":http://techno-weenie.net/changesets/ and see what's available.
