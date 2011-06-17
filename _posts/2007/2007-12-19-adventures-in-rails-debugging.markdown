--- 
layout: post
title: Adventures in Rails Debugging
---
After upgrading my app to Rails 2.0, I started getting an error, but _only_ when running a rake task (such as rake db:migrate).

<pre><code>
$ rake db:migrate --trace
(in /Users/rick/p/lighthouse/trunk)
** Invoke db:migrate (first_time)
** Invoke environment (first_time)
** Execute environment
rake aborted!
uninitialized constant Technoweenie::ActiveRecordContext
/Users/rick/p/lighthouse/trunk/vendor/rails/activerecord/lib/../../activesupport/lib/active_support/dependencies.rb:266:in `load_missing_constant'
/Users/rick/p/lighthouse/trunk/vendor/rails/activerecord/lib/../../activesupport/lib/active_support/dependencies.rb:453:in `const_missing'
/Users/rick/p/lighthouse/trunk/vendor/plugins/active_record_context/init.rb:1:in `evaluate_init_rb'
</code></pre>

So, it's failing on the first line of my active_record_context's init.rb file:

<pre><code>ActiveRecord::Base.send :include, Technoweenie::ActiveRecordContext</code></pre>

Where's the require?  I leave it out, relying on ActiveSupport::Dependencies to auto-load the module for me.  But, it seems to be failing me in my rake tasks.  The fact that it's working when I run script/server or script/console makes me think it's some wacky LOAD_PATH issue.  So, I try this in the init.rb file:

<pre><code>puts $LOAD_PATH.inspect
puts Dependencies.load_paths.inspect
ActiveRecord::Base.send :include, Technoweenie::ActiveRecordContext</code></pre>

Running both my rake task and script/console don't show any differences, so that's a dead end.  Next, I turn my attention to Dependencies.  The first stack trace showed it failing on line 266 in Dependencies.load_missing_constant.  Above the "large if statement":http://dev.rubyonrails.org/browser/trunk/activesupport/lib/active_support/dependencies.rb#L242 seems like a good spot for some debugging.

<pre><code>$ rdebug `which rake` db:migrate -n -- --trace</code></pre>

Here are some interesting variables:

* qualified_name - "Technoweenie::ActiveRecordContext"
* path_suffix - "technoweenie::active_record_context"

That doesn't look like a normal path, String#underscore should be converting :: to /.   Next, I run this in script/server (script/console has no switch to enable the debugger).

<pre><code>$ script/server -u</code></pre>

* qualified_name - "Technoweenie::ActiveRecordContext"
* path_suffix - "technoweenie/active_record_context"

So, something is messing with String#underscore, but only when rake runs.  Interesting...  I then do a grep of my vendor directory, looking for 'def underscore' and find 3 locations:  ActiveSupport, "bj":http://rubyforge.org/forum/forum.php?forum_id=19781, and "AWS::S3":http://amazon.rubyforge.org.  bj managed to copy ActiveSupport's version of the method exactly, but S3 left out the part that converts :: to /:

<pre><code>
  # ActiveSupport adds an underscore method to String so let's just use that one if
  # we find that the method is already defined
  def underscore
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    downcase
  end unless public_method_defined? :underscore
</code></pre>

So, AWS::S3 only adds that method if ActiveSupport isn't available.  Looking at 'String.included_modules' while debugging does list 'ActiveSupport::CoreExtensions::String::Inflections', so it's looking like AWS::S3 is loading before ActiveSupport somehow.

Then it hits me, I'm loading it in a rake task!  Doh...
