--- 
layout: post
title: A note on the Github/Twitter Proxy
---
In my [last post](/2010/1/3/get-your-github-news-feed-in-tweetie), I made a quick note about how the [FriendlyORM](http://friendlyorm.com/) had some issues in Postgres.  I made a few quick hacks (all in the interest of finishing this up and launching it yesterday).  A few hours later, James Golick managed to [fix the issues](http://twitter.com/jamesgolick/status/7320090728) in a [special postgres branch](http://github.com/jamesgolick/friendly/tree/postgres).  I updated [the Github/Twitter proxy](http://github.com/technoweenie/github_twitter_server/tree/heroku) with a vendored version of Friendly.  If you have to upgrade though, you'll have to wipe the database.  Your steps on Heroku would look like:

<script src="http://gist.github.com/268062.js"></script>

Don't worry, only caching info is stored on the database.

For normal code updates, you only need to perform the first two steps above.  

Just out of curiosity, is anyone hosting their own?  If you don't want to mess with the server stuff, you can always just use http://gh-twitter.com without entering your token.  Once [Github gives into my demands](http://support.github.com/discussions/feature-requests/652-public-news-feeds), you'll be able to just use gh-twitter without any worries.
