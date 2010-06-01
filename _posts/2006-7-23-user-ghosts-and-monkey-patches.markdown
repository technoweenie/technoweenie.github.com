--- 
layout: post
title: User Ghosts and Monkey Patches
---
If you're watching the changelogs, you'll notice I've committed some very important fixes to Mephisto:

* Bootstrapping should work
* Timezones should be correct now (story for another time/post)
* You can now delete articles
* You can now delete users

User deletion brought something else up: what about that user's old posts?  I didn't really want to add in some user_id migration across the database.  So instead, I opted to make the User records "paranoid":http://svn.techno-weenie.net/projects/plugins/acts_as_paranoid/.  (For those of you that don't know, acts_as_paranoid uses a deleted_at attribute to mark items deleted, and overrides all finds/counts to hide them).  This worked very well.

Still, there was the problem with the user's current articles: <code>@article.user</code> returned nil.  I did some "surgical monkey patching":http://bs.techno-weenie.net/!revision/1411 and added a new feature to the plugin:

<pre><code>
class User < ActiveRecord::Base
  acts_as_paranoid
end

class Article < ActiveRecord::Base
  belongs_to :user, :with_deleted => true
end
</code></pre>

*Update* -- As Mephisto is technically not released yet, it requires Edge rails to use.  I'm shooting for Rails 1.2...
