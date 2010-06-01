--- 
layout: post
title: flickr changes
---
Excuse the comics photostream mess.  Looks like "Flickr":http://flickr.com changed the Atom feed a bit.  Looks like I'll have to hack some code to fix it...

First, the descriptions all contain "_username_ posted a photo" in the front.  This broke my code that grabs the clean (no HTML or linebreaks) image description used in the alt tag.  Now that img alt tags contain just the comic title.  This wreaks havoc in my world, but I'm sure the added username works nicely for those importing multile photostreams into a blog.

Next, the description used to link the small version of the image.  Well, I wanted the thumbnail size, so I had a regular expression pull out the unique image ID (The <samp>6bd93ea789</samp> <code>http://www.flickr.com/photos/525639_6bd93ea789_t.jpg</code>).  The actual photo ID can be taken from the Atom ID element.  Obviously I had to change my expression a bit.

Relying on regular expressions is obviously not a healthy practice.  I just wish each item had an alternative link element to the various sizes of the image.
