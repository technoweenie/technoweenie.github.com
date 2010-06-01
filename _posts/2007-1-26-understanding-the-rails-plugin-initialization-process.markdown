--- 
layout: post
title: Understanding the Rails Plugin Initialization process
---
There was one key addition to Rails 1.2 that added a great new feature, but changed the way plugins are initialized in subtle ways: config.plugins.  This is a new option to the Rails::Configuration object that lets you specify which plugins to load, rather than just reading everything in vendor/plugins in alphabetical order.  This also lets you effectively ignore certain plugins entirely.  For instance, you can set it so that the "query_analyzer plugin":http://www.railtie.net/articles/2006/09/20/mysql-query-analyzer-rails-plugin isn't loaded in production mode.

bq. When Rails 1.2 is released, the notion of 'installing an engine' will become meaningless. Let me make that really clear - there will be no meaningful distinction between an engine and a plugin anymore. To understand the implications of this, let's look at what distinguished an engine from a plugin in the first place.  -- "Engines are dead!  Long live engines!":http://railsengines.org/news/2007/01/03/engines-are-dead-long-live-engines/

When this change was first introduced however, it caused a lot of problems for folks using other plugins.  One big change is that the plugin paths are no longer added to the $LOAD_PATH like the rest of the application paths, _until_ the plugin is loaded.  There's no point in adding the plugin's lib path to $LOAD_PATH if the plugin is ignored after all.  People quickly ran into this when they were caught accessing plugin classes/modules in their environment.rb.  As I mentioned yesterday, the rest of environment.rb is run before plugins have been loaded.

The other change relates more to how the new Dependencies code decides to load and reload classes.  By default, anything autoloaded through the Dependencies const_missing method is marked for reloading.  This means that it started reloading plugin classes in development mode.  This is actually pretty handy, but a lot of plugins that were written to take advantage of the old autoloading code were not written to expect reloading and consequently broke.  I added a line to add the plugin's lib path to Dependencies.load_once_paths, meaning that plugins are (for now) restricted from being reloaded.  I hope to revisit this for Rails 2.0 sometime though.  If you wish to allow reloading for your plugin, add this to your init.rb:

<macro:code lang="ruby">
Dependencies.load_once_paths.delete(lib_path)
</macro:code>

h2. That's it for now!

And, that's all I have to say on the subject.  I hope my little trilogy was helpful.  Let me know if you have any questions not answered here...
