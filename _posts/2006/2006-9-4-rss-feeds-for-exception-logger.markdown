--- 
layout: post
title: RSS Feeds For Exception Logger
---
!http://weblog.techno-weenie.net/assets/2006/9/4/logged_exceptions.png!

I've finally gotten around to integrating the "exception logger plugin":http://weblog.techno-weenie.net/2006/6/26/post-railsconf-report-new-plugin into Beast.  Not only does this give me a convenient way to monitor any unhandled exceptions, it also sets up simple 404/500 pages.  Currently, rails will manually write out the dreaded "Rails Application Error" message, _even though_ it creates those 404.html/500.html pages in your public directory.  This is easy enough to change by overriding rescue_action_in_public, but it's also something handled by exception_logger (and "exception_notification":http://dev.rubyonrails.org/svn/rails/plugins/exception_notification/).

The big news for this update though, is I have added RSS feeds for your unhandled exceptions.  The feed takes the same query params, so you can create customized exception feeds.  The challenge was making it easy to integrate with any app.  Beast's authentication system is very basic, with no HTTP Basic support.  I added the required methods to the plugin and ended up "wrapping Beast's login_required with alias_method_chain":http://pastie.caboo.se/11613.
