---
layout: post
title: NPM rocks
---

It is very easy to write and distribute packaged ruby libraries to the
world.  You slap a gemspec file on it, push it to rubygems.org, and
anyone can get it.  Tools like [Jeweler](https://rubygems.org/gems/jeweler)
(though I roll with [rakegem](https://github.com/mojombo/rakegem) these days)
and [gemcutter](https://github.com/rubygems/gemcutter) made it
ridiculously easy to push ruby gems.

But, ruby gems are far from perfect (and no, I'm talking about the drama
around slimgems).  Unfortunately, a lot of problems emerged over time
for various reasons, and will be tough to solve.

Node.js is an extremely young programming community that I've been
following for well over a year now.  It's been interesting to see the
node packaging landscape grow this time, in contrast to my own early
experiences with ruby gems.  In this time, [npm](https://github.com/isaacs/npm) has
emerged as the dominant node packaging system.  Npm is written by Isaac
Schlueter, based on his experience using Yinst at Yahoo.

The first, and biggest reason that I love npm is that it's not loaded at
runtime.  You never need to `require('npm')` for your library to
function.  This is in stark contrast to ruby libraries, where [nearly
every one of them requires rubygems](http://tomayko.com/writings/require-rubygems-antipattern).

Why is that?  Say you're writing a sweet web service, and you want to
require a database adapter:

{% highlight ruby %}
require 'mysql'

class SweetApp
end
{% endhighlight %}

Boom: `LoadError`.  Where is the mysql library?  Oh, let's just use
rubygems:

{% highlight ruby %}
require 'rubygems'
require 'mysql'

class SweetApp
end
{% endhighlight %}

Now, check out your load path.  Depending on system, it should have an
entry like this:

    /Library/Ruby/Gems/1.8/gems/mysql-1.0.0/lib

Just to get mysql loaded, we had to load rubygems, and have it find the
correct lib path for us.  It does this every time your app boots up.
After a while, your app likely has 30-100 (or 208, in the case of
GitHub) gems loaded, each with its own entry in the load path.  Every
time you require something, ruby has to scan the whole list until it
finds a match.  God help you if you try to require something with a
common name.

Why doesn't this happen with node?  `index.js`.  Let's look at a node
port of my sweet web service:

{% highlight js %}
mysql = require('mysql')

SweetApp = function() {}
{% endhighlight %}

Assuming you installed the mysql lib with npm, node will check for these
files:

    ./node_modules/mysql.js
    ./node_modules/mysql/index.js

It can also look in node's load path (though it sounds like this may be
removed in the future).

    > require.paths
    [ '/Users/technoweenie/.node_modules'
    , '/Users/technoweenie/.node_libraries'
    , '/usr/local/lib/node'
    ]

Loading packages from npm (or wherever) doesn't add to the load path.
NPM just knows how to install packages so that node can easily find
them.

Without some kind of `index.rb` file, ruby forces all ruby libraries to
live in separate directories, usually with its own load path entry.  Or,
you can combine the files together like the ruby standard lib:

    $ ls /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8
    English.rb           debug.rb             forwardable.rb       logger.rb
    Env.rb               delegate.rb          ftools.rb            mailread.rb

Newer versions of node have even started cooperating with npm through
the `package.json` file.  Your package can provide a `package.json` file
instead of `index.js`, and node will find it.  The following file is
from the mysql package, and instructs node to find the local `lib/mysql.js` when
you `require('mysql')` from your app.

    $ cat node_modules/mysql/package.json 
    { "name" : "mysql"
    , "version": "0.9.1"
    , "main" : "./lib/mysql"
    ...
    }

Newer versions of node and npm also support the idea of cascading
`node_modules` directories.  If you have an app at `/home/rick/app`,
node will check these directories for libraries:

    /home/rick/app/node_modules
    /home/rick/node_modules
    /home/node_modules
    /node_modules

This makes it easy to bundle libraries with your node apps.  You can
commit them directly and know they'll run wherever you push them (though
this may not work for npm packages that require compilation).  You can
also setup a `package.json` file like this:

    {
      "name" : "alambic"
    , "version" : "0.0.1"
    , "dependencies" :
      { "mysql" : "0.9"
      , "coffee-script" : "1.0"
      , "formidable": "1.0.2"
      , "underscore": "1.1.7"
      }
    }

Running `npm install` will load these to the `node_modules` directory
inside my app.  I can run this once after updating code on our servers,
and it's ready to rock.  This feature is reminiscent of Bundler, but
again, it doesn't rely on your app using npm at runtime.  

You can comment on this through the [HN discussion][hn]...

[hn]: http://news.ycombinator.com/item?id=2818299
