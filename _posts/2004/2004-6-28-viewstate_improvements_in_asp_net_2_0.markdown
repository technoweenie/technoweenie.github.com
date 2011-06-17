--- 
layout: post
title: viewstate improvements in ASP.Net 2.0
---
Nikhil Kothari goes over "Viewstate improvements in ASP.Net 2.0":http://www.nikhilk.net/Entry.aspx?id=36.  Looks like it uses a binary formatter (instead of a text one) that's more efficient and faster.  

This is all monumentally important if you've ever seen the viewstate of an ASP.Net page with a datagrid.
