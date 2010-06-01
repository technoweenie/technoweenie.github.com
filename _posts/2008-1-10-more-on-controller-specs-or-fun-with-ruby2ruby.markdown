--- 
layout: post
title: More on Controller Specs, or Fun with Ruby2Ruby
---
One of the problems with the rspec_on_rails_on_crack (git://activereload.net/rspec_on_rails_on_crack.git) was that the redirection examples had horrible descriptions.  

<pre><code>describe FooController, "GET /index" do
  it_redirects_to { foo_path }
end</code></pre>

The route goes in a ruby proc because routes aren't available from the context of the example group.  They're only available from inside a running example.  But this is what the description looks like when running <code>rake spec:doc</code>:

<pre>FooController GET #index
  - redirects to #<Proc:0x0224e7d8@./spec/controllers/foo_controller_spec.rb:68></pre>

Solution?  Install the ParseTree and ruby2ruby gems and add this to #it_redirects_to:

<pre><code>route.to_ruby.gsub(/(^proc \{)|(\}$)/, '').strip</code></pre>

<pre>FooController GET #edit
- redirects to "foo_path(1)"</pre>
