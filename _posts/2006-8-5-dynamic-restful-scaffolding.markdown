--- 
layout: post
title: Dynamic Restful Scaffolding
---
It seems this interest in restful rails apps is bringing out a number of restful scaffolding frameworks too.  Once you make a few resource controllers, they all start looking the same.  The main differences usually lie in the model scoping and authentication filters.  It's natural to look at this and try to devise some DRY way to define these actions.  Jeremy is not the first to attempt this, with his experimental "Rapid Resource":http://www.jvoorhis.org/articles/2006/08/04/prototyping-with-rapid-resource-a-proof-of-concept macros.  I took a stab too: "http://pastie.caboo.se/7319":http://pastie.caboo.se/7319.

This approach seemed to work well in my basic tests.  However, it became apparent that I would have to allow for customizations on nearly every line of code.  Take this standard create action and note the areas you may want to configure:

<pre><code>
  def create
    @post = Post.new(params[:post])
    @post.save!
    redirect_to post_path(@post)
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
</code></pre>

* Does Post have a parent model?  Maybe you want @user.posts.build(params[:post]) ?
* Do you want to redirect somewhere else?
* Do you want to Flash notices?
* Do you want to respond to alternate content types such as XML, YAML, Atom?

The dynamic scaffolding code could get pretty complicated with all these customizations.  The application developer now has to remember various new methods to overwrite to customize various aspects of the app.  None of this feels right, especially when the initial controller code is so basic.  Maybe instead of working on this, I'll focus on the app and let these similar controllers evolve naturally.  However, I do have a very basic "resource generator":http://svn.techno-weenie.net/projects/plugins/resource_generator/ that I threw together.
