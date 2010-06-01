--- 
layout: post
title: "Nori: Node.js Riak wrapper"
---
<a href="http://blog.basho.com/2010/04/14/practical-map-reduce:-forwarding-and-collecting/"><img src="/images/2010/05/fault-tolerance.png" class="floater" alt="Map Reduce?" /></a>

I took the [Riak Fast Track](https://wiki.basho.com/display/RIAK/The+Riak+Fast+Track) and really liked messing around with map reduce functions.  So, I wrote [nori](http://github.com/technoweenie/nori), a node.js client.

Riak is a key/value store inspired by the Dynamo whitepaper.  It has buckets, which contain resources identified by keys, with a REST API.  Therefore, it feels a lot like S3, with added [map reduce](http://blog.basho.com/2010/04/14/practical-map-reduce:-forwarding-and-collecting/) and [link](http://blog.basho.com/2010/03/25/schema-design-in-riak---relationships/) [walking](http://blog.basho.com/2010/02/24/link-walking-by-example/) powers.  

Riak is written in Erlang, but Basho decided to also support javascript for map reduce.  This makes node.js a natural fit for Riak.  Node.js is of course great at handling non-blocking HTTP requests, and `function.toString()` lets us pass javascript functions through Nori.  This means it would be trivial to write local tests of your map reduce functions with local data (without having to go through Riak).  Look at how closely [my implementation](http://github.com/technoweenie/nori/blob/master/examples/fast-track/mapred.js#L6-19) matches [the sample functions in the fast track](https://wiki.basho.com/display/RIAK/Loading+Data+and+Running+MapReduce+Queries).

Overall, the Fast Track was pretty good.  I would have liked some coverage of link walking, but at some point you have to cut the "fast track" short.  It was short enough to digest in a sitting (though, it did turn a chillaxin' Sunday afternoon into an epic node.js hackfest).  
