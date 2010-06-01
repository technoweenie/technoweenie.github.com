--- 
layout: post
title: updates to script/plugin
---
I've been doing a lot of work with plugins lately, but I found myself not using the script/plugin command all that much.  There's been some more work done on it since its release, namly a recursive http downloader that Chad Fowler provided for those without subversion.  I did a little work on the script to add some new features.  So, let me bring you up to speed on script/plugin usage:

Install with either http downloads or svn export: 
./script/plugin install my_plugin

Install with svn:externals
./script/plugin install my_plugin --externals

Checkout from svn:
./script/plugin install my_plugin --checkout

Checkout a specific revision from svn (works with externals and export too):
./script/plugin install my_plugin --checkout --revision 50

Download a plugin with no feedbacK:
./script/plugin install my_plugin --quiet

Reinstall a plugin (same as remove / install)
./script/plugin install my_plugin --force

I went ahead and moved my plugins into http://techno-weenie.net/svn/projects/plugins, updated the wiki page, and script/plugin discover picked my plugin repository up.  Sweet.
