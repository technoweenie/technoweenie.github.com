--- 
layout: post
title: ".Net Web Services Lesson #1"
---
Do not use Collections in your web services!  I'm assuming the XmlSerializer has problems serializing and deserializing them, but I kept getting some wacky "cannot find w329csd.dll" (the DLL kept changing).  

All the google-hunting I did led me to requests to make sure the ASPNET account has permissions to this temp directory, and that temp directory, and so on.  

So, I took out all the Collection objects, changed the web service methods to return arrays instead, and everyone's happy again.
