--- 
layout: post
title: Performing tasks on reload
---
Every once in awhile, you run across a situation where it would be nice to run some commands everytime rails reloads in the development environment.  One possible situation is if you want to dynamically add a specific route (however, this can get messy if you're not careful).  I needed this particular feature for Mephisto after observing some weird behavior with the Liquid plugin.  The problem is that Liquid requires me to register classes for the Liquid tags.  This means that the class will be reloaded, but the _original_ class is still being used by Liquid.  

<pre><code>
require 'dispatcher'
class << Dispatcher
  def reset_application_with_plugins!
    returning reset_application_without_plugins! do
      register_liquid_tags
    end
  end

  alias_method_chain :reset_application!, :plugins
end
</code></pre>

(for the full source, check out "pastie":http://pastie.caboo.se/6062)

It's a fairly standard monkey patch involving alias_method_chain.  Even so, this didn't work as expected either.  The issue is that Rails never actually require's Dispatcher, and so it gets loaded multiple times.  Specifically requiring it solves that issue.
