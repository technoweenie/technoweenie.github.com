--- 
layout: post
title: darcs - decentralized source control
---
I got a chance to try out "darcs":http://abridgegame.org/darcs/, a radically different source control tool from subversion.  It's heavily geared towards distributed software projects.  It relies on no central server.  In fact, everyone acts as a repository.  Somehow, they email patches around to keep the source code up to date.  I'm thinking there's a missing piece that I need before I have that big *BING!* moment, but I really like it so far.

I wanted to contribute some javascript functions to "Prototype":http://prototype.conio.net/, the javascript library included with Rails.  So, I got the latest from Prototype's darcs repository, made my changes, and emailed them to Sam (darcs has a command to send patches via email).  

Later, "Thomas Fuchs":http://mir.aculo.us/ sent me a patch he was working on.  After we sorted out some line-endings problem (gmail or _something_ was mangling the patch, so he sent it gzipped), I applied the patch and resolved the conflicts.  This distributed patch idea is very interesting indeed.  I wouldn't mind the chance to use darcs more in the future.

I may be spoiled with TortoiseSVN, but I think darcs could really use a basic GUI.
