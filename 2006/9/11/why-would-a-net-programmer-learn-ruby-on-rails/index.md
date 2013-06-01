--- 
layout: post
title: Why Would a .NET Programmer Learn Ruby on Rails?
---
Stephen Chu wrote up a little article on "Why Would a .NET Programmer Learn Ruby on Rails?":http://www.infoq.com/articles/Netter-on-Rails  But, I think he missed a few big ones:

* "ASP.Net's Page Lifecycle":http://msdn2.microsoft.com/en-us/library/ms178472.aspx is awful.  This approach may work in other environments like GUIs, but not the web.  

* "HTML Control Adaptive Rendering":http://aspnet.4guysfromrolla.com/articles/050504-1.aspx makes debugging a pain in the ass.  You'll get those situations where it works in IE, but not Firefox, because it's being treated as a downlevel browser and receiving different HTML.

* Metaprogramming in C# is a joke.  Compare the "System.Reflection":http://msdn2.microsoft.com/en-us/library/system.reflection.aspx namespace to ruby.

In the end, it really depends on what types of applications you want to build.  Rails has been a great fit for me personally.  I find myself much happier and "productive":http://svn.techno-weenie.net/projects.
