--- 
layout: post
title: creating a DSL
---
I'm getting close to the point that I think I'm ready to release the "form toolkit":http://techno-weenie.net/blog/code/255/picking-up-where-ruby-on-rails-scaffolding-leaves-you I'm blogging about.  I'm satisfied with the framework, but it needs a lot more widgets.  

First, I'd like to make sure the DSL(Domain Specific Language) is suitable and makes sense.  Refer back to the "original post":http://techno-weenie.net/blog/code/255/picking-up-where-ruby-on-rails-scaffolding-leaves-you.  I was thinking of shortening the methods to @column@, @search@, and @field@.   My ultimate goal is obviously to make this as rails-like as possible.  Here are some other ideas I was throwing around:

Grouped listings in the List View:

<pre><code>list.group('unpublished', :collapsed => true) do |record| 
  !record.published?
end</code></pre>

Fieldsets in Form Views:

<pre><code>form.fieldset('Advanced') do |form|
  form.field...
end</code></pre>

If you have any MVC fears looking at the code, forget them all.  This toolkit is not bound in any way to controllers.  You can easily define Agents (tentative name) in a separate file and include them in your views.  Adding them directly in the controller automatically creates the controller methods to handle all that, though.  This toolkit only generates structured HTML.  You're free to add some style and behavior using CSS and Javascript.

I'm going to try to have a basic project site up later this week with read access to the "darcs":http://abridgegame.org/darcs/ repository.
