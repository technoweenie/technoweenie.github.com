--- 
layout: post
title: Calendar About Nothing
---
Several months ago, I was listening to one of the "Gitsplosion!":http://odeo.com/channels/2116099-Gitsplosion podcasts.  PJ was talking about ant juice, and Chris suggested starting a "seinfeld calendar":http://lifehacker.com/software/motivation/jerry-seinfelds-productivity-secret-281626.php to mark your progress on wearing your Github t-shirts every day for a month.  I'd been looking for a cool "microapp":http://metaatem.net/2008/05/30/my-railsconf-talk to build for awhile, and thought I could use this calendar idea. However, I have no idea how to confirm if someone is actually wearing a Github shirt, so I decided to scan public "Github":http://github.com feeds.

After I let my microapp sit around unfinished for several months, "Kyle":http://warpspire.com whipped up a basic layout, and I launched the "Calendar About Nothing":http://calendaraboutnothing.com/.  

I also decided to use various frameworks that are unfamiliar to me: Sinatra, Datamapper, and HAML.  The code itself "isn't anything special":http://github.com/entp/seinfeld/tree/master.  It's a big hack that'll hopefully get refactored as time goes on, and more sources get added.  Let me know if you have any ideas of other sources I can check ("Gitorious":http://gitorious.org/ and "bitbucket":http://www.bitbucket.org/ spring to mind).  Ideally, you'd be able to take the mythical calendar source API and implement your own private hooks that read private repositories on your own hosted calendars. 
