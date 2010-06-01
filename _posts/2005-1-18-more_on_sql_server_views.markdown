--- 
layout: post
title: More on SQL Server Views
---
bq. I have a SQL Server view defined to be "SELECT * FROM Table WHERE MyCriteria".  I intentionally coded it with "SELECT *" since I wanted it to be all fields no matter what -- just a subset of records.  A new field was added to my table recently -- no problem -- at least that's what I thought anyhow.  But this new field did not show up in my view afterall -- and Enterprise Manager still shows my view as being defined with "SELECT *".  So I dropped the view and recreated it -- that did the trick -- my new field is now in my view where it should be.  What's up with this behavior? -- "Paul Wilson":http://weblogs.asp.net/pwilson/archive/2005/01/18/355469.aspx

Terri Morton then makes a "comment":http://weblogs.asp.net/pwilson/archive/2005/01/18/355469.aspx#355526:

bq. It is so good to know I am not crazy (still sorry for your pain). This happened to me a couple of years back and I've never used a View since.

That's funny, because I did the same thing.  It wasn't until recently that I started looking at Views again.
