--- 
layout: post
title: Protocol Buffers with Riak for Node.js
---

I've been playing around with [Riak](https://wiki.basho.com/display/RIAK/The+Riak+Fast+Track) a bit lately.  It's a simple key/value store with S3-style buckets and one-way links between keys.  It also has clustering built in, and lets you run map/reduce against a set of data pretty easily.  All this, over a simple HTTP API.  

It's a great way to start playing with Riak, but I found it to be pretty slow.  With Riak, there are two more options: use the Erlang client, or write a Protocol Buffer adapter.  I'd never done anything with [Protocol Buffers](http://code.google.com/p/protobuf/), so I figured this was good opportunity.  

## Riak PBC Client

Armed with [Node.js Protocol Buffer](http://code.google.com/p/protobuf-for-node/) serializing and parsing abilities, I took a look at the [Riak PBC API](https://wiki.basho.com/display/RIAK/PBC+API).  It has a very simple API:

    00 00 00 07 09 0A 01 62 12 01 6B
    |----Len---|MC|----Message-----|

Each message starts with 4 bytes for the message length, a single byte for the message code, and then the message.

The example above is how a simple request for a key might look.

    // the Protocol Buffer schema.
    message RpbGetReq {
        required bytes bucket = 1;
        required bytes key = 2;
        optional uint32 r = 3;
    }

A Riak request looks something like this:

{% highlight coffeescript %}
Schema = require('protobuf_for_node').Schema
schema = new Schema(fs.readFileSync('./riak.desc'))
GetReq = schema["RpbGetReq"]

# <Buffer 0a 01 62 12 01 6b>
data = GetReq.serialize bucket: 'b', key: 'k'
len  = data.length + 1 # account for riak code too
req  = new Buffer(len + 4) # 4 byte message length
req[0] = len >>>  24
req[1] = len >>>  16
req[2] = len >>>   8
req[3] = len &   255
req[4] = 9
data.copy req, 5, 0 # copy serialized data to the buffer

# req is now
# <Buffer 00 00 00 07 09 0a 01 62 12 01 6b>
{% endhighlight %}

That assembles the message.  Now, we just create a tcp connection to send it to Riak:

{% highlight coffeescript %}
conn = net.createConnection 8087, '127.0.0.1'

conn.on 'connect', ->
  conn.write req
{% endhighlight %}

Finally, something needs to listen for the data event for a response:

{% highlight coffeescript %}
conn.on 'data', (chunk) ->
  len = (chunk[0] << 24) + 
        (chunk[1] << 16) +
        (chunk[2] <<  8) +
         chunk[3]  -  1 # subtract 1 for the message code
  type = lookup_type_from_code(chunk[4])
  msg  = new Buffer(len)
  chunk.copy msg, 0, 5
  data = type.parse msg
{% endhighlight %}

## Pooling Connections

My [initial example](http://gist.github.com/488488#file_riak.coffee) started off pretty basic, but started to grow out of control.  I quickly realized that since the socket API was very synchronous, I needed to implement a connection pool so a Node.js process could have simultaneous conversations with Riak.  A basic example looks like this:

{% highlight coffeescript %}
riak = new (require './protobuf')()
server = http.createServer (request, response) ->
  # get a fresh connection off the pool
  riak.start (conn) ->
    # make a connection, call the given callback when it returns.
    conn.send('PingReq') (data) ->
      response.writeHead 200, 'Content-Type': 'text/plain'
      response.end sys.inspect(data)
      conn.finish() # release the connection back to the pool

# SHORTCUT
server = http.createServer (request, response) ->
  # automatically gets a fresh connection, sends a request, and releases
  # it back to the pool when done.
  riak.send('PingReq') (data) ->
    response.writeHead 200, 'Content-Type': 'text/plain'
    response.end sys.inspect(data)
{% endhighlight %}

## nori + riak-js

Right now, this isn't in any released version of nori or riak-js.  The rough Protocol Buffers client is available in [the coffee branch of my riak-js fork](http://github.com/technoweenie/riak-js/blob/coffee/src/protobuf.coffee).

When Frank released the sweet [Riak-JS site](http://riakjs.org/), I took a hard look at what purpose nori was solving:

* I wanted to learn more about Riak (accomplished).
* I wanted to experiment with a new API style (very similar to Riak-js)
* I wanted a higher level Riak lib, more like an ORM.

The goals aligned pretty closely with riak-js, so there seemed no good reason to double our efforts.  I've decided to discontinue nori for the time being, and focus my Riak efforts in a refactoring of riak-js.  We want to have a single lib that lets you access Riak from jQuery (maybe), as well as Node.js over the HTTP and PBC APIs.

So, what is the current progress of all this?  Here are some quick benchmarks from my iMac i7:

{% highlight coffeescript %}
# riak-js http API 
# ab -n 5000 -c 20 
# 734.31 req/sec
sys  = require 'sys'
http = require 'http'
db   = require('riak-js').getClient()

server = http.createServer (req, resp) ->
  db.get('airlines', 'KLM') (flight, meta) ->
    resp.writeHead 200, 'Content-Type': 'text/plain'
    resp.end sys.inspect(flight)

server.listen 8124

# riak-js PBC API
# ab -n 5000 -c 20
# 1682.01 req/sec
sys  = require 'sys'
http = require 'http'
riak = new (require './protobuf')()

server = http.createServer (req, resp) ->
  riak.send('GetReq', bucket: 'airlines', key: 'KLM') (flight) ->
    resp.writeHead 200, 'Content-Type': 'text/plain'
    resp.end sys.inspect(flight)

server.listen 8124
{% endhighlight %}

That's over a 2x speedup, not bad.