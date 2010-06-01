--- 
layout: post
title: PHP5 Exceptions and Errors
---
PHP5 finally supports exceptions (and a lot of other OOP(Object Oriented Programming) features like C#/Java/etc), but there's a problem: PHP errors are still thrown.  It seems like you should be able to go all the way with exceptions, rather than dealing with both.

I've tried writing an error handler that simply throws a custom PHPException depending on the error.  It used a large switch statement to figure out what type of error occured, and returned an appropriate Exception.  Apparently this isn't a good idea since I managed to crash php.exe (PHP 5.0.0 windows binary).

Also, I've been running into a bug with call_user_func() and call_user_func_array(), where it triggers an error if the callback function throws an Exception.  There's already a "closed PHP bug":http://bugs.php.net/bug.php?id=25038 for it, but I still see the problem.  As the original bug poster mentioned, you can turn off error reporting or set an error handler as a workaround.
