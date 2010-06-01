--- 
layout: post
title: Benchmarking ActiveDocument vs ActiveRecord
---
I created a reference rails app with a single controller to benchmark the difference between ActiveRecord and ActiveDocument.

First, let's create some posts to populate the database.

<pre><code>
# ActiveRecord
> script/performance/benchmarker 100 'Importer.run'
            user     system      total        real
#1      2.080000   1.060000   3.140000 (  4.655729)

# ActiveDocument
> script/performance/benchmarker 100 'Importer.run'
            user     system      total        real
#1      2.060000   0.150000   2.210000 ( 28.470869)

# ActiveDocument (json branch)
> script/performance/benchmarker 100 'Importer.run'
            user     system      total        real
#1      2.020000   0.140000   2.160000 ( 27.215934)
</code></pre>

Now, let's retrieve some posts:

<pre><code>
# ActiveRecord
> script/performance/benchmarker 1000 'Post.find(55)'
            user     system      total        real
#1      0.640000   0.050000   0.690000 (  0.685781)

> script/performance/benchmarker 100 'Post.find(:all)'
            user     system      total        real
#1     16.840000   0.080000  16.920000 ( 17.107640)

# ActiveDocument
> script/performance/benchmarker 1000 'Post.find("76d77998-7721-48c6-9ffd-8925efeb8b7e")'
            user     system      total        real
#1      0.490000   0.030000   0.520000 (  0.891832)

> script/performance/benchmarker 100 'Post.find(:all)'
            user     system      total        real
#1      4.860000   0.070000   4.930000 (  8.574478)

# ActiveDocument (json branch)
> script/performance/benchmarker 1000 'Post.find("1b3033bb-7d04-44ff-a1d3-1727d06c603e")'
            user     system      total        real
#1      0.400000   0.030000   0.430000 (  0.820451)

> script/performance/benchmarker 100 'Post.find(:all)'
            user     system      total        real
#1      3.110000   0.060000   3.170000 (  7.097080)
</code></pre>

It's still a bit messy since ActiveDocument is still incomplete.  But, you can grab the Battle Royale app I used to test it at:

<pre><code>
git://activereload.net/battleroyale.git
</code></pre>

Oh, and it turns out that I was not the first or second, but fourth or fifth to start this project.  "Sebastian":http://notsostupid.com/ started a "Google group":http://groups.google.com/group/activedocument for all of us.
