--- 
layout: post
title: Rails v0.11 released
---
"Rails v0.11 has been released":http://weblog.rubyonrails.com/archives/2005/03/22/rails-0110-ajax-pagination-non-vhost-incoming-mail/.  Wonderful Ajax support in the form of "helper functions":http://rails.rubyonrails.com/classes/ActionView/Helpers/JavascriptHelper.html, "pagination":http://rails.rubyonrails.com/classes/ActionController/Pagination.html support, non-VHOST(Virtual Host) setups, and more.

I'll write up more on the Ajax stuff once I've had a chance to play with it.  The way I'm using Ajax in my current app differs greatly, so I'll see how this all works out.

The fact that one can install multiple Rails apps under a single virtual host is a very nice addition.  If this works as advertised, I think my only other wish is IIS support.  However, this isn't really a Rails issue, more an issue of the lack of a "decent FastCGI filter for IIS":http://www.caraveo.com/fastcgi/.  I found one, but it hasn't been updated since 2002.  Perhaps all the non-Windows developers loathe IIS and all the Windows developers have moved beyond CGI (ASP.Net for instance) and aren't willing to drop back into the fun! fun! fun! world of C++ ISAPI filters.  
