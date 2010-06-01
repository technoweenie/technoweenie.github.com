--- 
layout: post
title: Keeping Rails Plugins up-to-date
---
Due to the agile nature of rails plugins, it was necessary to keep them in sync using <code>svn:externals</code>.  Problem is, this added some unnecessary dependencies while developing and deploying.  I've since discovered and started using "Piston":http://piston.rubyforge.org to manage my plugin branches.

When using svn:externals, you're not just pulling from your own svn repository, you're pulling from 2, 3, or 4 other external repositories.  This can cause issues when the plugin author adds breaking changes, or when the site itself is down and you need to deploy.  

For this reason, I've been freezing the plugins in my own repository.  This forces me to manage the vendor branch by myself with some <code>svn merge</code> commands.  That'd be fine, if I could remember what version I was working with.  Piston keeps track of this through a few special svn properties.  

<pre><code>piston import http://svn.techno-weenie.net/projects/plugins/acts_as_attachment vendor/plugins/acts_as_attachment
piston update vendor/plugins/acts_as_attachment</code></pre>

I'm not sure, but I think you could modify the <code>piston:root</code> property directly if the plugin is moved to a branch or tag (Yes, the next script/plugin should support all this).
