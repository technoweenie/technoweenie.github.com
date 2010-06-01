--- 
layout: post
title: splintered rss
---
bq. When people say more formats, or varying practices don't cost, they are either naive or acting in their own interest, not ours. -- "Dave":http://archive.scripting.com/2004/04/27#aCautionaryTale

Personally, I don't see RSS and Atom as the same formats.  Sure, their uses may overlap.  But, there's one fundamental difference I see.  RSS is a simplified format to get titles/descriptions/permalinks.  Atom is a rich format for full web content.  

RSS is something you'd use to syndicate "blog excerpts":http://bloglines.com/, "bit torrent links":http://banjax.typepad.com/random/2003/11/bittorrent_rss_.html, "cvs changelogs":http://laughingmeme.org/cvs2rss/, and "event log feeds":http://www.rassoc.com/gregr/weblog/archive.aspx?post=570.  I love RSS for its simplicity.  Trying to read richly encoded content can be a pain due to "spec incompatibilities":http://diveintomark.org/archives/2004/02/04/incompatible-rss, "encoding errors from buggy software":http://www.intertwingly.net/blog/1772.html, etc.

bq. "AtomEnabled":http://www.atomenabled.org/developers/ finally makes it possible for developers to have a consistent, tightly-specified, well documented XML format for both syndication and authoring of content.

Atom is not a 1.0 release yet, so this promise hasn't been delivered yet.  But, it has a detailed "spec":http://www.atomenabled.org/developers/syndication/atom-format-spec.php and "validator":http://www.atomenabled.org/developers/syndication/validator.php, "extensive conformance tests":http://diveintomark.org/tests/client/, and some interesting "apps":http://www.xml.com/pub/a/2004/04/14/atomwiki.html.

RSS is something I'd use to provide the latest news tidbits, and Atom is something I'd use to export my rich weblog data for importing into another system.
