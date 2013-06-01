--- 
layout: post
title: Reloading Killed My Attachments
---
*Update:*  Nicholas tried some fixes for this, but ultimately came to the conclusion that perhaps reloadable plugins weren't such a hot idea.  He's going to add a Dependencies.only_once_paths configuration option that lets you specify libraries that should only be loaded once.  This way, current plugins should continue to work.  If you want reloadable plugins, there'll be a way to enable that, as well.

If you happen to be one of those cutting edge developers using my Acts as Attachment plugin on edge Rails, you may have started noticing this:

<pre><code>uninitialized constant Technoweenie::ActsAsAttachment::ClassMethods::Technoweenie</code></pre>

In fact, _whynot goes over this in more detail on "rails weenie":http://rails.techno-weenie.net/question/2006/8/16/acts_as_attachment-uninitialized-constant-error-on-object-save.  I've seen a few workarounds for this:

* Freeze your app to edge Rails revision 4727 temporarily (this is the approach I've taken on Mephisto).
* Replace references of Technoweenie with ::Technoweenie: 

<pre><code>delegate :content_types, :to => Technoweenie::ActsAsAttachment
# becomes
delegate :content_types, :to => ::Technoweenie::ActsAsAttachment</code></pre>

* "Josh Peek":http://joshpeek.com/ suggested manually requiring the module in init.rb.  I this keeps the module from reloading in development mode.

<pre><code>require 'technoweenie/acts_as_attachment'
ActiveRecord::Base.send(:include, Technoweenie::ActsAsAttachment)</code></pre>

Frankly, all these workarounds suck.  I'd much rather see Rails fixed, as I'm still convinced it's a Dependencies issue, not an issue with my plugins.  I've been working with Nicholas on a satisfactory fix.  If you have any more broken plugins, or even have a failing test case for ActiveSupport, please let me know.
