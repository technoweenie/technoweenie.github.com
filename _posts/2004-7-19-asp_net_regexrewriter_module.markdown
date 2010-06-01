--- 
layout: post
title: ASP.Net RegexRewriter Module
---
I'm probably about the most anal ASP.Net developer ever.  One requirement for my web apps is that I my URLs are clean and bookmarkable.  I use the QueryString parameters where I can, but sometimes those get a bit messy.  So, I took some personal experience with "Apache mod_rewrite":http://httpd.apache.org/docs/mod/mod_rewrite.html and wrote a Regular Expression rewriter module for ASP.Net 2.0 with Visual Web Developer 2005.  

Let's say that in your application, you provide a Profile page for each user.  The URL would probably resemble <code>~/Profiles.aspx?User=Bob</code> or something similar.  Using the RegexRewriterModule, I can rewrite <code>~/Profiles/Bob.aspx</code> (which is much cleaner) to <code>~/Profiles.aspx?User=Bob</code>.  

First, create a file called RegexRewriter.Config in your project directory.  I use XmlSerialization to deserialize a simple XML File containing the rules.  Here's an example:

<pre><code>
<?xml version="1.0" encoding="utf-8" ?>
<RegexRewriter>
	<Rules>
		<Rule Pattern="^/Profiles/(\w+)\.aspx" UrlFormat="~/_Pages/Profile.aspx?User={0}" />
	</Rules>
</RegexRewriter>
</code></pre>

That should do the rewriting trick, but there's a few problems.  First, if you use the ~ shortcut for the application relative path, it might break.  The Page is going by the rewritten path, so both paths should be as "deep" as each other.  In the above example, both ASPX files are in one directory below the application root.

Also, the form's action tag will be pointing to the Rewritten path.  But, we want it to post back to our clean URL.  Using the techniques to create "Valid XHTML within .Net":http://www.liquid-internet.co.uk/content/dynamic/pages/series1article1.aspx, I created a very simple ActionForm class derived from HtmlForm.  The only difference is that you can set the Action property (or it automatically retrieves from a specified key in the HttpContext.Items collection).

Here's the basic workflow of the process:

# The RegexRewriterModule deserializes the RegexRewriterConfig from the datafile and caches it into the HttpContext.Application object.  If the file has changed since the last time it was cached, it is reloaded.
# The RegexRewriterConfig class stores the original URL in the HttpContext.Items collection.
# The RegexRewriterConfig loops through all defined RegexRules.  It rewrites the URL to the first successful match.
# The ActionForm class checks for a value in the HttpContext.Items collection or its Action property.  If nothing, it uses the Request path for the Action property.

To use the RegexRewriterModule:

# Include "these files":http://techno-weenie.net/stuff/RegexRewriter/RegexRewriter.zip in your /Code directory (Visual Web Developer Express does not allow you to compile class libraries)
# Add the custom HttpModule in your Web.Config:
<pre><code>
<httpModules>
    <add name="RegexRewriterModule" type="TechnoWeenie.Web.RegexRewriterModule" />
</httpModules>
</code></pre>
# Add this key/value in your appSettings:
<pre><code>
<appSettings>
    <add key="ActionForm.Key" value="RegexRewriter.OriginalPath" />
</appSettings>
</code></pre>
# Register the custom ActionForm control on your page (or MasterPage):
<pre><code>
<%@ Register tagprefix="tw" Namespace="TechnoWeenie.Web.Controls" %>
</code></pre>
# Replace the current HtmlForm control with the ActionForm:
<pre><code>
<tw:ActionForm runat="server">
...
</tw:ActionForm>
</code></pre>

If you have problems or suggestions, let me know.  Maybe when .Net 2.0 is finalized I'll release this in a more proper form.  You know, with an open license/copyright notice and an examples page...
