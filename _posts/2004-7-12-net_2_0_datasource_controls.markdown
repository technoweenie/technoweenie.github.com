--- 
layout: post
title: ".Net 2.0: *DataSource controls"
---
One of the great new features of ASP.Net 2.0 is the "Simplified and Extended Data Binding Syntax":http://www.123aspx.com/redir.aspx?res=32161.  *Simplified* meaning the DataBinder object is in the default context, so:

<pre><code>
<%#DataBinder.Eval(Container.DataItem, "Price", "{0:C}")%>
</code></pre>

becomes:

<pre><code>
<%#Eval("Price", "{0:C}")%>
</code></pre>

Nice, but I usually just call a my own method.  The codebehind is less messy, and there's less reflection guesswork.

*Extended* Data Binding has to do with the new DataSource controls.  It seems that they are really trying to cater to non-developers with these Designer Friendly controls.  "70% less code":http://msdn.microsoft.com/asp.net/whidbey/default.aspx?pull=/library/en-us/dnvs05/html/datacontrolswhidbey.asp was the team's goal.  And by _code_, they mean the CodeBeside type, not the ASPX type.  More designers and less coding = MS Access for the Web.

First, I see the ASPX page as a means to display the structured data to the browser.  I like it as clean as possible for the Web Designer.  The CodeBeside (which is _vastly_ improved over CodeBehind by the way) code stays out of the way.

Even with my obvious objection to the DataSource controls, I decided to give them a spin.  Since I abstract my database stuff out of the way, I went with the ObjectDataSource.  To keep my ASPX clean, I wrote some a few lines in my CodeBeside to include it on the page:

<pre><code>
ObjectDataSource obj = new ObjectDataSource("MyDataProvider", "GetWidgets");
obj.ID = "MyDataSource";
Page.Controls.Add(obj);
</code></pre>

This allowed my DataBound control to attach to it with the <code>DataSourceID</code> property.  This solves my first objection.

My next one deals mainly with the ObjectDataSource, since complex projects deal with data layers, not databases.  Reflection is costly.  I'm just guessing, but the ObjectDataSource probably uses a lot of Reflection to instantiate a new MyDataProvider class, call the select method, and bind controls to properties.  

I did a quick speed test.  The ObjectDataSource took .08 seconds to bind a small collection to a BulletList.  Using manual readonly data binding took only .01 seconds.  Maybe if you're in a time crunch, and you have some complex data binding to do, the Reflection tax won't mean much.  Or, if you just have a simple query you need displayed, inline SqlDataSources should do you well.
