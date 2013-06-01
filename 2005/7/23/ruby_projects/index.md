--- 
layout: post
title: ruby projects
---
Just a heads-up, I have set up an instance of "Collaboa":http://collaboa.org at "http://collaboa.techno-weenie.net":http://collaboa.techno-weenie.net.  From here I'm hosting my "acts as versioned":http://collaboa.techno-weenie.net/repository/file/rails_ext/active_record/acts/versioned.rb extension (without unit tests, you need the "full patch":http://dev.rubyonrails.org/ticket/1758 for that), my "sentry":http://collaboa.techno-weenie.net/repository/browse/sentry gem (painless encryption in ActiveRecord), and finally, "Supasite":http://collaboa.techno-weenie.net/repository/browse/supasite, a drop-dead simple CMS.

Supasite is actually the name of "my goofy PHP-based blogging app from 2001":http://sourceforge.net/projects/supa-site/ (it's a requirement to write a blogging tool for all PHP developers).  According to Sourceforge, it's still "being downloaded":http://sourceforge.net/project/stats/index.php?group_id=31758&ugn=supa-site&type=&mode=alltime.  I'd like to apologize right here for any grief my horrible coding may have caused anyone...

Anyways, Supasite (on Rails) came about for two reasons.  One, I wanted a simple way to add DB-backed pages to "my BillBoards app":http://weblog.digett.com/2005/07/20/billboards-progress/ at work.  At the moment, I have to define a controller, create the view, and upload it.  I'd much rather just log into a database and have it show up immediately.  I plan to extract the important bits out as a set of components so it'd be easy to use on any rails app.  We'll see how that goes.  Supasite also serves as an example app for my acts_as_versioned extension.  It'll have the ability to rollback changes.

Supasite also inadvertently became the example app for poor ajax design.  I tried to go with a single-page admin area that handles all the actions to build sections and pages.  Don't try it at home, kids.  
