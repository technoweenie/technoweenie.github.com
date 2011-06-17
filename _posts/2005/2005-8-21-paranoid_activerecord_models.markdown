--- 
layout: post
title: paranoid ActiveRecord models
---
If you're paranoid about your data, you probably like to implement a simple @deleted@ bit or @deleted_at@ timestamp in your tables instead of deleting the row.  It's very easy to do with Rails and ActiveRecord, but now all your code changes.  @model.destroy becomes @model.update_attribute(:deleted_at, Time.now).  @model.find(1) becomes @model.find(:first, :conditions => ['id = ? and deleted is null', my_model_id]).  And so on.  

Instead, skip all that mess and do this in lib/rails_ext/active_record.rb (you can put it wherever you like, codeslinger):

"(code snipped and placed on Snippets)":http://www.bigbold.com/snippets/posts/show/590

Don't forget to require this file in environment.rb: @require 'rails_ext/active_record'@.  This uses the new @ActiveRecord::Base#constrain@ method that adds conditions to queries.  The original @#find@, @#count@, and @#destroy@ methods are aliased and constrained.  This has one major side effect that I see: constrains overwrite each other if they're stacked, so you'll have to use the original methods if you do your own constraining.  I had to do a little code hackery in @#find@ for @has_and_belongs_to_many@ queries to work probably.

I showed this to "courtenay":http://habtm.com and he said:

<pre>
court3nay: between your paranoid table handling
court3nay: and whiny nil
court3nay: rails is becoming like my exgirlfriends
</pre>
