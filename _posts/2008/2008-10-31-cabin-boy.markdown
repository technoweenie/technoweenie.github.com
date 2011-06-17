--- 
layout: post
title: Cabin Boy
---
<blockquote><p>
me: had a problem building the gem from source<br />
me: well, i'll wait til a rainy day<br />
me: shit its raining<br />
jbarnette: technogeist: be a man, get it to build ;)</p></blockquote>

Installing [Nokogiri](http://github.com/tenderlove/nokogiri/tree/master) turned out to be a pain.  I also needed [racc](http://i.loveruby.net/en/projects/racc/) and [frex](http://github.com/tenderlove/frex/tree/master) to build it properly.

<pre><code>
$ sudo gem install nokogiri
# failed with this: "checking for racc... no"
$ svn co http://i.loveruby.net/svn/public/racc/trunk racc
$ cd racc
$ sudo ruby setup.rb config
$ sudo ruby setup.rb setup
$ sudo ruby setup.rb install
$ ln -s /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/racc /usr/bin/racc
$ cd ..
$ git clone git://github.com/tenderlove/frex.git
$ cd frex
$ gem build frex.gemspec
$ sudo gem install frex-1.0.1.gem
$ sudo gem install nokogiri
</code></pre>

<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/iI3Yoqxn31U&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/iI3Yoqxn31U&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>
