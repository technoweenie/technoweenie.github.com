--- 
layout: post
title: "ASP.Net Lesson #45,236"
---
ASP.Net URL Rewriting is "amazingly easy":http://weblogs.asp.net/jezell/archive/2004/03/15/90045.aspx.  I wrote a simple Regular Expression URL Rewriter that poorly mimics some "mod_rewrite behavior":http://httpd.apache.org/docs/misc/rewriteguide.html.

But, you run into a problem on postbacks.  If your virtual path of <code>/catalog/products/widget.aspx</code> maps to <code>/catalog.aspx?product=widget</code>, the wonderful HtmlForm will use a relative <code>catalog.aspx</code> as its Action property.  So, your browser will think you're trying to postback to <code>/catalog/products/catalog.aspx</code> which probably doesn't exist.

There are two solutions I've seen:

# "a custom HtmlTextWriter":http://weblogs.asp.net/jezell/archive/2004/03/15/90045.aspx
# "a subclassed HtmlForm":http://www.devhood.com/messages/message_view-2.aspx?thread_id=94884

I personally prefer the subclassed form.  It's simple, and can be extended to write "valid XHTML":http://www.liquid-internet.co.uk/content/dynamic/pages/series1article1.aspx also.
