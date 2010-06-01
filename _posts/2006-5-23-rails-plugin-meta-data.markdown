--- 
layout: post
title: Rails plugin meta data
---
So, Geoffrey ("topfunky":http://nubyonrails.com/) threw out a little idea tonight: What if plugins had some basic metadata attached to them? This will make it easy for "plugin directories":http://agilewebdevelopment.com/plugins to grab the "basic info":http://svn.techno-weenie.net/projects/plugins/acts_as_attachment/meta.yml.

For now, we're going with a YAML version of a gem spec:

<pre><code>
author: technoweenie
summary: File upload handling plugin.
homepage: http://technoweenie.stikipad.com
plugin: http://svn.techno-weenie.net/projects/plugins/acts_as_attachment
license: MIT
version: 0.3a
rails_version: 1.1.2+ (hint at what version of rails to use this on)
</code></pre>

I also committed  a small addition to script/plugin that let's you display this file.  <code>script/plugin info acts_as_attachment</code>.  Now that I think about it, I think I may change that to script/plugin about, and about.yml for the metadata info.

Thoughts?  

Oh and by the way... "it is *on*":http://www.railsday2006.com/.
