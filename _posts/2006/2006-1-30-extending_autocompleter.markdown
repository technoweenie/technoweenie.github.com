--- 
layout: post
title: Extending AutoCompleter
---
Here's a quick tip:  I've been using the Autocompleter control pretty heavily.  I had to hook into the onkeypress event, but I didn't feel like duplicating a lot of code.  Here's a simple way to extend the Scriptaculous classes:

<pre><code>
Autocompleter.Custom = Class.create();
Autocompleter.Custom.prototype = Object.extend(new Autocompleter.Base(), {
  initialize: function(element, update, array, options) {
    this.baseInitialize(element, update, options);
    this.options.array = array;
  },

  getUpdatedChoices: function() {
    this.beforeGetUpdatedChoices();
    // called when the Autocompleter's text field observer fires
  },

 onKeyPress: function(event) {
    this.beforeOnKeyPress(event);
    // called on each key press in the text field
  },

  beforeGetUpdatedChoices: Autocompleter.Local.prototype.getUpdatedChoices,
  beforeOnKeyPress:        Autocompleter.Base.prototype.onKeyPress
});
</code></pre>
