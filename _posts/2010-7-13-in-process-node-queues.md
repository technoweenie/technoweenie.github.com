--- 
layout: post
title: In-Process Node.js Queues
---

Node.js is great at handling lots of asynchronous connections, but sometimes I'd like a limit to how many are in use.  One real world example is some kind of spider or feed reader.  If you have a list of 500 addresses to fetch, you don't want to fetch them all at once.  Maybe they're all on one server, or the requests return large files that need some post processing.

A simple queue like Resque is great for this, but I wanted something even simpler.  Something that lived in the Node.js process, and could exit cleanly without any of that persistent mess left over.  

[Chain Gang](http://github.com/technoweenie/node-chain-gang) is the result of my experimentation.  My idea is using the Node.js event system for pub/sub:

First, I specify my unit of work.  In this case, I'm fetching a a web address, and calling worker.finish() after that's done.

{% highlight coffeescript %}
sys:   require 'sys'
http:  require 'http'
client: http.createClient 8080, 'localhost'
# start an active chain gang queue with 3 workers by default.
chain: require('chain-gang').create()

# downloads a web page, runs the callback when it's done.
get_path: (path, cb) ->
  req: client.request('GET', path, {host: 'localhost'})
  req.end()
  req.addListener 'response', (resp) ->
    resp.addListener 'data', (chunk) ->
      sys.puts chunk
    resp.addListener 'end', cb

# returns a chain gang job that downloads a web page and finishes the worker.
job: (timeout, name) ->
  (worker) ->
    get_path "/$timeout/$name", ->
      worker.finish()
{% endhighlight %}

Now, I can add the callback, and queue the unit of work:

{% highlight coffeescript %}
# queues the job
chain.add job(1, 'foo')

# queues the job with the unique name "foo_request"
chain.add job(1, 'foo'), 'foo_request'
{% endhighlight %}

Assuming the chain gang queue is active, it should start executing the jobs immediately.  

There are two interesting behaviors that are possible now: Duplicate jobs are not run, and only a fixed number of jobs can run at any given time.  To highlight them, I have some sample files:  

* [webserver.coffee](/code/2010/7/chain-gang-sample/webserver.coffee) is a silly web server that waits for a specified amount of time before returning a request.  A URL like "/3/foo" will return in 3 seconds, for example.
* [chain-with-dupes.coffee](/code/2010/7/chain-gang-sample/chain-with-dupes.coffee) shows what happens when multiple jobs with the same name are queued.  In this contrived example, only the first, longer one is completed.  The rest are ignored.
* [chain-with-uniques.coffee](/code/2010/7/chain-gang-sample/chain-with-uniques.coffee) shows how Chain Gang handles more jobs than workers.  They just sit in an array until a free worker can take it.