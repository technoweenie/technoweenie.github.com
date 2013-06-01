--- 
layout: post
title: more on testing in ruby on rails
---
Ben Griffiths has an interesting entry: "A test by any other way":http://www.reevoo.com/blogs/bengriffiths/2005/06/24/a-test-by-any-other-name/.  He starts off showing how to cut down on duplication in your tests.  What really got me was his rake task to generate docs based on his test method naming scheme.  Here's a sample:

_security_controller should:_
* redirect to page stored in session on successful login
* store user object in session on successful login
* redirect to page stored in session after signup
* store user object in session after signup
* reject signup when passwords do not match
* reject signup when login too short
* report both errors if passwords dont match and username too short
* not store user in session if password not correct on signup
* remain on login page if password not correct on signup
* remove user from session on log out

He's generating contracts for his objects from the source code.  I think I'll adopt this style of test naming immediately.
