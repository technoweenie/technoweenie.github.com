--- 
layout: post
title: Giles is Proud Not to Understand has_many :through
---
Apparently, the number of exception classes related to has_many :through (HM:T) "scared Giles away":http://gilesbowkett.blogspot.com/2008/02/im-proud-not-to-understand-hasmany.html.  I think most of them are there because I put the original ones there.  Course, looking at them highlighted does make it seem a bit ridiculous.

HM:T associations are the only associations that actually look at other associations to figure out how to query the database.  There aren't a simple set of conventions to go by that raise simple errors like "couldn't find the `suspended_users` table".  If you actually look at the associations, they're not much more than simple ActiveRecordError subclasses with a custom message.  It gives you nice, helpful messages like this:

<pre><code>
class Post < ActiveRecord::Base
end
class User < ActiveRecord::Base
end
class Topic < ActiveRecord::Base
  has_many :posts
  belongs_to :user
end
class Forum < ActiveRecord::Base
  # commented out bits are things
  # i conveniently 'forgot' in this contrived example.
  #
  # has_many :topics 
  has_many :posts, :through => :topics
  has_many :creators, :through => :topics# , :source => :user
end

Forum.find(:first).posts
# => ActiveRecord::HasManyThroughAssociationNotFoundError: Could not find the association :topics in model Forum

Forum.find(:first).creators
# => ActiveRecord::HasManyThroughSourceAssociationNotFoundError: Could not find the source association(s) :creator or :creators in model Topic.  Try 'has_many :creators, :through => :topics, :source => <name>'.  Is it one of :posts or :user?
</code></pre>

Are the error messages helpful?  I sure think so.  But, do we really need all those exception classes?  Sure, it'll keep the error messages DRY.

<div class="thumbnail" style="width:100%"><a href="http://skitch.com/technoweenie/gg1s/associations.rb-lib"><img src="http://img.skitch.com/20080213-d54pqtibt6t94u8qh7f1yfxhhq.preview.jpg" alt="associations.rb 2014 lib" /></a><br /><span style="font-family: Lucida Grande, Trebuchet, sans-serif, Helvetica, Arial; font-size: 10px; color: #808080">Uploaded with <a href="http://plasq.com/">plasq</a>'s <a href="http://skitch.com">Skitch</a>!</span></div>

Okay, maybe not.  Is it sufficient to have a single ActiveRecordError class (or even a more specific ActiveRecord::AssociationsError)?  I could definitely do something like this:

<pre><code>
raise ActiveRecord::AssociationsError.new(:has_many, :through_association_not_found, model, reflection)
</code></pre>

Whichever way's the best, I really don't think it's good enough validation to miss out on the feature.  I can point to a few other more complex areas of the associations code (the crazy eager joins code is why I personally haven't used :include in any of my apps in over a year). 
