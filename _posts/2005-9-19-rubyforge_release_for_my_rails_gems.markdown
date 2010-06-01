--- 
layout: post
title: rubyforge release for my rails gems
---
I spent a portion of this weekend cleaning up the three gems I've been working on.  They are all mirrored on RubyForge now, with cleaned up RDocs, more extensive testing, and a first class spot on the gem server.

Setting up the ActiveRecord unit tests was a bit interesting.  I ended up using the same structure of the test directory that ActiveRecord uses.  I also found "some great rake tasks":http://collaboa.techno-weenie.net/repository/file/acts_as_versioned/Rakefile for publishing gems from Typo and Rails.

Here's how to install them:

<pre><code>gem install acts_as_versioned
gem install acts_as_paranoid
gem install sentry
</code></pre>

I hope someone else finds these useful...
