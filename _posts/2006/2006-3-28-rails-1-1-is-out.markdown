--- 
layout: post
title: Rails 1.1 is out
---
bq. The biggest upgrade in Rails history has finally arrived. Rails 1.1 boasts more than 500 fixes, tweaks, and features from more than 100 contributors. Most of the updates just make everyday life a little smoother, a little rounder, and a little more joyful. -- "Rails Weblog":http://weblog.rubyonrails.org/articles/2006/03/28/rails-1-1-rjs-active-record-respond_to-integration-tests-and-500-other-things

It sounds cheesy to say this, but this release redefined the way I approach my applications.  Rails has a richer domain model, even better AJAX support, automatic XML APIs, etc.  Besides the obvious things, here are a few things that have rocked my world:

h2. script/generate model

Such a small tweak goes a long way.  <code>script/generate model</code> now generates the necessary migration for the model.  This helps keep your updates tight and focused, rather than trying to generate 3 models at a time and write tests for them all.

h2. Integration Testing

Test coverage is becoming more and more important to me.  Integration Testing lets me fill in some of those gaps for areas that have been previously untestable.  For instance, I can now reliably "test my cache sweepers":http://techno-weenie.net/svn/projects/mephisto/trunk/test/integration/caching_test.rb.

h2. Test File Fixtures

Here's another area that hasn't been the easiest to test: file uploading. I've been using a modified version of Scott Barron's "File Upload":http://rubyi.st/show/9 class.  There's really not a whole lot to it though.  Start off by throwing your test files in test/fixtures/foo/* (Just pick a subdirectory under test/fixtures).  Write your test like so:

<pre><code>
post :upload_file, :file => fixture_file_upload('files/foo.png', 'application/pdf')
</code></pre>

h2. find refactoring

Stefan got a nice little #find refactoring patch in today that makes my life a lot easier with acts_as_paranoid.  Check out the "latest changeset":http://collaboa.techno-weenie.net/repository/changesets/1015.  Due to the addition of nested scopes and a cleaner #find method, acts_as_paranoid is no longer a hackish plugin.  

The actual #find refactoring was so things like grabbing the current scope and validation options occur only once per query.  The old #find method was a mess with all the options it had to support, and actually called itself multiple times. 
