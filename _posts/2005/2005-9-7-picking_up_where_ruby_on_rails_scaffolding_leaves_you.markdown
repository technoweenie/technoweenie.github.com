--- 
layout: post
title: picking up where ruby on rails' scaffolding leaves you
---
You get the notion that scaffolding is temporary drilled into your head from your first day of Rails.  What if it didn't have to be?  Obviously, your next gen web 2.0 app may need a custom form, but perhaps other apps can benefit greatly from _scaffolding on steroids_.

<pre><code>
class Admin::UsersController < ApplicationController
  layout 'administration'

  admin_for :user do |admin|
    admin.set_list_view do |list|
      list.add_column :login
      list.add_column :email, :classes => :email
      list.add_column :logged_in_at, 'Last Login' do |value| 
        value.to_formatted_s(:db) # custom value output
      end
      list.add_column :active?, 'Active'

      list.search_by :login
      list.search_by :email
      list.search_by :login, :email, :operation => :or
    end

    admin.set_form_view do |form|
      form.add_field :login
      form.add_field :email
      form.add_field :password, :password_field
      form.add_field :password_confirmation, :password_field
      form.add_field :active, :check_box
    end

    admin.confirm_delete_with :email
  end
end
</code></pre>

Yes, this is real code, and it works.  This is just the beginning.
