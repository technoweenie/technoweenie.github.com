--- 
layout: post
title: what is 'mephisto' anyway?
---
Lately, there has actually been some interest in Mephisto, my little blogging app.  It started out as my own personal escape from other blogging apps that _just_ didn't do it for me.  It's still not ready and polished for heavy use yet.  But since it's out there being used already, I figured I'd start talking about it some.

If you happen to check it out from subversion, be sure to run the task <code>rake install_mephisto</code> to get going.  This sets up the database schema and the default liquid templates.  Now one area that is severely lacking is the documentation.  The current default template is very plain, and won't give you an idea of what you can accomplish with the Mephisto liquid tags.  If you're adventurous, you can pull up "an old dump of this weblog's templates":http://techno-weenie.net/templates.yml.  Oh by the way, this requires "edge rails":http://wiki.rubyonrails.com/rails/pages/EdgeRails.  I have a "rails weenie tip":http://rails.techno-weenie.net/tip/2006/2/7/deploy_your_apps_on_edge_rails on setting that up.

One question I get asked a lot though, is where does the name come from?  Mephisto the name is actually a reference to a "Marvel Comics Villain":http://www.geocities.com/marvel_villain/mephisto/mephisto.html.  I was fishing for names and was fond of "manifest."  I didn't get many warm reactions to the name, so I dug into my geek roots and pulled out 'Mephisto.'  I can't say I'm even a fan of the character, but the name stuck.

*Update:* atmos added a more detailed walkthrough on "setting Mephisto up with Switchtower":http://www.atmos.org/articles/2006/02/10/deploying-mephisto-with-switchtower
