--- 
layout: post
title: IsLOSTOnYet no longer a ghost town
---
I pushed a little update last night that started filling the [IsLOSTOnYet stream](http://islostonyet.com/) with a flurry of updates.  Where did all this come from?  [search.twitter.com](http://search.twitter.com/), courtesy of the [twitter gem](http://twitter.rubyforge.org/).

The first stage of the code looked something like this:

<pre><code>
Twitter::Search.new("lost OR kate OR sayid OR jack").each do |s|
  ...
end
</code></pre>

This worked well, but it brought in a lot of false positives.  I got tweets about lost car keys, friends named Kate that aren't fugitives rescued from a plane crash, etc.  So, I added a simple algorithm for only displaying relevant tweets.  Giles calls it the _automated brain_.  

* A list of main keywords are defined:  <code>%w(kate sayid #lost)</code>.  This is used to generate the twitter search query.  Normal words are worth 1 point, and #hashtags are worth two.
* a list of secondary keywords are defined: <code>%w(tv season island episode tonight)</code>.  These words are only worth one point if a main keyword is in the post.

Here's how it looks (roughly):

<pre><code>
def valid_search_result?(main_keywords, secondary_keywords)
  if main_keywords.nil? then return true ; end
  score          = 0
  downcased_body = body.downcase
  score += score_from downcased_body, main_keywords
  if score.zero? then return false ; end
  score += score_from downcased_body, secondary_keywords
  score > 1
end

def score_from(downcased_body, words)
  return 0 if words.nil?
  score = 0
  words = words.dup
  words.each do |key|
    this_score = key =~ /^#/ ? 2 : 1 # hash keywords worth 2 points
    score += this_score if downcased_body =~ %r{(^|\s|\W)#{key}($|\s|\W)}
  end
  score
end
</code></pre>

It's very basic, but it filters out a lot of the crap that the search was returning.  While it did let a few [false positives](http://twitter.com/m_greelish/status/1137083793) in, it also managed to pick up [tweets like this](http://twitter.com/hooliagoolia/status/1137079994).  Here's the [actual implementation](http://github.com/technoweenie/islostonyet.com/blob/d6c24774526c74e6181f9b7aa65ddcec6ca6ffa1/lib/is_lost_on_yet/post.rb#L132-140) if you're curious...
