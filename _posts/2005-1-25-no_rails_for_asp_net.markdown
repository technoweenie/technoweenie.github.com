--- 
layout: post
title: no rails for ASP.Net?
---
Now that "rails":http://rubyonrails.org has been slashdotted, there are a lot of web developers are either hopping on the bandwagon (me included),  "bashing it":http://www.loudthinking.com/arc/000400.html, or trying to implement it in their own language ("trails":http://jroller.com/page/ccnelson/20050117#trails_tutorial_first_cut, "subway":http://subway.python-hosting.com/).

The Rails templating system is really nothing special.  ActiveRecord is very slick, but it reminds me of "SQLObject":http://sqlobject.org.  I believe "Twisted Python's":http://twistedmatrix.com/products/twisted web framework "nevow":http://nevow.com/ has a similar MVC(Model - View - Controller) architectrue.

"Ryan Tomayko":http://naeblis.cx/rtomayko/2005/01/23/no-rails-for-python nails it though:

bq. IMO, the real breakthrough with Rails is that each of the layers in the stack come bundled together and each understands the others fairly intimately. This combined with the dynamic aspect of the language allows pieces up the stack to provide sensible default functionality given concrete pieces down the stack.

I've been thinking about what it would take to implement this in ASP.Net.  ASP.Net 2.0 includes "Build Providers":http://www.theserverside.net/blogs/showblog.tss?id=BuildProviders that could dynamically create your model classes at compile time.  Server controls could be used for the Controller classes that load ascx skins as the Views.  
