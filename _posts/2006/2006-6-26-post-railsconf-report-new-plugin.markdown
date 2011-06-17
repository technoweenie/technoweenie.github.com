--- 
layout: post
title: Post RailsConf Report + New Plugin
---
It was great to see all the "faces":http://facebook.railsconf.org/ at RailsConf 2006.  Seems like a lot of you are becoming interested in Mephisto, which means Justin and I have some work ahead of us.  I'd have to say though, that no conference *rocked* as much as Adam Keys' "AC/DC / Stravinsky":http://railsconf.org/talks/selected/show/131 talk.  

"Dan":http://hivelogic.com/articles/2006/06/24/exception_logger managed to beat me to blogging my new "exception logger":http://svn.techno-weenie.net/projects/plugins/exception_logger/ plugin.  This is basically a copy of Jamis' "exception notification":http://dev.rubyonrails.org/svn/rails/plugins/exception_notification/ plugin, only it uses AR to log them and provides a nifty UI to filter and remove them.  Check it out, pound on it, let me know what you think.  Now, this will add a controller to your app that you may want to require authorization.  Use a similar technique to my "bounty source svn plugin":http://rails.techno-weenie.net/tip/2006/5/31/adding_authentication_to_bssvnbrowser to inject whatever login scheme your app uses.  I'd really like to thank "Josh Goebel":http://dwgsolutions.com/ for helping out with the UI stuff.  Though I would've been content to keep it unstyled, he added some swanky "pastie":http://pastie.caboo.se/ flavor to it (yikes....).
