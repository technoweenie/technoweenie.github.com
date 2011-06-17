--- 
layout: post
title: More on per-request template_roots in ActionPack
---
About three weeks ago, I wrote about "changing your ActionController template_root per request":.  Let's review:

<pre><code>class MyController < ActionController::Base
  before_filter :set_site_template_root
  def set_site_template_root
    self.class.template_root = "#{RAILS_ROOT}/#{app}/#{views}/#{current_site.domain}")
    @template.base_path = template_root
  end
end</code></pre>

Simply setting <code>ActionController::Base.template_root</code> is enough if you set it in the controller, but it sets the template's view path early in the action processing.

Why am I bothering?  I'm working on a publishing system in Ruby on Rails "for work":http://digett.com.  Our current system is written in ASP.Net, and is able to host all the sites from the same codebase. The Rails system is set up much the same way, but I don't necessarily want to host separate FCGI processes for each one.  That could get memory intensive.

Instead, I pool many sites into one database and rails app. The only parts that are separated are the public directories (with web roots set in Lighttpd) and the views.  Each hit to a site figures out which site to load, and sets the view path accordingly.  

So what's the problem?  I started noticing some odd issues when I had multiple sites running off the codebase.  After a closer examination of the stack trace, it looked like it was executing another site's application layout!  Not good...

I do some digging and see this bit about "compiling a template":http://dev.rubyonrails.com/browser/trunk/actionpack/lib/action_view/base.rb#L240 in ActionView.  It turns out that it compiles your views into methods of <code>ActionView::Base::CompiledTemplates</code>.   After much breakpointing, I had some of the workflow figured out, and discovered that it was "naming the methods":generated based on the filename of the rendered template.  The solution was simple once I discovered this: "solution on Snippets":http://bigbold.com/snippets/posts/show/854.

Keep in mind that this is relying on the behavior of a private Rails method.  I'm quite sure the Rails team didn't have this in mind, and would think it was pretty _smelly_.  At any rate, it was a simple matter to just make the patch in my app and be done with it.
