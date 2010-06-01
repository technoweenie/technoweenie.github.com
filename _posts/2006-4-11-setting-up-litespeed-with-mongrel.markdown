--- 
layout: post
title: setting up litespeed with mongrel
---
I've been running both this weblog and Rails Weenie on "mongrel":http://mongrel.rubyforge.org and litespeed for a couple weeks now, so I wanted to write a couple notes on how everything is set up.  

Setting up "Litespeed":http://litespeedtech.com/ to host Rails applications is dead simple, especially if you go by Bob's "Launching Rails at the Speed of Lite":http://www.railtie.net/articles/2006/01/21/up-and-running-in-the-speed-of-light article.    The only part that's different is setting up the external application for mongrel instead of FCGI.  Instead of an external FCGI application, this weblog uses an external web server application on a unique port.  Rails Weenie gets a lot more traffic, so I decided to set up three external applications:  Two web servers and one Load Balancer.  Here's what my external applications tab looks like for rails weenie:

<notextile>
<table>
<tr><th colspan="3">External Applications</th></tr>
<tr>
<th>Type</th>
<th>Name</th>
<th>Address</th>
</tr><tr>
<td>Web Server</td>
<td>rails-weenie-xxx1</td>
<td>127.0.0.1:xxx1</td>
</tr><tr>
<td>Web Server</td>
<td>rails-weenie-xxx2</td>
<td>127.0.0.1:xxx2</td>
</tr><tr>
<td>Load Balancer	</td>
<td>rails-weenie-load-balancer</td>
<td>N/A</td>
</tr>
</table>
</notextile>

After your external applications are set up, all you need is a Litespeed context mapping the / url to either the load balancer or a single web server.  Now, you are free to start/stop the mongrel processes as you wish.  Here's a sample mongrel command:

<pre><code>
mongrel_rails start -d -e production -p xxx1 -P log/mongrel-1.pid
mongrel_rails start -d -e production -p xxx2 -P log/mongrel-2.pid
</code></pre>

h3. So how well does this all perform?  

I currently get between 300-400 requests/second, according to some benchmarks that "Jason":http://textdrive.com ran for me.  He was also nice enough to compile the ruby-sendfile plugin for me, bringing the total requests/second up to around 450-500.  

That is pretty fast, until you consider that most of the site is page cached.  My old mac mini easily gets 1000 requests/second from page cached rails apps.  So, what's the deal?  The fact is, lighttpd completely bypasses Rails if it finds an existing file.  No matter what Zed does on the ruby side, it could never compete with a c++ web server.  However, since mongrel functions as a full web server, it feels compelled to serve static as well as dynamic requests.

h3. What are our options?

* Zed shows how to use lighttpd's CML feature to serve static files with lighttpd and dynamic files with mongrel in the "Lighttpd tutorial":http://mongrel.rubyforge.org/docs/lighttpd.html.
* Zed has mentioned supporting the "X-Sendfile header":http://celebnamer.celebworld.ws/stuff/mod_xsendfile/.  Mongrel could simply return this, telling the frontend web server to serve the file.  I'm not sure if lighttpd or litespeed support this currently.
* The "ruby-sendfile":http://rubyforge.org/projects/ruby-sendfile gem helps if you're OS supports it, as I found out above.
* Zed also brought up the "TUX Web Server":http://en.wikipedia.org/wiki/TUX_web_server, a super-fast kernel-based web server for serving static files.
