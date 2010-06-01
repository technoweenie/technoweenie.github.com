--- 
layout: post
title: comicbook photostream
---
So, I got hooked on the "Flickr":http://flickr.com bandwagon.  It's a very nice photo management web application, with plenty of web service hooks to play with.  

I thought it would be cool to post the latest pics of comics I'm picking up.  So, I hacked up a PHP script to grab my public photostream ATOM feed, save the latest photo to the local server, and put together some HTML to display it.  It's using "Magpie's":http://magpierss.sourceforge.net/ built-in caching, and the last-mod date of the local saved image to make sure I'm a good internet citizen.  

I don't want to hear how crappy my PHP code is, because I know _all_ about it.  I plan to write a python script to handle this somewhere other than on each request of the site's index.  I figure it won't be long before some python flickr libs  will be out so I can load a flickr filesystem next to my gmail filesystem.  Wee!

*Update*: The code has been removed due to display problems in IE.  I tried like hell to get the overflow property to work, but it just wasn't meant to be.  Anyhow, I have a "link to the source code":/code/2004/09/flickr.php.txt...
