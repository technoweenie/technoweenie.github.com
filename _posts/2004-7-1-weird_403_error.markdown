--- 
layout: post
title: Weird 403 Error
---
Just recently, I started receiving some odd 403 Forbidden errors at work when dealing with ASP.Net web services.  It was especially odd because the requests would work fine in my browser, but not <code>wsdl.exe</code> or using <code>System.Net.WebRequest</code> from a console app.

* I checked my IIS settings, they allowed anonymous connections and restrict no IPs.
* I checked my web project, it had no authentication, and allowed everyone (*).
* I turned on full auditing and saw nothing in my security or HTTP logs.

So, I tried turning off my work proxy access in IE.  It worked!  The weird thing is, I have an exception for the in-house servers.   Then, I realized the server I was accessing was on a nonstandard port.  I added this to my proxy exceptions in IE, and everything worked fine:

<code>*.server.com:*</code>

That will allow all requests to my in-house on any funky port through without passing GO (or the proxy server).
