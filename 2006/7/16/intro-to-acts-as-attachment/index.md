--- 
layout: post
title: Intro to Acts As Attachment
---
h2. Features

* Choose either file system or active record storage
* Allow unlimited thumbnails with different sizes and filenames
* Uses RMagick for flexible image handling and resizing
* Extensively unit tested.

h2. Installation

<pre><code>
> script/plugin source http://svn.techno-weenie.net/projects/plugins
> script/plugin install acts_as_attachment
> rake test_plugins PLUGIN=acts_as_attachment
</code></pre>

h2. Simple Usage

Acts as Attachment is designed to be specified on multiple models in your application, rather than having a global Attachment model that other models depend on.  For the purposes of this example, we're going to allow DVD Collectors to upload covers of their collection.

*Note:* This is all using Rails v1.1.4.  YMMV(Your Mileage May Vary) on older or newer versions.

<pre><code>
> script/generate attachment_model dvd_cover
</code></pre>

That command will generate the model stubs as well as an attachment migration to start.  Here's the database migration we're going to use:

<pre><code>
    create_table :dvd_covers do |t|
      t.column "dvd_id", :integer
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string
      t.column "width", :integer  
      t.column "height", :integer
    end
</code></pre>

The columns content_type, filename, size, parent_id, and thumbnail are all vital for Acts as Attachment.  Width and height are optional and used for images only.  Here's what the initial model will look like:

<pre><code>
class DvdCover < ActiveRecord::Base
  belongs_to :dvd
  acts_as_attachment :storage => :file_system
  validates_as_attachment
end
</code></pre>

The validates method will set up the essential validations: the file size is within your limits, the content type matches what you want, and that the filename, size, and content_type fields are present.  The default file size range goes from 1 byte to 1 megabyte.  Since DVD Covers typically won't be that large, let's set some constraints.  We're going to use the :image shortcut to specify any common image type (gif, jpg, png).

<pre><code>
class DvdCover < ActiveRecord::Base
  belongs_to :dvd
  acts_as_attachment :storage => :file_system, :max_size => 300.kilobytes, :content_type => :image
  validates_as_attachment
end
</code></pre>

Setting up a controller and some initial views does not require any special code.  Acts as Attachment creates an uploaded_data= setter that does all the processing for you.  Here's everything you should need:

<pre><code>
## app/controllers/dvd_covers_controller.rb
class DvdCoversController < ApplicationController
  def index
    @dvd_covers = DvdCover.find(:all)
  end

  def new
    @dvd_cover = DvdCover.new
  end

  def show
    @dvd_cover = DvdCover.find params[:id]
  end

  def create
    @dvd_cover = DvdCover.create! params[:dvd_cover]
    redirect_to :action => 'show', :id => @dvd_cover
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
end

## app/views/dvd_covers/index.rhtml
<h1>DVD Covers</h1>

<ul>
<% @dvd_covers.each do |dvd_cover| -%>
  <li><%= link_to dvd_cover.filename, :action => 'show', :id => dvd_cover %></li>
<% end -%>
</ul>

<p><%= link_to 'New', :action => 'new' %></p>

## app/views/dvd_covers/new.rhtml
<h1>New DVD Cover</h1>

<% form_for :dvd_cover, :url => { :action => 'create' }, :html => { :multipart => true } do |f| -%>
  <p><%= f.file_field :uploaded_data %></p>
  <p><%= submit_tag :Create %></p>
<% end -%>

## app/views/dvd_covers/show.rhtml
<p><%= @dvd_cover.filename %></p>
<%= image_tag @dvd_cover.public_filename, :size => @dvd_cover.image_size %>
</pre></code>
