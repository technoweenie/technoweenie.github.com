--- 
layout: post
title: changing your ActionController template_root per request
---
Normally, you change your template root with a class variable:

<pre><code>class MyController < ActionController::Base
  self.template_root = File.join(RAILS_ENV, 'app', 'views')
end</code></pre>

The publishing framework can use different view paths depending on which domain is being accessed.  So without thinking, I try:

<pre><code>class MyController < ActionController::Base
  before_filter { |c| c.template_root = my_new_template_root }
end</code></pre>

The problem, however, is the the controller sets up the intial ActionView classes before calling the filters.

<pre><code>class MyController < ActionController::Base
  before_filter :set_site_template_root
  def set_site_template_root
    self.class.template_root = File.join(RAILS_ROOT, 'app', 'views', current_site.domain)
    @template.base_path = template_root
  end
end</code></pre>

All good, except the layout doesn't show up...
