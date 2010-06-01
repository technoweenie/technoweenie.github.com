--- 
layout: post
title: Restful Authentication Plugin
---
People have been asking me about it, so I decided to write it on the next small project I tackled.  That day came last week, so here's the plugin!

<pre><code>
script/plugin source http://svn.techno-weenie.net/projects/plugins
script/plugin install restful_authentication

script/generate authenticated user sessions
</code></pre>

I have no idea how restful logins are going to pan out.  This plugin differs from acts_as_authenticated by generating two controllers and requiring special routes.  But if you're a restful geek this should appeal to you.

h2. users controller

The nice thing about this is that the new/create actions relate to the resource that's created during the signup.  Simple apps will just use users/new and users/create.  Larger hosted apps may use accounts, etc.

h2. sessions controller

I'm a bit iffy on this.  Though you're not really exposing a session, it keep let this login/logout process separate from the rest of the app.  This would also be a good place to hook into if you're auditing logins or just tracking who's currently online.
