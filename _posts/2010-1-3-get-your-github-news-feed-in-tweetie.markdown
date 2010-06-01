--- 
layout: post
title: Get your Github news feed in Tweetie
---
A few weeks ago, I started hacking on [twitter-server](http://github.com/technoweenie/twitter-server), an API wrapper for the Twitter API.  It's a [Sinatra extension](http://www.sinatrarb.com/extensions.html), where I toyed with the idea of adding top level API methods like `#twitter_statuses_home_timeline` to a Sinatra application.  I'm not altogether happy with the way the XML is rendered, but it works with Tweetie.

As a good real-world example, I wrote a [Github proxy](http://github.com/technoweenie/github_twitter_server) for my News Feed:

<script src="http://gist.github.com/268057.js"></script>

[Tweetie 2](http://www.atebits.com/tweetie-iphone/) for the iPhone and [Spaz](http://getspaz.com/) are the only Twitter clients I know of that let you customize the Twitter API urls that make this possible.  I mostly use Tweetie, so right now that's all that works currently.  It's all OSS on github, so I'm hoping I get some volunteers to help out :)

There is one major caveat: The news feed requires your Github API token.  I'm going to ask that you set up your own   github proxy if you want to access your news feed.  I don't want to be responsible for anything that might happen.  Luckily, [Heroku](http://heroku.com/) has your back.  

<script src="http://gist.github.com/268058.js"></script>

Now on Tweetie 2, setup a new account.  Enter your github username and your github token. Then, click the gear and set the API url to your heroku URL: `http://USER-gh-twitter.heroku.com`.  If you don't want to setup your own github proxy, you can just use mine:  `http://gh-twitter.heroku.com`.  Please don't enter your token though, it caches the feed info.  You'll just see results for your public github feed.

![iphone screenie](http://img.skitch.com/20100103-rpb43ku3urs64hmbr86jtwgr74.png)

There are a few bugs that I want to mention:

* Tweetie seems to have avatar issues if you have multiple accounts with the same name.  For this reason, you can create your accounts with a `gh_` prefix, and it'll get stripped.  I have my proxy username in Tweetie set to `gh_technoweenie`.
* Abnormally large feeds may not be cached properly.  I used this project as a pilot for [Friendly ORM](http://friendlyorm.com/), and ran into a number of issues on Postgres.  There are a few hacks for now, but I hope to work with James on resolving the issues between psql and Friendly.

Some major TODOS:

* Support other Twitter clients.  The twitter-server library needs serious help.
* Show github avatars.
* Send github private messages using the DM feature in Tweetie.
* [Ask github to give us public newsfeeds](http://support.github.com/discussions/feature-requests/652-public-news-feeds) so you don't have to enter a token.  When that happens, everyone can just use the main http://gh-twitter.heroku.com app.

**UPDATE** The latest update requires you to reset the db.  [It's simple to do on Heroku](http://techno-weenie.net/2010/1/3/a-note-on-the-github-twitter-proxy).
