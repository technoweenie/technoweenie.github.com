--- 
layout: post
title: unitialized constant "Technoweenie"
---
One of the nice things about Rails is how it handles the loading and reloading of your classes. Support for convenient loading has always been around, but in Edge Rails you'll find there is even less work needed, especially if you do much plugin and framework development. Check this out.

h2. Auto Loading Classes

The first thing that you must know is that Rails does not automatically load your application.  It initializes the framework, runs your plugin init.rb files, and includes your app/ and lib/ directories in the LOAD PATH.  But, it doesn't do anything with application classes until you start accessing them.  Try accessing your Article model, and it immediately attempts to load <code>article.rb</code>.  Access MyModule::Article, and it looks for <code>my_module/article.rb</code>.  This behavior has been around for awhile, but the implementation is much smarter.

h2. Reloadable

The big change deals with the reloading of classes in development mode.  Before, the dispatcher would clear specific subclasses of some Rails core classes.  This meant that any custom classes were left out in the cold.  However, this functionality has been extracted out so any class can utilize it.  

<pre><code>
# foo.rb
class Foo
  include Reloadable
end
</code></pre>

Now, any of those custom classes will be reloaded along with the rest.  If you have some core library code that you *don't* want reloaded, however, you can use this:

<pre><code>
# foo/base.rb
# This is put in a module MyModule to mimic something like ActiveRecord::Base
# the module is not required for this however
module MyModule
  class Base
    include Reloadable::Subclasses
  end
end

# this class will be reloaded on every request
class Foo < MyModule::Base
end
</code></pre>

This keeps your MyModule::Base safe from the clutches of the reloader, but not any subclasses.  This is how the rails base classes stay in memory, while allowing your models/controllers/etc to reload.

h2. Rules

If you want to take advantage of Rails' auto class loading capabilities, there are a few guidelines you need to follow.  Of course, if you don't follow these rules, you'll be stuck using require statements...

The first thing to keep in mind is that classes should be organized one to a file.  They should have reasonable class names that map to guessable filenames.

* Foo => foo.rb
* MyModule::Foo => 'my_module/foo

Use the string inflectors to check the names if something isn't loading correctly.  Don't use uppercase class names though, because they don't work both ways.

<pre><code>
> 'MyModule::Foo'.underscore
=> "my_module/foo"
> "my_module/foo".classify
=> "MyModule::Foo"
> "SSLClass".underscore
=> 'ssl_class'
> "ssl_class".classify
=> "SslClass" # doh!
</code></pre>

One common problem is adding multiple classes with STI.  For instance, it's temping to just throw a quick Admin class at the bottom of a User class definition.  That's all fine and dandy until the objects are wiped and reloaded.  If the next controller action accesses Admin before User, you're going to have problems.  

Be careful about file name clashes as well.  If your Article class needs to load, but your app has article.rb in various spots, only one of them will be loaded.  Naturally, you'll want to put things in proper module namespaces.  This is especially important for plugins.  Be sure to put your libraries files in some unique module namespace to be safe.

Another source of clashing is modules matching currently existing classes.  If Rails attempts to autoload "MyModule::Foo," it expects MyModule to be a an actual module.  If it loads my_module.rb and finds a Class, it will cause issues.  However, you are allowed to load modules like this:

<pre><code>
./my_module.rb # loaded on first access of MyModule
./my_module/foo # uses the same MyModule module, and adds Foo class
./my_module/foo/bar # this will raise an error since Foo is a class.
</code></pre>

h2. Getting around Reloadable

There are times when you don't want your models, controllers, etc to reload.  So, what's a guy to do?

<pre><code>
class NoReload < ActiveRecord::Base
  def self.reloadable?
    false
  end
end
</code></pre>

When the dispatcher removes the classes after a request, classes that answer false to klass.reloadable? are skipped.
