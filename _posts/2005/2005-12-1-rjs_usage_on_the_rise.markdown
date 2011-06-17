--- 
layout: post
title: RJS usage on the rise
---
Looks like Scott Raymond "discovered RJS templates":http://scottraymond.net/articles/2005/12/01/real-world-rails-rjs-templates too (or rather, deployed his app).  They've completely changed the way I use AJAX to update page elements (as Scott illustrated with his code snippets).  Now I'm writing even _less_ javascript code and using the rails javascript helpers more. 

There is one issue I've run into, however.  With more actions running through javascript eval, it's getting difficult to troubleshoot problems.  When you get an exception while developing, you're presented with an exception stack trace.  Simple AJAX calls still sent HTML, so you might see an exception trace appended to your list of articles, instead of the created article.

However, RJS sends raw javascript calls that Prototype will eval.  When an exception occurs, however, Rails will send the HTML stack trace.  So, if you're developing some sick AJAX effects, but your spinner keeps spinning, check your development logs.  Chances are your controller raised an exception and javascript choked trying to eval the HTML.
