--- 
layout: post
title: Background Jobs Reloaded
---
So, [Tender](http://tenderapp.com/) has been rolling for weeks with the new [job structure](http://techno-weenie.net/2009/11/4/structuring-your-background-jobs): how's it working out?

First, I created multiple job classes for functions in events that are related.  I used `Job::CommentNotifications` as my example in my last post.  It's now split up into four jobs in total: `CheckSpam`, `CommentNotifications`, `CommentIndexing`, and `RunHooks` (perhaps my next post should be on how to name these stupid things?).

After that, I started spawning more queue runners.  I had one set specifically for slower jobs like indexing.  The other queues handled the really critical jobs quickly and staye empty, yet this slower queue usually had a lot of indexing jobs queued up.  My new system was working out well -- important jobs were going through despite the indexing slowing down.  How slow?  Sometimes the Sphinx delta indexes would take up to 10 seconds to process. Yikes!

Finally, I decided that maybe I don't need my sphinx server to basically be constantly updating the delta indexes 24/7.  So, I started rate limiting the delta indexing itself:

<script src="http://gist.github.com/248936.js?file=gistfile1.rb"></script>

I haven't upgraded [Thinking Sphinx](http://freelancing-god.github.com/ts/en/) since Pat took a month off to put a lot of work into it, so the actual code may not work on the latest version anymore.  

Sphinx, and the Thinking Sphinx plugin, work great in every regard for us -- except for this indexing issue.  Here's how it works.  You setup a large denormalized query that sphinx uses to fetch your data.  In the case of the Faq record (shown in the gist above), it looks something like this:

    SELECT `faqs`.`id` * 3 + 1 AS `id` , 
      CAST(`faqs`.`title` AS CHAR) AS `title`, 
      CAST(`faqs`.`body` AS CHAR) AS `body`, 
      ...
      0 AS `sphinx_deleted` 
    FROM faqs
    WHERE `faqs`.`id` >= $start   AND `faqs`.`id` <= $end
    GROUP BY `faqs`.`id` ORDER BY NULL

Sphinx figures out the [range of IDs](http://www.sphinxsearch.com/docs/current.html#ranged-queries) in your table, and starts churning through the rows in pages:

    SELECT IFNULL(MIN(`id`), 1), IFNULL(MAX(`id`), 1) FROM `faqs`
    SELECT .... FROM faqs WHERE faqs.id >= 1 and faqs.id <= 5000
    SELECT .... FROM faqs WHERE faqs.id >= 5001 and faqs.id <= 10000

This keeps sphinx from imposing a read lock over your table while it scans and indexes every row.  This is all fine for an initial scan, but I have documents being updated every second.  This is where delta indexes come in.  

The simplest form of a sphinx delta index uses a boolean flag to determine if a record has been updated.  To ensure your content is not indexed twice, ThinkingSphinx actually creates multiple sphinx indexes for our models.

The query above is duplicated for separate core and delta indexes:

    SELECT `faqs`.`id` * 3 + 1 AS `id` , ...
    FROM faqs
    WHERE `faqs`.`id` >= $start   AND `faqs`.`id` <= $end
      AND `faqs`.`delta` = 0
    GROUP BY `faqs`.`id` ORDER BY NULL

    SELECT `faqs`.`id` * 3 + 1 AS `id` , ...
    FROM faqs
    WHERE `faqs`.`id` >= $start   AND `faqs`.`id` <= $end
      AND `faqs`.`delta` = 1
    GROUP BY `faqs`.`id` ORDER BY NULL

Every time a document is updated, it sets the delta flag from `0` to `1`.  Sphinx figures out the range of indexes in the delta index, and rescans them:

    SELECT IFNULL(MIN(`id`), 1), IFNULL(MAX(`id`), 1) FROM `faqs` WHERE `faqs`.`delta` = 1
    SELECT .... FROM faqs WHERE faqs.id >= 1 and faqs.id <= 5000 and `faqs`.`delta` = 1
    SELECT .... FROM faqs WHERE faqs.id >= 5001 and faqs.id <= 10000 and `faqs`.`delta` = 1

Since auto incremented IDs are sequential, and usually only the most recent comments are updated, your query range may only be from 99,023 to 101,023.  As a result, you're only scanning through a few pages of data, instead of the whole table.  However, if someone manages to update an older article, your range may span hundreds of thousands of rows.  Maybe the only discussions in the delta index are 2 and 101,023, but Sphinx still has to page through all 101 thousand rows to find out.

For the time being, sphinx and our job queue are running a lot smoother now.  However, we are feeling the pain of sphinx's inefficient indexing strategy, and I accept that a move to something like [Solr](http://lucene.apache.org/solr/) is in our future.
