--- 
layout: post
title: "Understanding the Rails Initialization process: Part 2"
---
h2. Setting up your Environment

In every Rails app there are various things to configure.  You may need to set the email address that the exception_notification plugin uses, or maybe you just need custom Inflections.  Let's go over the currently available options at our disposal:

h2. Environment.rb

Use this for general Rails framework stuff, like custom inflections.  At this point, your plugins _have not_ been loaded, so don't use it to access your controllers or models that maybe depending on plugin code.  Also, each environment has lets you define environment-specific config options in config/environments/RAILS_ENV.rb.  This is how Rails knows not to reload in production mode, or use caching in development mode.  

h2. The After Initialization Hook

There is a little known after_initialization task that runs at the very end of the initialization process.  You can define this either in the Rails::Initialization block in config/environment.rb, or anywhere in the environment-specific files mentioned above.

<macro:code lang="ruby">
# config/environments/development.rb
config.after_initialize do
  PaymentProcessor.gateway = :bogus
end

# config/environments/production.rb
config.after_intialize do
  PaymentProcessor.gateway = :whatever
end
</macro:code>

One important fact to remember here is that you can only have *one* after_initialization block.  The precedence order goes config/environment.rb => config/environments/RAILS_ENV.rb => plugins.  It's probably not good practice to define after_initialization blocks in your plugins, since they would clobber any application settings the developer tries to set up.  Your best bet is to define this in your environment-specific config files.

h2. Dispatcher Preparation Callbacks

Preparation callbacks are blocks that are executed before the Dispatcher handles any Rails requests.  They're executed just once in production mode and before each request in development mode.  One common use I have for them is making sure Liquid uses my filters and drops between development requests.  Rails uses one internally to ensure your observers are always loaded as well.

There are currently two ways to set up a Dispatcher preparation callback.  The default way is to use Dispatcher directly.  If you have access to the Rails::Configuration instance, you can also use config.to_prepare.

<macro:code lang="ruby">
Dispatcher.to_prepare do
  ...
end

# Use this if you're...
#   - in the Rails::Initialization block of config/environment.rb
#   - in one of the environment-specific files in config/environments/#{RAILS_ENV}.rb
#   - in a plugin's init.rb file.
config.to_prepare do
  ...
end
</macro:code>

Note:  If you are on the gem release of Rails 1.2.1, config.to_prepare may not work since Dispatcher won't be required.  This has been fixed in edge Rails, and the 1.2 branch, so will work in the next release.

h2. To be concluded

Stay tuned for the final article in this little trilogy, explaining the changes to the plugin initialization process in more detail.  As noted in the first comment, Tim Lucas wrote a better article on this: "Environments and the Rails initialisation process":http://toolmantim.com/article/2006/12/27/environments_and_the_rails_initialisation_process.
