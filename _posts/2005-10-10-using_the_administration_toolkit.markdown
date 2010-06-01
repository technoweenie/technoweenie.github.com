--- 
layout: post
title: Using the administration toolkit
---
*Update:* I've updated some of the directions to use edge rails and plugins.

Here's a rapid-fire tutorial because some folks have been curious with the administration toolkit.  This is assuming you're running on Rails edge with the new plugin support.  After creating the app directory, be sure to add vendor/rails of course:

<pre><code>ruby path/to/edgerails/railties/bin/rails my_app
rake freeze_edge
./script/plugin install http://svn.digett.com/svn/projects/administration</code></pre>

Set up your database.yml:

<pre><code>development:
  adapter: sqlite
  dbfile: db/dev.db</code></pre>

Create a model and a controller:
<pre><code>
class Post < ActiveRecord::Base
end

class PostsController < ApplicationController
  admin_for :post do |admin|
    admin.list_view do |list|
      list.column :title
      list.column :content
      list.search :title
    end

    admin.form_view do |form|
      form.field :title
      form.field :content, :text_area
    end

    admin.confirm_delete_with :title
  end
end</code></pre>

Now, let's create your database:

<pre><code>ActiveRecord::Base.connection.create_table :posts do |t|
  t.column :title, :string
  t.column :content, :string
  t.column :created_at, :datetime
end</code></pre>

Now, start your app and go to http://localhost:3000/posts.  See anything?
