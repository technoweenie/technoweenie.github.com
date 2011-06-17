--- 
layout: post
title: simply_bdd update
---
I've made a nice little update to my "simply_bdd plugin":http://weblog.techno-weenie.net/2006/8/29/busy-railers-guide-to-bdd:

You can specify a superclass for context so the class inherits from it instead:

<macro:code lang="ruby">context "Post Controller Creation", PostControllerTest do
  ...
end</macro:code>

You can also nest context calls to get automatic inheritance:

<macro:code lang="ruby">context "Post Controller" do
  context "Post Controller Creation" do
    ...
  end
end</macro:code>
