--- 
layout: post
title: Dialog
---
<style type="text/css">
  #dialog {
    background-color: #001;
    opacity: 0.10;
    filter:alpha(opacity=10);
  }

  #dialog_box {
    width:500px;
    padding:30px;
    background-color:#fff;
    border-style:solid;
    border-color:#000;
    border-width:5px;
  }

  #dialog_box p.buttons a {
    padding:0 15px;
  }
</style>
<script type="text/javascript" src="/javascripts/prototype.js"></script>
<script type="text/javascript" src="/javascripts/effects.js"></script>
<script type="text/javascript" src="/javascripts/dialog.js"></script>

Dialog is a simple script for displaying styled dialog windows in browsers.  It builds on the excellent "Prototype":http://prototype.conio.net and "Scriptaculous":http://script.aculo.us/ libraries.  The look and feel is CSS driven, and it's easy to create your own custom dialogs.  Be sure to include dialog.js and add the appropriate styles.

h3. "Project Page":http://weblog.techno-weenie.net/projects/dialog

h3. "Javascript Subversion Location":http://techno-weenie.net/svn/projects/javascripts/dialog

<code>svn co http://techno-weenie.net/svn/projects/javascripts/dialog</code>

h3. "Rails Helper Plugin":http://techno-weenie.net/svn/projects/plugins/dialog_helper

<code>script/plugin install dialog_helper</code>

<p><a href="#" onclick="new Dialog.Confirm({message: 'Here\'s the Dialog Confirm box.', onOkay: function() { alert('Okay!'); Dialog.current.close(); }}); return false;">Click to see a Dialog!</a></p>
