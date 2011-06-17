--- 
layout: post
title: the pieces are falling into place
---
First, we get RJS in Rails 1.1, totally changing the way ajax callbacks are written.  Suddenly, we're able to "update small regions":http://scottraymond.net/articles/2005/12/01/real-world-rails-rjs-templates on a page, _using ruby_.  Then, we get three more features:

* The $$() selector function to select DOM objects by a css selector string
* Mixed-in Element helper methods, so you can now do $('foo').hide() instead of Element.hide('foo').
* And finally, RJS enumerations, so you can write something like:

<pre><code>
page.select("#comments li").each do |element|
  element.visual_effect :shake
end
</code></pre>

Annoying, but possible.

Today, Justin Palmer released his "CSS event:Selectors":http://encytemedia.com/event-selectors/, which are basically a "Behaviour":http://bennolan.com/behaviour clone built on top of Prototype.

Now, imagine writing those rules with RJS:

<pre><code>
page.rules do
  page.rule "#icons a:mouseover" do |element|
    page.visual_effect "#{element.id}-content", :blind_down, :queue => 'end', :duration => 0.2
  end
end
</code></pre>

I know, I know, RJS is only used for ajax callbacks.  But, what if it wasn't?  What if a controller generated and cached them into /javascripts/foo/bar.js?  

For what it's worth, Rails Weenie uses Behavior for everything.  There is no admin interface.  Behavior is required since 99% of the pages are page cached.  

Hmm.
