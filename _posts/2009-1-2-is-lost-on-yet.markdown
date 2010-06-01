--- 
layout: post
title: is LOST on yet?
---
I needed to know, so I wrote one of those trendy single page apps: [is LOST on yet?](http://islostonyet.com/).  Naturally, the source [is on github](http://github.com/technoweenie/islostonyet.com/tree/master).  It's really pretty amazing actually:

    def is_lost_on_yet?
      @is_lost_on_yet ||= {:answer => "no", :reason => "returns on Jan 21st, 9PM ET"}
    end

I have about 20 days to finish the site :)

*Update:* I forgot to mention, it even has [JSON support](http://islostonyet.com/json?callback=foo)!  
