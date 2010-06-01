--- 
layout: post
title: negative margin bug
---
I ran into a weird _negative margin_ glitch in IE.  I tried restructuring my layout to use "ryan brill's negative margin solution":http://www.ryanbrill.com/floats.htm, but it was a no-go.

I then noticed that the glitch was only occuring after a blockquote.  After some experimentation, I took out the left border.  It now works in Mozilla, IE, and Opera (the new version is _very_ smooth, by the way).

I've gone back to my original two-column layout method now, it didn't require an extra wrapper div.  Here's the structure of the layout:

* body
** wrapper[1]
*** container
**** header
**** menu
**** content
**** side
**** footer
**** search

fn1. #wrapper is used to add a background image to the dark border around #container
