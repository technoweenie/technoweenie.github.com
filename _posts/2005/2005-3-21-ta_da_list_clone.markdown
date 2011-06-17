--- 
layout: post
title: Ta-da list clone
---
Apparently the java and ruby on rails camps have been going at it like rival high schools.  "Ta-Da List":http://www.tadalist.com/ is the latest from 37signals, boasting about its lightweight codebase (600 lines or so) and quick development time.  

Geert Bevin "implemented Bla Bla List":http://rifers.org/blogs/gbevin/2005/3/18/blabla_tada_in_java in "Rife":https://rife.dev.java.net/, a java web framework in about 900 lines of code (including XML configurations). 

David "fires back":http://weblog.rubyonrails.com/archives/2005/03/19/bla-bla-list-cloning-a-rails-app-in-rife/ with a couple comparisons of similar code.  Obviously they're two samples that make java look gross and verbose, and ruby short and sweet. 

This has me wondering: why exactly is Ta-Da List 600 lines of code?  From this example it looks like it should be at least half the size of Bla Bla list.  I'm guessing that there's some extensive unit testing involved.  In my comic book database project, the unit testing code outnumbers the application code by a ratio of 1.2 to 1.
