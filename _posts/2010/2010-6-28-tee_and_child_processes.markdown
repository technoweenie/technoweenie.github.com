--- 
layout: post
title: Tee and Child Processes
---

My first node.js project at GitHub is a [replacement download server](http://github.com/blog/678-meet-nodeload-the-new-download-server).  I wanted to remove the extra moving pieces required to get it to work.  One of the steps involves writing a file from the output of `git archive`.  My initial attempt looked like this:

{% highlight coffeescript %}
fs:      require('fs')
child:   require('child_process')

git:     child.spawn 'git', ['archive', 'other options']
stream:  fs.createWriteStream outputFilename

# writes the file from git archive to the file stream
git.stdout.addListener 'data', (data) ->
  # if the file stream isn't flushed, pause git's stdout
  if !stream.write(data)
    git.stdout.pause()

# once the file stream is flushed, resume git's stdout
stream.addListener 'drain', ->
  git.stdout.resume()

git.addListener 'exit', (code) ->
  stream.end()
{% endhighlight %}

However, git archive's tar format does not come compressed.  That means I have to pipe the output to another ChildProcess object.  How do I do that without a lot of code duplication?  I put the common callbacks into defined functions:

{% highlight coffeescript %}
fs:      require('fs')
child:   require('child_process')

# writes data to the local file system.
streamer: (data) ->
  if !stream.write(data)
    input.pause()

# pipes the data to the gzip process.
gzipper: (data) ->
  if !gzip.stdin.write(data)
    git.stdout.pause()

# closes the written file stream.  
closer: (code) ->
  stream.end()

git:     child.spawn 'git', ['archive', 'other options']
stream:  fs.createWriteStream outputFilename

stream.addListener 'drain', ->
  input.resume()

# if this is a tarball, pipe `git archive` through `gzip -n`
if outputFilename.match(/\.tar\.gz$/)
  gzip:  child.spawn 'gzip', ['-n', '-c']
  input: gzip.stdout
  gzip.stdout.addListener 'data', streamer
  gzip.addListener        'exit', closer
  gzip.stdin.addListener  'drain', ->
    git.stdout.resume()
  git.addListener 'exit', (code) ->
    gzip.stdin.end()
else
  input: git.stdout
  git.addListener 'exit', closer

git.stdout.addListener 'data', (if gzip then gzipper else streamer)
{% endhighlight %}

That's the code to write either `git archive --format=zip` or `git archive --format=tar | gzip` to a file.  It works, but the code is more complicated than I'd like. 

[Ryan](http://github.com/rtomayko) suggested I use [tee](http://man.cx/tee(1posix\)) for outputting the file, and /bin/sh to assemble the pipes.

Now, the code is even simpler than my first attempt:

{% highlight coffeescript %}
child: require('child_process')

cmd: 'git archive ...'

if outputFilename.match(/\.tar\.gz$/)
  cmd += ' | gzip -n -c'

arch:    child.spawn '/bin/sh', ['-c', "$cmd | tee $outputFilename"]
arch.addListener 'exit', (code) ->
  # do something
{% endhighlight %}
