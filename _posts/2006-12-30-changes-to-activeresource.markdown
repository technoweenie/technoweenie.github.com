--- 
layout: post
title: Changes to ActiveResource
---
If you look at the "Changelog":http://dev.rubyonrails.org/log/trunk/activeresource for ActiveResource, you may notice two important updates.  One: the way that the site attribute is copied from the superclass has changed.  Where you had something like:

<filter:code lang="ruby">
class Topic < BeastResource 
  site << '/forums/:forum_id' 
end 
</filter:code>

You should replace it with:

<filter:code lang="ruby">
class Topic < BeastResource 
  self.site += '/forums/:forum_id' 
end 
</filter:code>

The coolest change though, is the new "query string support":http://dev.rubyonrails.org/changeset/5804.  Now, you can write code like this: @Topic.find(:all, :forum_id => 1, :sort => 'created_at')@ and get back a query like: @/forums/1/topics.xml?sort=created_at@.  (Note, this is not supported by Beast, it is just an example)

I was going to follow this up with a short tutorial on searching Beast with our new querying abilities, but then I looked at how I have the search code implemented.  "That controller":http://svn.techno-weenie.net/projects/beast/trunk/app/controllers/posts_controller.rb needs to "lose some weight":http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model.
