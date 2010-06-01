--- 
layout: post
title: More on the data source debate
---
"Do data source controls belong on the page?":http://blogs.msdn.com/bleroy/archive/2004/07/12/180921.aspx  This is a larger blog conversation about many things Whidbey, including the DataSource controls.

Maybe the key is to look at the page as an _application surface_, rather than a UI surface.  Also, a DataSource control provides a bit of abstraction.  You can quickly build a prototype with an AccessDataSource.  Then, as the application evolves, maybe swap it out with an SqlDataSource or ObjectDataSource without changing the page.  That's a nice idea, but you still get the Reflection tax with ObjectDataSources.  
