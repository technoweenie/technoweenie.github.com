--- 
layout: post
title: Ruby on Rails find API
---
One big downside to Rails and ActiveRecord is the amount of redundant queries when dealing with associations.  "Nextangle":http://www.loudthinking.com/ announced in IRC today that the new Base.find API was checked into "svn":http://dev.rubyonrails.com, so I checked it out.

Using a common weblog schema as an example, you can now do:

<pre><code>Entry.find(:all, :include => :comments)</code></pre>

This will grab all the blog entries along with all comments for them in a single query.  I've noticed this will return multiple rows of the same blog entry with different comments, but it is better than n+1 queries.

It'd be nice for this to support loading belongs_to associations instead of having to "piggyback the data":http://www.loudthinking.com/arc/000235.html.  ActiveRecord handles the common cases extremely well, and over time it's handling more complex cases better and better.
