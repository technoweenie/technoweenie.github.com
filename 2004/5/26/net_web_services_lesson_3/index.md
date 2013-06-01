--- 
layout: post
title: ".Net Web Services Lesson #3"
---
Xml Serialization in .Net will serialize your objects to and from XML, for storage on disk or transfering to another system.  In fact, Remoting and Web Services are based on it.

The problem is, it sometimes gives some unhelpful error messages due to the voodoo it works in the background.  Chris Sells' "XmlSerializerPreCompiler":http://www.sellsbrothers.com/tools/#XmlSerializerPreCompiler tool shows you the background compiler errors occurring when serializing or deserializing.  On top of that, Christoph Schittko mentions an "XmlSerializer debug switch":http://weblogs.asp.net/cschittko/articles/33045.aspx to keep the temporary serialization classes in the temp directory.

Too bad neither of these helped _my_ little problem today.  I could serialize a class all day long.  But, when I built a WebService proxy from a WSDL file in a seperate project, the same class would not deserialize the class properly.  The problem?  When building the WebService proxy class from WSDL, it adds the Web Service namespace with the <code>XmlTypeAttribute</code> attribute.  So, I added the same attribute to the original class, and everyone's happy.
