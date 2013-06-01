--- 
layout: post
title: Cookie Support for Acts as Authenticated
---
I just committed a contribution to "acts_as_authenticated":http://svn.techno-weenie.net/projects/plugins/acts_as_authenticated/ by cnf (from #rubyonrails): cookie token support.  Try it out and let me know if it works.  A dummy project created with it passed all tests.

Also, PJ Hyett discusses the values of "session-less requests":http://pjhyett.com/articles/2006/07/02/turn-off-sessions in Rails, and mentions a cookie version of acts as authenticated.  Sounds like it might be a smart way to go.  Though, I can't imagine it'd be much more then hacking the current_user accessors and the login_as test helper.
