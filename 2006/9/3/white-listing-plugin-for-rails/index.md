--- 
layout: post
title: White Listing Plugin for Rails
---
I "threw down the gauntlet":http://beast.caboo.se/forums/5/topics/319, challenging anyone to post XSS hacks on Beast.  The community accepted and brought in some challengers that defeated "sanitize":http://rails.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#M000516.  Today, I answer the pleading call of <code>sanitize</code> with the "white list plugin":http://svn.techno-weenie.net/projects/plugins/white_list/.

bq. "This White Listing helper will html encode all tags and strip all attributes that aren't specifically allowed.  It also strips href/src tags with invalid protocols, like javascript: especially.  It does its best to counter any tricks that hackers may use, like throwing in unicode/ascii/hex values to get past the javascript: filters.  Check out the extensive test suite."
