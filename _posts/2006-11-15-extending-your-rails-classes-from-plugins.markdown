--- 
layout: post
title: Extending your Rails classes from plugins
---
<macro:code lang="ruby">
Module.class_eval do
  def include_into(*klasses)
    klasses.flatten!
    klasses.each do |klass|
      (@@class_mixins[klass] ||= []) << self
      @@class_mixins[klass].uniq!
    end
  end
end

Class.class_eval do
  def inherited_with_mixins(klass)
    returning inherited_without_mixins(klass) do |value|
      mixins = @@class_mixins[klass.name]
      klass.send(:include, *mixins) if mixins
    end
  end

  alias_method_chain :inherited, :mixins
end
</macro:code>

This adds a method to modules that let's you define which classes it should be mixed into.  Just define a module like this:

<macro:code lang="ruby">
module FooExtension
  include_into "Foo", "Bar"
  ...
end
</macro:code>

When Foo or Bar are created, they will then look for any modules in <notextile>@@class_mixins</notextile> and automatically include FooExtension.  It's only 15 lines of evil, and won't mess with Edge Rails.  I'm thinking about making it a little more explicit and leaving out inherited (one of those internal ruby callbacks), and adding a method like @include_mixins!@.  

One thing:  This stores the actual module in <notextile>@@class_mixins</notextile>.  This will probably cause reloading issues in development mode if your plugin modules are being unloaded on each request.  I could try storing the module's name instead.
