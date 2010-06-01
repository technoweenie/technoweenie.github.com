--- 
layout: post
title: Escaping your test suite with your life
---
<img src="http://img.skitch.com/20100504-cw3qshfnw9cpjrrtcbunu3mw93.png" class="floater" alt="Arnold in Running Man" />

One testing feature that I really miss in test/unit, is [rspec](http://github.com/dchelimsky/rspec)'s `before(:all)` blocks.  These are similar to your test/unit `setup` methods, yet they only run once for the whole test suite.  

I was able to [implement `before(:all)` callbacks in context](http://github.com/jm/context/blob/master/lib/context/suite.rb#L29-34), but the code for that is a little gnarly.  Basically, I had to hack the `Test::Unit::TestSuite#run` method to run some callbacks before and after the test run.  Downside: it doesn't work in minitest (it could, but [the code](http://github.com/ruby/ruby/blob/ruby_1_9_1/lib/minitest/unit.rb#L405-426) isn't very inviting).

So, what if I could do something like this?

<pre class="active4d"><code><span class="Keyword">class</span> <span class="TypeName">MyTest<span class="InheritedClass"> <span class="InheritedClass">&lt;</span> ActiveSupport::TestCase</span></span>
  block <span class="Operator">=</span> <span class="LibraryClassType">RunningMan</span>::<span class="FunctionName">Block</span>.<span class="FunctionName">new</span> <span class="Keyword">do</span>
<span class="LineComment">    <span class="LineComment">#</span> something expensive</span>
  <span class="Keyword">end</span>

  setup { block.<span class="FunctionName">run</span>(<span class="Variable">self</span>) }
<span class="Keyword">end</span>
</code></pre>

[Running Man](http://github.com/technoweenie/running_man) gives you `before(:all)` callbacks in test/unit and minitest (ruby 1.9).  Basically, you create a `RunningMan::Block` and call `#run` in a normal setup call in your tests.  The `RunningMan::Block` calls the block just once, and fills your test case instances with the right instance variables on each test.  No muss, no ugly test/unit hacking.  (Ok, before you call me [a liar](http://github.com/technoweenie/running_man/blob/master/lib/running_man/block.rb#L96-110), _that_ hack was to allow special teardown blocks on the last test.  That feature doesn't work in ruby 1.9, unfortunately.)

This was extracted from GitHub and rewritten when I wanted to use it [in a small, non-Rails project](http://github.com/technoweenie/seinfeld/blob/rewrite/test/user_test.rb).

<pre class="active4d"><code><span class="Keyword">class</span> <span class="TypeName">MyTest<span class="InheritedClass"> <span class="InheritedClass">&lt;</span> ActiveSupport::TestCase</span></span>
  fixtures <span class="Keyword">do</span>
    <span class="Variable"><span class="Variable">@</span>post</span> <span class="Operator">=</span> <span class="LibraryClassType">Post</span>.<span class="FunctionName">make</span> <span class="LineComment"><span class="LineComment">#</span> &lt;3 Machinist</span>
  <span class="Keyword">end</span>

  test <span class="String"><span class="String">&quot;</span>check something on post<span class="String">&quot;</span></span> <span class="Keyword">do</span>
    assert_equal <span class="String"><span class="String">'</span>foo<span class="String">'</span></span>, <span class="Variable"><span class="Variable">@</span>post</span>.<span class="FunctionName">title</span>
  <span class="Keyword">end</span>

  test <span class="String"><span class="String">&quot;</span>delete post<span class="String">&quot;</span></span> <span class="Keyword">do</span>
    <span class="Variable"><span class="Variable">@</span>post</span>.<span class="FunctionName">destroy</span>
  <span class="Keyword">end</span>
<span class="Keyword">end</span>
</code></pre>
