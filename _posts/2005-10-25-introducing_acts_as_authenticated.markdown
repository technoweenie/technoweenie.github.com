--- 
layout: post
title: Introducing acts_as_authenticated
---
Someone asked about it, so I'm finally posting the code for acts_as_authentication, my replacement for the various login generators.  Why bother?  

* Most of the current login generators are old, still holding on to <code>find_first</code> calls.

* With the exception of the original Login Generator, they are usually pretty heavy.  Most of the times my app does not need internationalization or roles.

* Encryption is set to sha1 usually.

This is mostly a reworking of Tobi's Login Generator, implemented as plugins.  We're going for modular plugins that build on each other, not one all encompassing module that handles everything.  

Much "hacking and discussion ensued at RubyConf":http://flickr.com/photos/mattpelletier/52558075/, though we mainly got the user model hashed out.  I wrote the filter stuff waiting for my delayed plane trip home.  But, you'll notice the major part hasn't even been touched yet: controllers.  

I also borked my install of Collaboa, so all you get are subversion links:

"acts_as_authenticated":http://techno-weenie.net/svn/projects/acts_as_authenticated/ and "authenticated_system":http://techno-weenie.net/svn/projects/authenticated_system/.
