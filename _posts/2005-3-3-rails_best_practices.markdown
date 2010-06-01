--- 
layout: post
title: Rails Best Practices
---
I've been knee deep in rails for about five weeks or so.  I've found it to be a rather powerful framework.  However, it's simplicity makes it very easy to write inefficient database code.  

In ASP.Net for example, if I want to load a list of issues, with their related comic books and publishers, I perform a single JOIN query and fill some objects.

In Rails, the code for setting up related objects is vastly simplified.  However, there's really no way to load multiple objects in a single query.  So, the simple way is to do something like this:

In the controller:
<pre><code>@issues = Issue.find_all</code></pre>

In the view:
<pre><code>
<% @issues.each do issue %>
<p><%=issue.comic.name%> #<%=issue.number%></p>
<% end %>
</code></pre>

This would give a list of issues with their comic title next to it.  The problem is, <code>issue.comic</code> is asking the DB for the data each time, even if that comic has already been loaded.  This executes n + 1 queries.

"Scott":http://scott.elitists.net suggested creating a small lookup hash:

<pre><code>
<% 
comics = Comic.find_all.inject({}) do |hsh, c|
  hsh.merge({c.id=>c})
end
@issues.each do issue %>
<p><%=comics[issue.comic_id]%> #<%=issue.number%></p>
<% end %>
</code></pre>

This executes only 2 queries, so you're not pounding the database  everytime the page is recached.

Any thoughts?
