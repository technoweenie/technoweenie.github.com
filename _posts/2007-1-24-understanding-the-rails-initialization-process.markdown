--- 
layout: post
title: "Understanding the Rails Initialization process: Part 1"
---
Here are a couple key points:

* require_frameworks
* ...
* load_environment
* load_plugins
* load_observers
* after_initialize

When your Rails application loads, it should follow this basic load order: framework => environment => plugins => application.  Notice that plugins load _before_ your application, so ideally your plugin won't be monkey patching models or controllers in the application.  This leads to plugin dependency issues.  These can be solved by messing with the config.plugins order if you like, but I like my plugins to step back and let Rails do its thing.  

h2. Mixins

What's another way to solve this? Mixins.  This is how a lot of common plugins work.  Rather than directly modifying your application, they define modules that you then include into into your model or controller to add the functionality.  More complex plugins may throw in a simple helper method (adding an acts_as_* method to ActiveRecord::Base, for example), that does little more than dynamically including a module and setting custom options.

<macro:code lang="ruby">
# init.rb
# note the lack of an explicit require, let Dependencies take care of that
class << ActiveRecord::Base
  def capitalized_titles!
    include CapitalizedTitles
  end
end

# lib/capitalized_titles.rb
module CapitalizedTitles
  def capitalized_title
    title.to_s.capitalize
  end
end
</macro:code>

h2. Models

Can you add models in plugins, or are you limited to just mixins?  Of course, just be careful that your models don't clash with any application models.  For general Rails application development, I personally advocate mixins and migration generators, since they give the developer greater control.  But, if you want to include models, be sure to look at "Engines":http://rails-engines.org or the "plugin_migrations plugin":http://www.pluginaweek.org/2006/11/05/3-plugin_migrations-where-have-all-the-migrations-gone/.  As for the model itself, you can just add a file under lib, like "lib/post.rb".  

If you want to store your model in a directory like "vendor/plugins/YOUR_PLUGIN/app/models/foo.rb", you can simply add these lines to init.rb:

<macro:code lang="ruby">
# You can't use config.load_paths because #set_autoload_paths has already been called in the Rails Initialization process
models_path = File.join(directory, 'app', 'models')
$LOAD_PATH << models_path
Dependencies.load_paths << models_path
</macro:code>

This is of course something that something like Engines provides for free, but I think it's good to know what's going on under the hood before jumping into something like this.

h2. Controllers

Controllers are a little trickier due to the security issues.  If you remember the great security incident of Rails 1.1, you'll remember that the problem came due to an assumption that any class was fair game to be used as a controller.  The Rails 1.2 Routing rewrite introduced the #controller_paths property for this very purpose.  Here's what a controller in your plugin might look like:

<macro:code lang="ruby">
controller_path = File.join(directory, 'app', 'controllers')
$LOAD_PATH << controller_path
Dependencies.load_paths << controller_path
config.controller_paths << controller_path
</macro:code>

h2. Views

It's easy to get your controller running, but what about the views?  As soon as you try to use your controller, you may get missing template error: "Missing template script/../config/../app/views/foo/index.rhtml."  This is because by default, Rails uses a template_root of RAILS_ROOT/app/views.  If you want to change it to "vendor/plugins/your_plugin/app/views", add this to your controller:

<macro:code lang="ruby">
class FooController < ApplicationController
  self.template_root = File.join(File.dirname(__FILE__), '..', 'views')
  def index
  end
end
</macro:code>

Of course, you can define a PluginController base class that handles that for you.  Also look into Engines for more complex view handling.  One of the benefits is it lets you override the default plugin views with view files in your application's template_root.  I may have more to write this in the future, there's a "pending patch to allow for multiple view_paths":http://dev.rubyonrails.org/ticket/2754...

h2. Observers

Plugin observers work just like your application's observers.  They should be defined somewhere in your application's load path (app/models, vendor/plugins/your_plugin/lib, etc), and added to the collection of observers.  You can do that by appending to config.active_record.observers in either environment.rb or your plugin's init.rb.  Since instantiating observers will instantiate the observed model too, this is done after the plugins are loaded.

h2.  Next Time...

Tomorrow, I'll follow up with a post on the various solutions for configuring your Rails applications.  Yes, this is for real, I decided to write both at once so that I don't get backed up with work and forget to put the next part out.  I haven't had the chance to fiddle with ActiveResource much lately, which is why I still haven't put out a second article.
