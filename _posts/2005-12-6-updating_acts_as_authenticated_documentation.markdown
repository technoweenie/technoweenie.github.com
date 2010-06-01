--- 
layout: post
title: updating acts_as_authenticated documentation
---
I feel one of the weak areas of acts_as_authenticated is the documentation.  I tried to include a lot of help in the source code, but a lot of folks want to know more about it BEFORE it's generated.  

So here's what I did:  I filled out the "README":http://techno-weenie.net/svn/projects/plugins/acts_as_authenticated/README a bit more.  I list all the generators and give a bit more information on them.  Drill down in the actual source code for more detailed help.

I also added a quick "install.rb":http://techno-weenie.net/svn/projects/plugins/acts_as_authenticated/install.rb script that prints the README when the plugin is installed.   This is a new feature that "noradio recently checked in":http://dev.rubyonrails.org/changeset/3215.  

Does this help at all?  Does anyone have any ideas on what else I could do?  
