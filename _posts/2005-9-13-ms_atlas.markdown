--- 
layout: post
title: MS Atlas
---
It's apparently PDC time, and Microsoft's Ajax framework, "Atlas":http://atlas.asp.net/, has documentation available, with a hands-on lab for those playing along at home.  

*Update*:  I haven't had much of a chance to look at the developer materials for Atlas, so I'm very glad that "Thomas":http://mir.aculo.us/articles/2005/09/15/hello-atlas-auto-complexion did.  Just looking at the "overview on Scott Guthrie's blog":http://weblogs.asp.net/scottgu/archive/2005/06/28/416185.aspx, it looks like MS is favoring .net -> javascript object serialization as opposed to rendered html fragments that Rails favors.  I've "toyed with serialization":http://www.bigbold.com/snippets/posts/show/474 a bit, but sending HTML is simpler to write, test, and debug.  That is truly the simplest way to have that sweet, sweet ajax while writing very minimal javascript.

As a true testament to the scriptaculous library, I read over both single page tutorials on the AutoCompleter and extended the local array AutoCompleter to use a hash of arrays instead.

This is another reason why I'm not thinking twice about using rails: I don't have to hide behind "complex server controls":http://weblogs.asp.net/scottgu/archive/2005/09/13/425062.aspx to get stuff done.
