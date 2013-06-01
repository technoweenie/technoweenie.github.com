--- 
layout: post
title: Validations in Rails Plugins
---
I've made a big change for any of you using my "acts as attachment plugin":http://svn.techno-weenie.net/projects/plugins/acts_as_attachment/.  It no longer validates your fields for you.  Gasp!  

I got an email from Michael Trier asking how to override validations.  I don't know why in the world anyone would not want to validate their size, content_type, or filename fields, but there it is.  So what were my options?

# Be an opinionated bastard.  _This works for my projects, go write your own attachment plugin!_
# Add a configuration option like :validate => false that somehow sets the ":if option":http://rails.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#M000813 to false.
# Rip the validations out and let the coder do it.

I went with option # 3 because it provides the most flexibility, without imposing new options and features to learn.  There are only two validations used anyway, but I provided a validation macro for assistance.  I figure having less logic in my plugin is better.  Next on the chopping block?  RMagick........

<pre><code>
class Foo < ActiveRecord::Base
  acts_as_attachment

  # validations
  validates_presence_of :size, :content_type, :filename
  validate :attachment_attributes_valid?

  # or
  validates_as_attachment
end
</code></pre>

Thoughts on my approach?
