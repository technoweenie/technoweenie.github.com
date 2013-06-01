--- 
layout: post
title: Moving to git
---
Ever since starting my latest client project a few months ago, I've started using git.  I had the fortune to be trained by a couple "git":http://eagain.net/blog/ "badasses":http://scie.nti.st, so it was a pretty smooth transition.  At some point, I figured it was time to start porting my own open source projects to git, while keeping the svn repositories current.  Here's a rakefile I worked up to move my own plugins in one command:

<macro:code lang="ruby"># imports all dirs in given SVN dir as a separate git repo in the current directory
# pass SERVER= to specify a remote git server.  it'll add it as a remote for origin and push master:refs/heads/master
task :fetch_plugins do
  raise "need svn repo in SVN env var" if ENV['SVN'].nil?
  ENV['GIT'] ||= 'git'
  repos = %x{svn ls #{ENV['SVN']}}.split
  repos.each do |repo|
    next unless repo =~ /\/$/ && !File.exist?(repo)
    repo.gsub! /\/$/, ''
    FileUtils.mkdir_p repo
    error = false
    Dir.chdir repo do
      begin
        puts "initializing #{repo}..."
        %x{git svn init #{ENV['SVN']}/#{repo}}
        puts %x{git svn fetch}
        if ENV['SERVER']
          puts %x{git remote add origin #{ENV['GIT']}@#{ENV['SERVER']}:#{repo}.git}
          puts %x{git push origin master:refs/heads/master}
          puts %x{git config branch.master.remote 'origin'}
          puts %x{git config branch.master.merge 'refs/heads/master'}
        end
      rescue
        error = $!
      end
    end
    if error
      FileUtils.rm_rf repo
      puts "removing #{repo}: #{error.inspect}"
    end
  end
end</macro:code>

If you read through, it does these basic commands:

<pre><code>
mkdir pluginname
cd pluginname
git svn init http://pluginurl
git svn fetch
# get some coffee
git remote add origin git@server:pluginname.git
git config branch.master.remote 'origin'
git config branch.master.merge 'refs/heads/master'
git push origin master:refs/heads/master
</code></pre>

The last command pushes the local master branch to a master branch on the remote git server.  Once that's done,  you should be able to git push/pull without issues.  However, there's something missing from the .git/config file, and in my git newbieness, I have no idea how else to fix:  *Update* - I know how to fix this now.  See the git config commands in the rake task.  No more need to modify .git/config manually.

<pre>[branch "master"]
        remote = origin
        merge = refs/heads/master</pre>

You can setup "gitosis":http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way on the server to manage the repos.  It's a brilliant piece of software that uses a single 'git' user account and public keys to manage access to various repos.  The only issue I had with the config file though, was that it required a [repo] entry for every plugin to enable git daemon access.  Here's what I mean:

<pre>[group activereload]
writable = gitosis-admin lighthouse warehouse darkroom
members = caged rick

[group mephisto]
writable = mephisto
members = imajes psq svenfuchs caged rick

# enable gitweb 
[repo mephisto]
daemon = yes
</pre>

You now clone mephisto and the "rest of my open source projects":http://activereload.net/plugins/ with a command like "git clone git://activereload.net/mephisto.git".

Oh, and merry christmas and all that.  I didn't really intend for this to be "one of those" posts.  I'm just having some problems going back to sleep after playing santa (putting out presents, eating the cookies, etc).
