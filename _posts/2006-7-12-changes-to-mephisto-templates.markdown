--- 
layout: post
title: changes to mephisto templates
---
This is probably the largest update in awhile: all templates and resources are now stored on the filesystem.  I originally wrote acts_as_attachment so I could store this stuff in the database and have nice things like versioned templates.  However, my biggest feature request was the ability to modify templates by hand and upload them.  So now, they're stored in RAILS_ROOT/themes/site-#{site_id}/....  

Be careful when upgrading.  All tests pass, and some complex template code was swapped out for simpler code, but there may still be some nasty bugs I haven't seen.  It ran fine on my blog however.  We'll see how it goes on the Rails blog next.

*Update*: rake db:bootstrap works now.  Sorry.
