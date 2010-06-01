--- 
layout: post
title: database rollback in unit tests
---
Roy Osherove added "database rollback capabilities":http://weblogs.asp.net/rosherove/archive/2004/07/12/180189.aspx to NUnit, and called it NUnitX.

<pre><code>
[Test,Rollback]
public void Insert()
{
      //Do some inserts into the DB here
      //and the automatically roll back
}
</code></pre>
