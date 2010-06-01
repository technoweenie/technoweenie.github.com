--- 
layout: post
title: Dealing with $LOAD_PATH properly
---
I recently went through a process of consolidating a few backend miniapps that power some boring parts of Lighthouse and Tender.  I upgraded one app to Sinatra 1.0, and converted another from Rails to Sinatra.  The goal was to mount them in the same rack process, therefore simplifying the deployment process all around.  Doing this reinforced [Ryan's sage advice](http://twitter.com/rtomayko/status/1155906157) about [requiring rubygems in your libraries](http://tomayko.com/writings/require-rubygems-antipattern).

With libraries, it's cake.  Your [gem requirements](http://github.com/technoweenie/faraday/blob/9a8649b6d6be900eec81d38b3056901db6372f91/Rakefile#L13-14) are light.  No one is deploying your libraries as-is, so you can assume that any configuration is handled in their applications.  I'm still [struggling with tests a bit](http://github.com/technoweenie/faraday/blob/9a8649b6d6be900eec81d38b3056901db6372f91/test/helper.rb#L1-8), however.

1. Do not require rubygems (or rip, bundler, etc) in any files in `lib` or `test`.
2. Do not mess with the load path either.  

Applications are a different matter.  These typically will be deployed, so some kind of configuration file is essential.  I try to provide examples so coworkers can get up and running really quickly.  My config files typically look something like this:

<pre class="active4d"><code><span class="LineComment"><span class="LineComment">#</span> config.rb</span>
<span class="Variable"><span class="Variable">$</span>LOAD_PATH</span> <span class="Operator">&lt;&lt;</span> ... <span class="LineComment"><span class="LineComment">#</span> for setting up the Sinatra app's `lib` path and any </span>
<span class="LineComment">                  <span class="LineComment">#</span> vendored libraries</span>

<span class="Keyword">require</span> <span class="String"><span class="String">'</span>rubygems<span class="String">'</span></span> <span class="LineComment"><span class="LineComment">#</span> you can replace this with Bundler, Rip, etc</span>
gem <span class="String"><span class="String">'</span>sinatra<span class="String">'</span></span>, <span class="String"><span class="String">'</span>~&gt; 1.0.0<span class="String">'</span></span>
gem ...

<span class="Keyword">require</span> <span class="String"><span class="String">'</span>my-sinatra-app<span class="String">'</span></span>
</code></pre>

Now, when I re-package these in a different setting (such as when I mash two Sinatra apps into the same Rack process), I have full control over the `$LOAD_PATH` and the loaded gem versions.

One pattern I've adopted for apps using Sequel is some kind of `#load` method.  I had problems where my code was loading `Sequel::Model` instances before the database configuration was setup.  Requiring these files first would access the non-existent database configuration and blow up.

<pre class="active4d"><code><span class="LineComment"><span class="LineComment">#</span> OLD</span>
<span class="Keyword">require</span> <span class="String"><span class="String">'</span>my-app<span class="String">'</span></span> <span class="LineComment"><span class="LineComment">#</span> requires 'sequel' and 'my-app/foo_model'</span>
<span class="LibraryClassType">Sequel</span>.<span class="FunctionName">db</span> <span class="Operator">=</span> <span class="String"><span class="String">'</span>...<span class="String">'</span></span>

<span class="LineComment"><span class="LineComment">#</span> NEW</span>
<span class="Keyword">require</span> <span class="String"><span class="String">'</span>my-app<span class="String">'</span></span>
<span class="LibraryClassType">MyApp</span>.<span class="FunctionName">load</span> <span class="Keyword">do</span>
  <span class="LibraryClassType">Sequel</span>.<span class="FunctionName">db</span> <span class="Operator">=</span> <span class="String"><span class="String">'</span>...<span class="String">'</span></span>
<span class="Keyword">end</span>

<span class="LineComment"><span class="LineComment">#</span> implementation</span>
<span class="Keyword">def</span> <span class="FunctionName">self.load</span>
  <span class="Keyword">require</span> <span class="String"><span class="String">'</span>sequel<span class="String">'</span></span>
  <span class="Keyword">yield</span>
  <span class="Keyword">require</span> <span class="String"><span class="String">'</span>my-app/foo_model<span class="String">'</span></span>
<span class="Keyword">end</span>
</code></pre>

For what it's worth, I've started using `autoload` more lately.  That negates the problem completely.

<pre class="active4d"><code><span class="LineComment"><span class="LineComment">#</span> my-app.rb</span>
<span class="Keyword">require</span> <span class="String"><span class="String">'</span>sequel<span class="String">'</span></span>
<span class="Keyword">module</span> <span class="TypeName">MyApp</span>
  autoload <span class="UserDefinedConstant"><span class="UserDefinedConstant">:</span>FooModel</span>, <span class="String"><span class="String">'</span>my-app/foo_model<span class="String">'</span></span>

<span class="LineComment"><span class="LineComment">#</span> config.rb</span>
<span class="Keyword">require</span> <span class="String"><span class="String">'</span>my-app<span class="String">'</span></span>
<span class="LibraryClassType">Sequel</span>.<span class="FunctionName">db</span> <span class="Operator">=</span> <span class="String"><span class="String">'</span>...<span class="String">'</span></span>
<span class="LibraryClassType">MyApp</span>::<span class="FunctionName">FooModel</span>.do_something
</code></pre>

This is Sinatra-specific, but always subclass from `Sinatra::Base`.  I opt for the `classic Sinatra style` a lot because it's so convenient.  But once I have something running and tested, I make it a full class.

1. Using the classic style adds a lot of crufty methods to every object.  This can cause problems in mid to large projects.
2. You can easily isolate and test these Sinatra classes with Rack Test.  [Resque's Server](http://github.com/defunkt/resque/blob/master/lib/resque/server.rb#L1-7) provides a good sample implementation [with tests](http://github.com/defunkt/resque/blob/master/lib/resque/server/test_helper.rb#L6-10).

<pre class="active4d"><code><span class="Keyword">class</span> <span class="TypeName">MyAppTest<span class="InheritedClass"> <span class="InheritedClass">&lt;</span> Test::Unit::TestCase</span></span>
  <span class="Keyword">include</span> <span class="LibraryClassType">Rack</span>::<span class="FunctionName">Test</span>::<span class="FunctionName">Methods</span>

  <span class="Keyword">def</span> <span class="FunctionName">app</span>
    <span class="LibraryClassType">MyApp</span>::<span class="FunctionName">Api</span> <span class="LineComment"><span class="LineComment">#</span> subclasses Sinatra::Base</span>
  <span class="Keyword">end</span>
</code></pre>

This problem also extends to libraries using Sinatra.  At first, I couldn't figure out why one of my older Sinatra apps still used the classic Sinatra DSL.  I got my answer when I converted it: [ClassyResources was including itself into main](http://github.com/jamesgolick/classy_resources/blob/b822f02ed8101293a97bbb1c960fed8797346cbc/lib/classy_resources.rb#L121).  [I was not too pleased](http://twitter.com/technoweenie/status/10993934365).

I'm assuming this code pre-dated [Sinatra's excellent extension API](http://www.sinatrarb.com/extensions.html), so I spent an hour [registering the modules as proper Sinatra extensions](http://github.com/technoweenie/classy_resources/commit/9ab32a4828c1496b9fe82c827780ac383aed6377).  I was glad I could focus my programmer rage into a good learning process.

My [TwitterServer](http://github.com/technoweenie/twitter-server/blob/master/lib/twitter_server.rb) library serves as a good example of [well-tested](http://github.com/technoweenie/twitter-server/blob/master/test/sinatra/account_test.rb#L3-20) a Sinatra extension.

Following these guidelines, I was able to load both of the Sinatra apps together with a simple 3-line rackup file.

<pre class="active4d"><code><span class="Keyword">require</span> <span class="String"><span class="String">'</span>config<span class="String">'</span></span>
use <span class="Variable">MiniApp1</span>
run <span class="Variable">MiniApp2</span>

<span class="LineComment"><span class="LineComment">#</span> thin -R config.ru start</span>
</code></pre>

My only suggestion if you come across crappy libraries that muck with your `$LOAD_PATH` is to fork away and push any patches upstream.  Sorry in advance if it's one of mine :)

What good libraries out there handle this poorly?  Which ones are shining examples?  How do you handle similar issues?
