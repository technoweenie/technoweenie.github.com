--- 
layout: post
title: using calculations to group results by day
---
bq. Programming is looking at a feature request in the morning, thinking “I can do that in one line of code”, and then six hours later having refactored the rest of the codebase sufficiently that you can implement the feature…
…in one line of code.  -- via "FishBowl":http://fishbowl.pastiche.org/2005/09/27/programming_is

So, I recently discovered the open sourced "MeasureMap date slider component":http://www.measuremap.com/developer/slider/.  I was very impressed with it while using MeasureMap, so I really wanted to incorporate that into Rails Weenie somehow.  It's very well done, and not long after I was faced with a working slider.

Now, to generate the XML from live stats. Calculations should make this very easy:

<pre><code>
@stats = Article.calculate :count, :id, :group => 'date(created_at)'
</code></pre>

Problem is, it didn't properly handle grouping by an SQL function.  When ActiveRecord selects the data with #select_all, the column used to reference this info differs in PostgreSQL (and I imagine a few others).  MySQL and SQLite both return the column as 'date(created_at)', while PostgreSQL calls it just 'date.'

So, I did some hacking, added some passing tests, and now Calculations is that much more robust in dealing with queries like this.  Now regarding the date_slider component, I created a plugin that will generate an example controller and view, as well as provide the javascript and flash files.  I also created a quicktime video showing the installation.  The audio was not cut very well, so I'll have to recompress it before I throw it online.

<pre><code>
./script/plugin install http://techno-weenie.net/svn/projects/plugins/date_slider
script/generate date_slider stats  # creates stats_controller 2 views for it
</code></pre>
