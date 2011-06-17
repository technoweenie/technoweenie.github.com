--- 
layout: post
title: Structuring your background jobs
---
This morning while dealing with a support issue, I asked [this question](http://twitter.com/technoweenie/status/5395413752) on the twitters: 

> Do you create a single (background) job for an event (AfterPostUpdated), or multiple jobs for tasks (SendPostEmails, UpdatePostCounts)?

In [Tender Support](http://tenderapp.com), updating a discussion spawned a job that looked something like this:

<pre><code>
class Job::CommentNotifications < Job::Base.new(:comment_id)
  def comment
    @comment ||= Comment.find comment_id
  end

  def perform
    comment.notified_users.each do |user|
      UserMailer.deliver_notification(user, comment)
    end
  end
end
</code></pre>

(In case [Evan](http://twitter.com/evanphx) asks, I am referring to a secret military Base for Tender jobs.  Don't judge me!)

As functionality has grown in Tender, the job looks more like this now:

<pre><code>
class Job::CommentNotifications < Job::Base.new(:comment_id)
  def perform
    # update sphinx with comment contents
    # add comment author as a watcher to the discussion
    # send autoreply for first comment of a discussion
    # send notifications to all discussion watchers
  end
end
</code></pre>

Wow, writing all that out really makes me realize how ridiculous things have gotten.  This job definitely turned in a post-create callback for valid comments (the spam check is another job).  These are all things that need to happen in no specific order.  

Why didn't I create individual jobs for these tasks out the gate?  Part of the reason for my aggressive queueing in Tender is to keep the frontend requests as fast as possible.  I didn't want to have to worry about creating 3 extra Delayed::Job rows for tasks that all run at the same time.

One thing I'm running into is the fact that sphinx indexing is relatively slow, holding up things like comment notification. I'm also planning an upgrade to the Tender infrastructure, so there's a chance that something like sphinx indexing or asset processing would have to happen on certain instances.

Here were the results of the poll:

## For Single Job Classes

[@capitalist](http://twitter.com/capitalist/status/5395440248) Single Job for an event, so you can replay the failed ones.  
[@shojberg](http://twitter.com/shojberg/status/5395479863) AfterPostUpdated imo, less jobs to maintain :)

## For Multiple Job Classes

[@laserlemon](http://twitter.com/laserlemon/status/5395480275) Multiple jobs. Better for assigning priority  
[@lifo](http://twitter.com/lifo/status/5395490176) Multiple jobs. I think it's a bad idea to have jobs like AfterPostUpdated. Post could change again by the time job gets run.  
[@spiceee](http://twitter.com/spiceee/status/5395576017) multiple jobs.  
[@marcjeanson](http://twitter.com/marcjeanson/status/5395601055) multiples  
[@fowlduck](http://twitter.com/fowlduck/status/5395618745) if they're not order-dependent i'm for multiple ones  
[@fowlduck](http://twitter.com/fowlduck/status/5395632405) if it fails in the middle and it's rerun then the part that didn't fail is rerun as well  
[@mguterl](http://twitter.com/mguterl/status/5396284030) multiple jobs for tasks and sometimes we just use #send_later.  
[@trevorturk](http://twitter.com/trevorturk/status/5398187926) most of my DJs are like @lifo's, but I figure I should be using handle_asynchronously where possible  
[@ATimberlake](http://twitter.com/ATimberlake/status/5399345761) separate jobs are more resiliant against duplications when jobs are re-run after errors

Both @fowlduck and @ATimberlake brought up great points: job errors errors trigger the whole job to be re-run.  There is some wasted work, but this is especially painful if you're sending duplicate emails every few minutes as the job tries to complete.  Notice how I kept that task at the bottom :)

## The Verdict

I'm going to have to say that multiple job classes are the way to go.  It's definitely not crucial for day one, but it is something you should keep in mind for when you start to run into similar issues.

Maybe something is in the air, but @defunkt posted a blog talking about [Resque, their redis-backed queue](http://github.com/blog/542-introducing-resque).  The non-redis stuff sounds great (workers, web UI, named queues).  Redis is just icing on the cake.

![@technoweenie: apparently when i drink with @imagetic i start babbling on and on about how bad ass redis is](http://twictur.es/i/5387913320.gif)

Thanks for the fun twitter discussion, everyone!  Any more thoughts?  Comment below or @reply on twitter.
