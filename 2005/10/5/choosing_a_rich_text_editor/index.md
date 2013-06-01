--- 
layout: post
title: choosing a rich text editor
---
I'm working on a project that needs a WYSIWYG editor, so I've been investigating several of them.  "TinyMCE":http://tinymce.moxiecode.com/ worked well, but I have a beef with its configuration.  It seems flexible enough, but I don't have a desire to write my own plugin.  I simple just want to add/remove buttons as I please.

I've used "HTMLArea":http://www.dynarch.com/projects/htmlarea/ in the past, and found it to be pretty decent.  It's the only one I know that comes with a free cross-platform spell checking component as well.  However, the project seems stagnant.  The final killing blow is that the "prototype":http://prototype.conio.net library interferes with it.  Maybe I can dig in there and figure out why, but I don't quite feel like it right now.  That's a shame, because it's simple to configure and works well.

I've personally never liked actually using any of these editors, as they all seem a bit dodgy to me.  However, there are still people that can't grok simple formatting symbols.  They don't know what RSS is, or care about your blogs.  They just want to write copy for their website.  It just seems natural that the browser should have a decent writing environment to accomodate that.

Web services are an option, but I'd still prefer to have something that doesn't require an installation.  Also, Jeremy briefly talks about "using RailsFS to manage your document workflow":http://www.jvoorhis.com/articles/2005/09/26/ideas-for-railsfs. Hmm.
