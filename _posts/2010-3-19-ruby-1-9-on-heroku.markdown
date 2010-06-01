--- 
layout: post
title: Ruby 1.9 on Heroku
---
Heroku just pushed their [new deployment stacks to public beta](http://blog.heroku.com/archives/2010/3/5/public_beta_deployment_stacks/).  You can now run your Heroku apps on Ruby 1.8.7 and 1.9 (as opposed to the old standard: 1.8.6).  

To test this out, I whipped up [Ultraviolence](http://ultraviolence.heroku.com/), a quick wrapper around the [Ultraviolet](http://ultraviolet.rubyforge.org/) gem.  Ultraviolet will syntax highlight text, using parsed Textmate bundle files.  Any language that Textmate supports will work, using any theme that Textmate supports.

There's also a web api if that's how you want to roll...

I chose Ultraviolet because its installation in ruby 1.8.x was always a tricky issue.  Ruby needs the [Onigurama regex library](http://www.geocities.jp/kosako3/oniguruma/) to parse the Textmate bundles.  This means you have to install some software from a japanese geocities page and compile the onigurama gem.  Ruby 1.9 uses this regex library by default, so Ultraviolet is a snap to setup.  

Thanks to [Heroku](http://heroku.com) and [RVM](http://rvm.beginrescueend.com/), it was pretty easy to get a ruby 1.9 app developed and deployed.
