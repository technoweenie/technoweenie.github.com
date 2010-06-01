--- 
layout: post
title: i got my hash pipe
---
"Eric Lippert":http://blogs.msdn.com/ericlippert/ has a great three part series ("1":http://blogs.msdn.com/ericlippert/archive/2005/01/28/362587.aspx, "2":http://blogs.msdn.com/ericlippert/archive/2005/01/31/363844.aspx, "3":http://blogs.msdn.com/ericlippert/archive/2005/02/03/366274.aspx) on why you should implement a salted hash user authentication system in your apps.

The only issue is there's no way to retrieve the password if the user needs it.  It's not a show stopper if you provide a method to reset the user's password and require them to change it upon logging back in.
