--- 
layout: post
title: ruby on rails worst practice
---
I was helping lagcisco (on "#rubyonrails":irc://irc.freenode.org/rubyonrails) get started on my ComicLog project, and he discovered my user authentication stuff wasn't working.  I started moving code around, and happened to make a nice boolean method for the valid property of my User model.  

<pre><code>
def valid?
  return self.valid > 0
end
</code></pre>

Everything was fine, but now my validations were not working.  I tweaked my validation statements for about an hour when it hit me, I was overriding the <code>valid?</code> method!  I'll probably end up renaming that method to <code>registered?</code>

I still don't know why the authentication was failing.  I added an authenticate call in my unit test so I should be able to catch it if it pops up again.
