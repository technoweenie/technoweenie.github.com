--- 
layout: post
title: Five reasons why your next Rails mod should be a plugin
---
The next time you're wondering whether to submit some experimental ticket to Rails, build a plugin instead.

* First, it's much easier to keep track of changes yourself.  Trust me, subversion or darcs makes for a _much_ better version control system than a trac ticket.
* It's a lot easier to get folks using your work.  It's not exactly trivial for someone to download and patch their rails.  However, it is a snap to dump some files in vendor/plugins to try it out.  
* Real-world use gives your plugin a chance to evolve as necessary.  Nothing proves the validity of your plugin's features than working, tested code in live applications.
* If the plugin is accepted into core, the plugin provides an upgrade path for users on older versions of rails.
* If the plugin is not accepted, you still have a simple way to utilize this functionality in your applications.

If you've never written a plugin before, "Rails Recipes":http://www.pragmaticprogrammer.com/titles/fr_rr/index.html by "Chad":http://chadfowler.com/ contains a chapter that I contributed on the very subject.  I'd highly recommend picking it up for the 70 other recipes.  There are other free resources too, starting with the "Rails Wiki":http://wiki.rubyonrails.com/rails/show/plugins and "lots":http://dev.rubyonrails.org/svn/rails/plugins/ of "existing":http://svn.techno-weenie.net/projects/plugins/ "plugins":http://topfunky.net/svn/plugins/ to "look":http://svn.pragprog.com/Public/plugins/ "from":http://www.codyfauser.com/svn/projects/plugins/.
