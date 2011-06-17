--- 
layout: post
title: more on avoiding ruby keywords
---
I've been looking more closely at metaprogramming in my continuing education of Ruby.  I was introduced to the basics of Ruby metaprogramming early on with scaffolding:

<pre><code>@model.send(attr_name)</code></pre>

Wow, much simpler than the "reflection API":http://msdn.microsoft.com/library/en-us/cpref/html/frlrfsystemreflection.asp I'm used to using.  Writing the @acts_as_versioned@ extension forced me to learn a little more.  What really opened my eyes, however, was MenTaLguY's peak into a "word without keywords":http://moonbase.rydia.net/mental/blog/programming/avoiding-ruby-keywords.html.  

Anyways, I posted a "code snippet":http://www.bigbold.com/snippets/posts/show/637 that creates a class from a string ('My::Module::Test'), along with any modules along the way...
