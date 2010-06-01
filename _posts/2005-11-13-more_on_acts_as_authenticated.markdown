--- 
layout: post
title: more on acts_as_authenticated
---
It's ready:
<pre><code># add http://techno-weenie.net/svn/projects/plugins/
./script/plugin discover
./script/plugin install acts_as_authenticated
./script/generate authenticated user account
./script/generate authenticated_mailer user</code></pre>

Looking at it, you will notice I've done a complete 180 from the old plugin.  No more controller macros or act methods to learn, just plain old rails.  There are just some things that require configuration (flash messages, emails, default urls, etc).  Rather than coming up with some extensive config object to learn, or abstracting the logic into the plugin's libs, everything is generated in your app.  

It should provide a good building block to get your authentication off the ground.  Here are some notable differences from other systems I've used:

* Only the user ID is stored in the session.  I know, there's a whole extra query per page view now.  But, this keeps from having stale data in the session, and saves on memory.

* Sha1 encryption is default, but I've added an example of using an OpenSSL class to use a reversible encryption string for your passwords.  If you really need to email passwords back to users, this is at least slightly more secure than plain text.

If my authenticated generator doesn't fit your app, check out the "auth_generator":http://penso.info/code/auth_generator and "login engine":http://rails-engines.rubyforge.org/.  

*Update* - If things aren't working out, try updating the plugin from SVN and regenerating.  I've been making small generator tweaks, adding docs, etc.  I removed the login_required class method to remove some more _rails black magic_, and added comments for the test helpers.

*Another update*  Sorry for the SVN url.  I decided to move my plugins into their own directory so that script/plugin discover will pick it up.  Now you don't have to type my long svn address to install.
