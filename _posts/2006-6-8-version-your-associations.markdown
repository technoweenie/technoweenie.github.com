--- 
layout: post
title: Version your associations
---
The most frequent question I get asked about my acts_as_versioned plugin is _How do you version associations?_  I have no desire to open that can of worms unless I absolutely need it in a project.  "Richard Livsey":http://livsey.org decided he needed this feature, and created "acts_as_versioned_association":http://livsey.org/articles/2006/06/08/acts_as_versioned_association-plugin.  

<pre><code>
class Article < ActiveRecord::Base
  has_many :images
  has_and_belongs_to_many :categories

  acts_as_versioned
  acts_as_versioned_association :images
  acts_as_versioned_association :categories
end
</code></pre>
