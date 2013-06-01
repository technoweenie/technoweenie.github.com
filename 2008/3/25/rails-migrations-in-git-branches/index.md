--- 
layout: post
title: Rails Migrations in Git Branches
---
For those of you that don't -stalk- follow my other streams: 

h4. "Migration Buddy":http://github.com/technoweenie/rails_migration_buddy/tree/master

Or, "the inevitable renumbering and conflict-resolution of miggy tardust"

This is a tool to help merge rails branches with conflicting migrations.  The basic
idea goes like this:

* First you migrate down to the migration you were at when you branched.
* Renumber any new migrations you created that conflict with any new migrations in
  the target branch.
* Commit the renames.
* Merge to the target branch (usually 'master').
* Migrate back up.

Wow, what a pain, right?  (Apologies to "Saul Williams":http://niggytardust.com/, "you rock":http://flickr.com/photos/technoweenie/2358883164/).

I keep threatening, but I may have to replace this blog with a combination "twitter":http://twitter.com/technoweenie / "tumblr":http://technoweenie.tumblr.com / "github":http://github.com/technoweenie stream. 
