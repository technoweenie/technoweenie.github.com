--- 
layout: post
title: path to * mastery
---
I've been keeping up with the [Little Known Ways to Ruby Mastery series](http://rubylearning.com/blog/2009/01/06/little-known-ways-to-ruby-mastery-by-josh-susser/).  They all cover some very important topics: such as contributing to open source, keeping up a blog, and learning the standard library.  But there are a couple things I haven't seen anyone touch on:

### Break your code

Tutorials tend to go by the assumption that the listed code works as advertised, and that you'll be massively productive.  That rarely happens to be the case.  There are many times when little edge cases make the code blow up in strange ways.  Don't panic, just learn how to debug the errors and fix the issue.  I don't mean just commenting out enough code until it starts working, but actually finding the root of the error.  

Just today, I saw an issue where some background queue code wasn't working right when started from a rake task.  However, it worked great in production, and the tests all passed.  Rather than just noting that I needed to run the task in production mode somewhere, I researched the issue the found the cause.  As a result, I know my framework a little better, and was able to modify the code so this heisenbug doesn't rear its ugly head again.

### Help a newb

Don't wait until you've been promoted to _Ruby Master_ to help people out.  Start on day 1.  Take someone's question as an opportunity explore another part of the code that you normally wouldn't, and learn something new.  I spent a lot of time in my early rails days on irc helping folks out.  There are of course various forums, google groups, and even [Stack Overflow](http://stackoverflow.com/) full of people needing help.  Stack Overflow is a really good example that encourages users helping each other with the karma and badge system. 
