--- 
layout: post
title: Plugin Dependencies
---
Aaron (obrie to most of the Rails community) has launched the "PluginAWeek":http://www.pluginaweek.org/ project, to open source 25,000 lines of code in over 70 plugins.  In his various posts, Aaron goes into his "Theory of Plugins" to explain why he needs them, and why his "plugin_dependencies":http://www.pluginaweek.org/2006/10/31/1-plugin_dependencies-who-do-you-depend-on/ plugin matters.

For me though, the current state of Rails plugins works just fine.  I haven't written any plugins that really depend on any others.  I try to write small plugins without much coupling if I can.  Occasionally I will need plugins to be loaded first, such as my "gems":http://svn.techno-weenie.net/projects/plugins/gems.  Mephisto needs any liquid plugins to be loaded after Liquid has been loaded.  Since M comes after L, this hasn't been an issue.  Had I named the project Aardvark or something, then I'd rename the plugin aaa_liquid.  A little crufty perhaps, but then I don't have to add <code>require_plugin 'liquid'</code> to all of those plugins.  Course, they _do_ depend on the plugin technically, so that's not a big deal.  But, should I add <code>require_plugin 'gems'</code> to all of my plugins because I happen to use that gem a lot?

Those are really basic examples, and definitely not on the scale of the project Aaron is working on.  So, let's imagine a plugin that implemented versioned pages with attached images.  (Note: this is a contrived example to prove a single point.  I'm not claiming to have a plugin like this, or that one of Aaron's plugins is like this)  Some might make a plugin that adds models like this:

<macro:code lang="ruby">class Photo < ActiveRecord::Base
  acts_as_attachment ...
end

class Content < ActiveRecord::Base
  acts_as_versioned
  acts_as_paranoid
  has_many :photos
end</macro:code>

That's a horrible plugin.  It really ties you into those models, and causes more work than it would be to actually write from scratch.   So, how about a simple macro like <code>acts_as_content</code> (yes, I realize this is a lame and contrived example, but stay with me).

<macro:code lang="ruby">
module ActsAsContentPlugin
  def acts_as_content
    acts_as_versioned
    acts_as_paranoid
  end
end

ActiveRecord::Base.extend ActsAsContentPlugin
</macro:code>

The actual method isn't actually executed until the Content model has been loaded.  So yes, my example plugin depends on two of my plugins, but it doesn't matter what order they're loaded in.  Of course, this is an example of how acts_as_* plugins can be used to delegate, and cut down on coupling.  I can definitely see other situations where this wouldn't be possible.  However, I'm not sure this is common practice for most plugin developers, so I wouldn't like having this new plugin dependency behavior being default.

At any rate, I'm anxious to see what treats Aaron has in store for us.  I'm sure these 70 plugins will be a very useful addition to the Rails community.  It's great to see folks taking the time to properly contribute some open source code back to the community, rather than acting as a black hole.
