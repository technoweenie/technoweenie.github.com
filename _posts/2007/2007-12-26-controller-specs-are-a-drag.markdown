--- 
layout: post
title: Controller specs are a drag
---
Ever since Jamis "taught us about fat models and skinny controllers":http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model, the controller's importance has dipped a bit (for the best).  Controllers should only be testing the basic things, such as the fact that it's using the params correctly to retrieve and create records, and returning the right response.  Any more details about the model are usually exercised in model specs.  This can make the examples incredibly repetitive:

<pre><code>
it "should set @records when accessing GET /index" do
  get :index
  assigns[:records].should_not be_nil
end
</code></pre>

* For those not using rspec, you can pretty much replace 'spec' with 'test case' and 'example' with 'test'.  It's all the same, really.

Rspec tends to encourage that the controller examples be broken up into finer contexts, such as by action.  (You can do this with test/unit of course, but it's not nearly as common).  You're also encouraged to keep to a "single assertion per example" discipline.  This way if one assertion fails, the other assertions are still run in other examples.  Good practice to follow, but it results in a lot of extra time spent writing more spec examples.  Here's what I came up with: "(old and busted)":http://git.caboo.se/?p=altered_beast.git;a=blob;f=spec/controllers/forums_controller_spec.rb;h=6d92e80600049f511005a87675a4dad173d4651b;hb=923a33cbc82235b1f1e0c05637f68f9746bda842

While soliciting for comments, <a href="http://yehudakatz.com/">Yehuda Katz</a> scoffed at all the repetition.  Not that I blamed him, it seemed rather silly to write 560 lines of spec code for a "90 LOC controller":http://git.caboo.se/?p=altered_beast.git;a=blob;f=app/controllers/forums_controller.rb;h=8746a2e93de361101209c21e9cb9fffff2ddb6cb;hb=HEAD. We swapped ideas back and forth and wondered if there was some way to define meta spec examples to ease the controller speccing process.  Here's the basic outline we came up with:

<pre><code>
it.assigns :forum, :flash => {:notice => :not_nil}
it.redirects_to { forum_path(@forum) }
it.renders :template, :index
</code></pre>

As you can see, I managed to cut the "controller spec":http://git.caboo.se/?p=altered_beast.git;a=blob;f=spec/controllers/forums_controller_spec.rb;h=6d93c71e6d95f2b0883f7d2e6994784babfe92fa;hb=HEAD _in half_, with this "new hotness":http://git.caboo.se/?p=altered_beast.git;a=tree;f=vendor/plugins/rspec_on_rails_on_crack/lib;h=62b5fe1ccad8186a989f5d72dd218f3678fae518;hb=HEAD.  There are a few minor things there to contribute to back to rails and rspec.  Yehuda mentioned he was going go implement the same API for the merb testing harness.  Any thoughts on this approach?

*Update*: fixed a textile error around the "90 LOC..." link.  Also, moved this to its own git repository: git://activereload.net/rspec_on_rails_on_crack.git.  I also made a quick custom_scaffold generator in git://activereload.net/custom_scaffold.git.
