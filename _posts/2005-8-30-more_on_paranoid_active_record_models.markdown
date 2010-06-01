--- 
layout: post
title: more on paranoid active record models
---
Scott Barron "calls me out":http://lunchroom.lunchboxsoftware.com/articles/2005/08/29/extension-vs-mixing-in for perverting the ActiveRecord base classes with my little paranoid hack.  And, he's absolutely right.  

However, this code was written to purposely affect every model in the application.  I just posted the code verbatim in case others were interested.  I've "started working on the gem":http://collaboa.techno-weenie.net:2533/repository/file/paranoid-ar/lib/paranoid-ar.rb already, in response to his rant.  This will be implemented as an _act_:

<pre><code>
class Post < ActiveRecord::Base
  acts_as_paranoid
end
</code></pre>

Now, what about the join tables?  I wonder if I can hook into @ HasAndBelongsToManyAssociation@ for that model only?  If not, that may be reserved for when ActiveRecord::Base is paranoid.

The best part of posting my code online is getting some helpful feedback. Thanks Scott.  
