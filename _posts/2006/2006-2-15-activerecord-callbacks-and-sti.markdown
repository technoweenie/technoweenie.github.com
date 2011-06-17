--- 
layout: post
title: ActiveRecord Callbacks and STI
---
One of the things I've done with Mephisto is started using STI(Single Table Inheritance) more.  For instance, I have a basic Content model, with an Article and Comment deriving from it.  But, I noticed that none of my validations or callbacks were not making it from my base model.  

h2. How are Callbacks and Validations saved?

Checking "lib/active_record/callbacks.rb":http://dev.rubyonrails.org/browser/trunk/activerecord/lib/active_record/callbacks.rb shows that the class methods "write an inheritable array":http://dev.rubyonrails.org/browser/trunk/activerecord/lib/active_record/callbacks.rb?rev=3595#L203.  You can then "check the current callbacks":http://dev.rubyonrails.org/browser/trunk/activerecord/lib/active_record/callbacks.rb?rev=3595#L353 with this:

<pre><code>
>> Article.new.send :callbacks_for, :before_save
=> [] # this is where you'd see an array of symbols, procs, etc
</code></pre>

Validations in "lib/active_record/validations.rb":http://dev.rubyonrails.org/browser/trunk/activerecord/lib/active_record/validations.rb are "saved with an inheritable array":http://dev.rubyonrails.org/browser/trunk/activerecord/lib/active_record/validations.rb?rev=3595#L690 also.  Validations "can be checked":http://dev.rubyonrails.org/browser/trunk/activerecord/lib/active_record/validations.rb?rev=3595#L770 with:

<pre><code>
>> Article.read_inheritable_attribute(:validate)
=> [] # you'll see an array of procs for this validation method
</code></pre>

So, I know my callbacks and validations are not working, but why?  After much digging and debugging, I finally pinpointed two causes.  They are definitely two rare edge cases, but the investigation led me to a deeper understanding of Rails.  

h2. Class.inherited()

The first has to deal with using the inherited().  It's a method that is called whenever a class is inherited from.  I was using this to add a set of callbacks to any class that inherited from my base Content class:

<pre><code>
class Content < ActiveRecord::Base
  def self.inherited(sub)
    sub.before_save :do_something
  end
end
</code></pre>

The problem is this is exactly "how inherited class attributes are passed on":http://dev.rubyonrails.org/browser/trunk/activesupport/lib/active_support/core_ext/class/inheritable_attributes.rb?rev=3595#L108.  By defining inherited on my class, I was overriding the method that transfers my callbacks and validations.  This is not a big deal.  Instead of trying to be clever, I used a mixin to copy the functionality.

h2. More Issues

After fixing that, I started seeing some intermittent issues with disappearing callbacks.  This time I overwrote self.inherited() to see when it was being called, and what inherited attributes it was passing on.  The problem, I noticed, was that it passes them at the creation of the subclass.  What if you have code like this?

<pre><code>
class Article < ActiveRecord::Base
  has_many :comments
  validates_uniqueness_of :title
end
</code></pre>

While loading the Article class, it will load the Comment class while creating the has_many association.  In my case, Comment was a subclass of Article and would get loaded before my validations and callbacks.  From now on, I'm going to start putting my association calls below my callbacks and validations.  If you're seeing weird issues with callbacks and validations too, I'd suggest you do the same.
