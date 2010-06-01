--- 
layout: post
title: rails weenie needs its own help
---
Announcing my latest app and watching it die every fifteen minutes was a bit embarrassing.  Apparently I've been cut by bleeding edge yet again.  There's some work going on with the Mysql adapter, and it happened to be wreaking havoc with my setup.  In the end I just copied the adapters from the stable branch of Rails, and all is well.  

If you want to develop with a stable branch of Rails that will eventually become 1.0, point your working copy to http://dev.rubyonrails.org/svn/rails/branches/stable/.

*update* - Doh, spoke too soon.  Now I get this when trying to add an article: <code>undefined method `prefetch_primary_key?' for #<ActiveRecord::ConnectionAdapters::MysqlAdapter:0x8eb0b88></code>.  Oy.

*update 2* - I'm on postgresql and things are running smoothly..
