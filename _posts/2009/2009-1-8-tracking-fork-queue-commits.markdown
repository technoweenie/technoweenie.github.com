--- 
layout: post
title: Tracking Fork Queue commits
---
At first I was all <strong>:(</strong>

<pre><code>- if entry.title.downcase =~ %r{^#{login.downcase} (pushed|committed)}
+ if entry.title.downcase =~ %r{^#{login.downcase} (pushed|committed|applied fork commits)}</code></pre>

Then I was like "[git push origin master](http://github.com/entp/seinfeld/commit/093224b5b745f3c681ce4f60fc25c7a64fa2b5ec)".

And now I'm like [<strong>:)</strong>](http://calendaraboutnothing.com/~technoweenie)
