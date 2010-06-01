--- 
layout: post
title: "Node.js For My Tiny Ruby Brain: Keeping Promises"
---
I've been hacking on [node.js](http://nodejs.org/) for a week now.  I won't go into why I think it's awesome, you probably already know (thanks to bloggers like [Simon Willison](http://simonwillison.net/2009/Nov/23/node/)).  

My second raw "hello world" speed test went something like this:

<pre><code># node.js on freenode
spoob: technoweenie; seriously, you should look up how fast nodejs is... :)
technoweenie: yea i was getting about 5k r/s, pretty impressive
spoob: you should be getting around 20k r/s?
technoweenie: really?
technoweenie: oh wait i only ran 5k requests</code></pre>

My first:

<pre><code># twitter
technoweenie: sample node.js server is *extremely* slow, am i missing something? i'm just trying the example app on nodejs.org  
technoweenie: oh i see, the demo app sets a 2s timeout, haha  
lifo: classic
technoweenie: hey that's a great way to start off a new web framework, simulate rails cgi speeds</code></pre>

sources: [1](http://twitter.com/technoweenie/status/7523390245), [2](http://twitter.com/technoweenie/status/7523413599),  [3](http://twitter.com/lifo/status/7523505615), [4](http://twitter.com/technoweenie/status/7523566800)

With that out of the way, I started hacking on [Where's Waldo](http://github.com/technoweenie/wheres-waldo) (taking a detour to bang out a [quick test framework](http://github.com/technoweenie/ntest) along the way).  Where's Waldo is a throw-away prototype using Redis for tracking locations of users.  Here's my first pass at tests:

<pre class="active4d"><code><span class="LineComment"><span class="LineComment">//</span> Github: technoweenie/wheres-waldo</span>
<span class="LineComment"><span class="LineComment">//</span> SHA: fa925fe483dac9a02e374971fe392c7e00f1e5d1</span>
<span class="LineComment"><span class="LineComment">//</span> http://github.com/technoweenie/wheres-waldo/blob/fa925fe483dac9a02e374971fe392c7e00f1e5d1/lib/index.js</span>
<span class="LineComment"><span class="LineComment">//</span> this source code has been modified to fit my blog post</span>
<span class="Storage">function</span> <span class="FunctionName">WheresWaldo</span>(<span class="FunctionArgument">redis, prefix</span>) {
  <span class="LibraryClassType">this</span>.<span class="FunctionName">track</span> = <span class="Storage">function</span>(<span class="FunctionArgument">user, location, ttl</span>) {
    <span class="Variable">this</span>.redis.set(<span class="Variable">this</span>.<span class="NamedConstant">prefix</span> <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> user, location).wait()
    <span class="Variable">this</span>.redis.set(<span class="Variable">this</span>.<span class="NamedConstant">prefix</span> <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> location <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> user, user).wait()
  }

  <span class="LibraryClassType">this</span>.<span class="FunctionName">locate</span> = <span class="Storage">function</span>(<span class="FunctionArgument">user</span>) {
    <span class="Keyword">return</span> <span class="Variable">this</span>.redis.get(prefix <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> user).wait()
  }

  <span class="LibraryClassType">this</span>.<span class="FunctionName">list</span> = <span class="Storage">function</span>(<span class="FunctionArgument">location</span>) {
    <span class="Storage">var</span> locationKey <span class="Operator">=</span> <span class="Variable">this</span>.<span class="NamedConstant">prefix</span> <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> location
    <span class="Storage">var</span> users <span class="Operator">=</span> <span class="Variable">this</span>.redis.keys(locationKey <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:*<span class="String">&quot;</span></span>).wait()
    <span class="LineComment"><span class="LineComment">//</span> return all users that aren't blank strings</span>
    <span class="Keyword">return</span> _.reduce(users, [], <span class="Storage">function</span>(users, user) {
      <span class="Keyword">if</span>(user <span class="Operator">&amp;</span><span class="Operator">&amp;</span> user.<span class="NamedConstant">length</span> <span class="Operator">&gt;</span> <span class="Number">0</span>)
        users.<span class="CommandMethod">push</span>(user.<span class="CommandMethod">substr</span>(locationKey.<span class="NamedConstant">length</span><span class="Operator">+</span><span class="Number">1</span>, user.<span class="NamedConstant">length</span>))
      <span class="Keyword">return</span> users;
    })
  }
}

<span class="LineComment"><span class="LineComment">//</span> http://github.com/technoweenie/wheres-waldo/blob/fa925fe483dac9a02e374971fe392c7e00f1e5d1/test/waldo_test.js</span>
describe(<span class="String"><span class="String">&quot;</span>tracking a user<span class="String">&quot;</span></span>)
  before(<span class="Storage">function</span>() {
    <span class="Variable">this</span>.waldo <span class="Operator">=</span> whereswaldo.create(redis, <span class="String"><span class="String">'</span>tracking<span class="String">'</span></span>);
    <span class="Variable">this</span>.waldo.track(<span class="String"><span class="String">'</span>bob<span class="String">'</span></span>, <span class="String"><span class="String">'</span>gym<span class="String">'</span></span>)
  })

  it(<span class="String"><span class="String">&quot;</span>tracks a user's location<span class="String">&quot;</span></span>, <span class="Storage">function</span>() {
    assert.equal(<span class="String"><span class="String">'</span>gym<span class="String">'</span></span>, <span class="Variable">this</span>.waldo.locate(<span class="String"><span class="String">'</span>bob<span class="String">'</span></span>))
  })

  it(<span class="String"><span class="String">&quot;</span>lists the user in that location<span class="String">&quot;</span></span>, <span class="Storage">function</span>() {
    assert.equal(<span class="String"><span class="String">'</span>bob<span class="String">'</span></span>, <span class="Variable">this</span>.waldo.list(<span class="String"><span class="String">'</span>gym<span class="String">'</span></span>)[<span class="Number">0</span>])
  })
</code></pre>

One of the Node.js goals is to never introduce a blocking api.  There aren't a lot of libraries yet, but the ones that exist are fully asynchronous.  Even a super-fast database like [Redis](http://code.google.com/p/redis/) has an [async node.js wrapper](http://github.com/fictorial/redis-node-client/).

A simple Redis GET command doesn't return a value, it returns a _Promise_.  A Promise is a [really basic event emitter](http://nodejs.org/api.html#_events) with just two events: _success_ and _error_.  Ideally, you'd take this promise, listen for the success and error events, and move on to the next request.  When that Redis query comes back, it emits the success event with the result, and any callbacks are run. 

If you look at my `locate()` method, you'll see that I called `Promise#wait` so that I didn't have to worry about that yet.  It's a convenient tactic for node.js newbies, but I would not recommend that you continue to do this.  I started off with a familiar synchronous lib that I could test.  Once my tests were green, I was free to experiment with these wild new promise objects.

<pre class="active4d"><code><span class="Storage">function</span> <span class="FunctionName">WheresWaldo</span>(<span class="FunctionArgument">redis, prefix</span>) {
  <span class="LibraryClassType">this</span>.<span class="FunctionName">locate</span> = <span class="Storage">function</span>(<span class="FunctionArgument">user</span>) {
    <span class="Keyword">return</span> <span class="Variable">this</span>.redis.get(<span class="Variable">this</span>.<span class="NamedConstant">prefix</span> <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> user)
  }
<span class="LineComment"><span class="LineComment">//</span> ...</span>

<span class="LineComment"><span class="LineComment">//</span> related test</span>
it(<span class="String"><span class="String">&quot;</span>tracks a user's location<span class="String">&quot;</span></span>, <span class="Storage">function</span>() {
  assert.equal(<span class="String"><span class="String">'</span>gym<span class="String">'</span></span>, <span class="Variable">this</span>.waldo.locate(<span class="String"><span class="String">'</span>bob<span class="String">'</span></span>).wait())
})
</code></pre>

See, promises are easy!  To make that `locate()` method asynchronous, I simply returned the same promise that the Redis client's `get` method returns.  Basically, I moved the `wait()` call from the library to the test.

<pre class="active4d"><code><span class="Storage">function</span> <span class="FunctionName">WheresWaldo</span>(<span class="FunctionArgument">redis, prefix</span>) {
  <span class="LibraryClassType">this</span>.<span class="FunctionName">list</span> = <span class="Storage">function</span>(<span class="FunctionArgument">location</span>) {
    <span class="Storage">var</span> locationKey <span class="Operator">=</span> <span class="Variable">this</span>.<span class="NamedConstant">prefix</span> <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:<span class="String">&quot;</span></span> <span class="Operator">+</span> location,
            promise <span class="Operator">=</span> <span class="Operator">new</span> <span class="TypeName">process.Promise</span>();
    <span class="Variable">this</span>.redis.keys(locationKey <span class="Operator">+</span> <span class="String"><span class="String">&quot;</span>:*<span class="String">&quot;</span></span>) 
      .addCallback(<span class="Storage">function</span>(keys) {
        <span class="Storage">var</span> users <span class="Operator">=</span> _.reduce(keys, [], <span class="Storage">function</span>(users, key) {
          <span class="Keyword">if</span>(key <span class="Operator">&amp;</span><span class="Operator">&amp;</span> key.<span class="NamedConstant">length</span> <span class="Operator">&gt;</span> <span class="Number">0</span>)
            users.<span class="CommandMethod">push</span>(key.<span class="CommandMethod">substr</span>(locationKey.<span class="NamedConstant">length</span><span class="Operator">+</span><span class="Number">1</span>, key.<span class="NamedConstant">length</span>))
          <span class="Keyword">return</span> users;
        })
        promise.emitSuccess(users);
      })
      .addErrback(<span class="Storage">function</span>() {
        promise.emitError();
      })
    <span class="Keyword">return</span> promise;
  }
}
</code></pre>

The `list()` method was a bit more complicated.  This time, WheresWaldo creates its own promise object to return.  It adds its own callbacks to the promise from the Redis client's `keys()` method.  From that success callback, it filters the keys array as desired, and emits the success event of its promise. 

The final gotcha was handling multiple fire-and-forget queries.  The [`track()` method](http://github.com/technoweenie/wheres-waldo/blob/master/lib/index.js#L13-17) sets two Redis values.  Personally, I don't have a preference which order they run in.  There were three options that I could see:

1. Call `wait()` on the first one before firing the second one.  Synchronous calls are bad!
2. Nest the second call in the success callback of the first call's promise.  Nesting is ugly!
3. Fire both queries and let Redis do its job.  Good, but I want to return just one Promise.

I went with #3, and wrote a [Promise Group](http://github.com/technoweenie/wheres-waldo/blob/master/lib/promise-group.js) class (though I believe this functionality may be on its way to node.js soon?)

The Promise Group takes an array of promise objects, and returns its own promise object that emits success when the group's promises are all finished.  This means that I can expect a single promise object from the `track()` method, and add callbacks as necessary.

That's it for the basics of working with the asynchronous node.js APIs.  If you'll notice, I like to work in an iterative, test-driven fashion.  I don't feel comfortable writing a lot of code without tests, so it was really helpful for me to start off with horrible synchronous calls and passing tests, and work my way up from there.
