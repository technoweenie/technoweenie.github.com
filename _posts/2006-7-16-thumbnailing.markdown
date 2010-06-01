--- 
layout: post
title: Thumbnailing
---
The first way is through the resize_to option:

<pre><code>
acts_as_attachment :storage => :file_system, :resize_to => '300x200'
</code></pre>

The option takes two forms of parameters, a standard width/height array (<code>[300, 200]</code>), and an "RMagick Geometry string":http://www.imagemagick.org/RMagick/doc/imusage.html#geometry.  The various codes can give you a lot of power.

Resizing the original image is not always desired.  Sometimes you will want to change thumbnail sizes and regenerate.  Not having the original around makes this impossible.  So instead, we'll create various thumbnail sizes.

<pre><code>
acts_as_attachment :storage => :file_system, :thumbnails => { :normal => '300>', :thumb => '75' }
</code></pre>

The '300>' geometry code will resize the width to 300 if it's larger, and keep aspect ratio.  The '75' geometry code will always resize the width to 75, while keeping the aspect ratio.

Now let's change the show view to accomodate for these new thumbnails.

<pre><code>
<p>Original: <%= link_to @dvd_cover.filename, @dvd_cover.public_filename %></p>
<% @dvd_cover.thumbnails.each do |thumb| -%>
<p><%= thumb.thumbnail.to_s.humanize %>: <%= link_to thumb.filename, thumb.public_filename %></p>
<% end -%>
</code></pre>

There are a few things to explain here:  

* <code>public_filename</code> is a dynamic method that gets the public path to a file.  This only works on file system attachments.  It basically takes the full_filename (absolute path to the file on the server) and strips the RAILS_ROOT from the beginning, making it suitable for links.

* Attachments have a <code>parent</code> association that links to the original image, and a <code>thumbnails</code> has_many that links to all the thumbnails.  You can use this to iterate through all the thumbnails for an image.

* Thumbnails store the thumbnail key taken from the :thumbnails options above.  This example DVD Covers app uses normal and thumb.  File based attachments add this to the end of the file, resulting in names like cover.jpg, cover_normal.jpg, and cover_thumb.jpg.

* <code>public_filename</code> is smart enough to take a thumbnail key to generate its filename.  For instance, the show action above can be rewritten more efficiently without having to load the thumbnails:

<pre><code>
<% DvdCover.attachment_options[:thumbnails].keys.each do |key| -%>
<p><%= key.to_s.humanize %>: <%= link_to key, @dvd_cover.public_filename(key) %></p>
<% end -%>
</code></pre>

Now, you may notice the index action is listing thumbnails too.  This can easily be remedied in the controller:

<pre><code>
  def index
    @dvd_covers = DvdCover.find(:all, :conditions => 'parent_id is null')
  end
</code></pre>
