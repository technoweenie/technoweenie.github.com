--- 
layout: post
title: Busy Railers Guide to BDD
---
*Update:* I have a "simply_bdd plugin":http://svn.techno-weenie.net/projects/plugins/simply_bdd/README now.

Luke's "Developing a Rails model using BDD and RSpec, Part 1":http://lukeredpath.co.uk/2006/8/29/developing-a-rails-model-using-bdd-and-rspec-part-1 is a very good read if you're just getting into Rails testing, or just want to check out how the folks in the BDD camp do things.

I've been interested in the whole BDD thing for awhile, ever since I started "prefixing my test methods with should_*":http://weblog.techno-weenie.net/2005/6/25/more_on_testing_in_ruby_on_rails.  So far I've found three main advantages of using BDD, and none of them are good enough (for me personally) to jump ship:

* Nudge TDD newbs towards writing better -tests- specs for their code.
* Nicer DSL-ish -tests- specs.  <code>context "should do this" do</code> or <code>@user.name.should_equal 'bob'</code>

And my favorite:

* Group tests under a common context with the same setup methods.  

I typically extract common setup stuff to a private method in the Test Case, or make a specific fixture for it.  Using BDD's context method seems to be more DRY than using a private method.  So, throw this in your test_helper.rb:

<pre><code>def context(name, &block)
  Object.const_set(name.to_s.gsub(/ +/, '_').camelize + 'Test', Class.new(Test::Unit::TestCase, &block))
end

# context "New User" do
#   becomes
# class NewUserTest < Test::Unit::TestCase</code></pre>

This will define multiple test cases in your test suite, but should run just fine.  You can do everything inside the context block that you can do while defining the new TestCase.

So, you like the specify method too?

<pre><code># test_helper.rb
class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def self.specify(name, &block)
    define_method 'test_' + name.to_s.gsub(/ +/, '_'), &block
  end
end

# specify "should require password" do
#   becomes
# def test_should_require_password</code></pre>

Think of this as a quick 6-line hack to test the BDD waters.
