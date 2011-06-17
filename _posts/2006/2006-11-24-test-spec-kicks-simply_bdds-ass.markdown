--- 
layout: post
title: test/spec kicks simply_bdd's ass
---
Christian Neukirchen's "test/spec":http://chneukirchen.org/blog/archive/2006/10/announcing-test-spec-0-2-a-bdd-interface-for-test-unit.html is a worthy replacement of simply_bdd.  Its context/specify methods work almost exactly the same way, and Chris has gone to the trouble of converting the test/unit assert_* methods to should.* methods.  

I've started a little "test/spec on rails":http://svn.techno-weenie.net/projects/plugins/test_spec_on_rails/init.rb plugin for implementing some rails-specific should extensions.  It's very sparse right now, so patches are very welcome.

One other little experiment I added was specifying the chained should methods as a string:

<pre><code>
# OLD
5.should.not.be.nil
5.should.not.equal 6

# NEW
5.should "not be nil"
5.should "not equal", 6
</code></pre>

I don't know if I like that yet.  But, I'm also not crazy about all the periods either.
