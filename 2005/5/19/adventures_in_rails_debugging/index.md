--- 
layout: post
title: Adventures in Rails Debugging
---
I had the greatest rails debugging session ever, tonight.  And by greatest I mean *incredibly frustrating*.  

I have a controller that updates an amount value for an Item model.  In the unit tests, everything works great.  In a rendered partial, however, it was showing an old value.  First, let's take a look at the controller code:

<pre><code>
logger.info ">> BEFORE! @item.amount=#{@item.amount}"
@item.add_bid @session[:user], @params[:bid_amount]
logger.info ">> AFTER! @item.amount=#{@item.amount}"
render_partial('info', @item) if @request.xhr?
logger.info ">> AFTER PARTIAL! @item.amount=#{@item.amount}"
redirect_to :action => :show
</code></pre>

Notice the extensive use of logging...  Now's the view:

<pre><code>
<% RAILS_DEFAULT_LOGGER.info ">> INSIDE VIEW! info.amount=#{info.amount}" %>
<strong><%=info.amount.format%></strong>
</code></pre>

Straight forward, right?  Well, it turns out it puts the value of @item.amount before the bid is added!  Here's the log output:

<pre><code>
>> BEFORE! @item.amount=$85.00 USD
  SQL (0.000310)   BEGIN
SQL STUFF
  SQL (0.000271)   COMMIT
>> AFTER! @item.amount=$100.00 USD
>> INSIDE VIEW! @item.amount=$100.00 USD
>> AFTER PARTIAL! @item.amount=$100.00 USD
</code></pre>

Notice that the value is updated after the item is saved, before the partial, _inside_ the partial, and after it.  So why was it printing the old value?  Well, "Scott Barron":http://scott.elitists.net/ gave the first hint to the solution:  Multiple render calls are ignored.  I restructured the code so that the render methods are only called once whether it's an Ajax request or a normal POST.  Still no dice.

Then, I put a breakpoint inside the view, and noticed it was getting called twice!  The first time was before the update, which is why the old value was showing.  I took another look at the controller, and noticed I was calling the _show_ action also.  The show action just loads an item using <code>@params[:id]</code>, so I was using it in multiple actions, rather than repeating that bit of code.  Well, I just recently added another line that renders that same exact partial for ajax requests.

*That* is why the rendered data was showing old data.  By using a call to another action, I was duplicating the call to the partial, and Rails was probably caching it somewhere.  
