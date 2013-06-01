--- 
layout: post
title: "\"paching\" with rails and ajax"
---
"Ajaxian":http://ajaxian.com/archives/ajax-as-a-remedy-for-the-cacheability-personalization-dilemma just pointed to a post by Michael Mahemoff: "Ajax as a Remedy for the Cacheability-Personalization Dilemma":http://softwareas.com/ajax-as-a-remedy-for-the-cacheability-personalization-dilemma.  He talks about caching generic pages and using remote ajax calls to fill in personal info.  This is something we've discussed in the "caboose":http://blog.caboo.se "just":http://blog.caboo.se/articles/2005/12/16/page-caching-your-whole-app a "few":http://blog.caboo.se/articles/2006/01/07/referenced-page-caching "times":http://blog.caboo.se/articles/2005/12/27/when-page-caching-goes-bad-horribly-bad.  

Look at "Rails Weenie":http://rails.techno-weenie.net for a live example of this ("7MB Quicktime":http://s3.amazonaws.com/techno-weenie-screencasts/paching_with_ajax.mov).  Every request looks for a session key and requests /javascripts/sessions/SESSION_KEY.js, which contains a call to either Auth.login or logout.  This then applies a different "behaviour stylesheet":http://bennolan.com/behaviour/ to the current page.  

Here are a few pitfalls I've experienced:

* Don't generate the login box dynamically with JS.  Browser form autofills usually don't like that.
* This may cause weird issues with uncommon or older browsers.  Rails Weenie is a personal experiment really, so I haven't had the time to really investigate these matters.
* Be very careful not to cache things like status messages.

Overall it was a waste of time purely because I still have never had a page slashdotted or heavily dugg.  However, I learned a lot from the process and extracted the "cool caching bits":http://svn.techno-weenie.net/projects/plugins/referenced_page_caching/ as a rails plugin.  The same aggressive caching is used on other projects, as well as this Mephisto blog.
