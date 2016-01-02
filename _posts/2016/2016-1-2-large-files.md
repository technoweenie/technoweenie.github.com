---
layout: post
title: The Journey for Large Files on GitHub
---

<div class="img">
  <img src="/images/2016/ironthrone.jpg" width="398" height="398"
    alt="Picture of me on the Iron Throne at GDC 2012" />
</div>

I am a big fan of video games, so I jumped at the chance to work the GitHub
booth at the Game Developer's Conference (GDC) in 2012. It was my first time
representing the company for a community that I'm an outsider of. I planned on
spending my time explaining the merits of social coding, while sneaking out
during breaks to check out some sessions about video game development.

However, the second most frequent question I was asked was, "how can I work with
large files?". This got me wondering: is there something that I can do to get
these developers using GitHub?

As a programmer that builds web applications, it's all too easy to take Git for
granted. A Git repository tracks every change of every file for the life time
of a project. I can go to any line of code and track down who, when and why
the specific change was made. I can link it to a pull request, which contains
the proposal, review, and tweaks around change to the application.

However, not all developers are able to use Git because of technical and
workflow limitations. Some projects work with large binary files, such as audio,
3D models, high res graphics, etc. Yet, doing this on GitHub was a pretty
terrible user experience. If you attempt to upload a file over 100MB, you get
blocked with this error message:

    remote: warning: Large files detected.  
    remote: error: File big-file is 123.00 MB; this exceeds GitHub's file size limit of 100 MB

This means that you'll have to run some gnarly terminal commands to fix something
before being able to sync your work. While there are legit technical reasons for
this, it doesn't take away from the fact that GitHub was getting in the way of
their work.

Over the next three years, my team participated in a larger effort to research
and build the Git Large File Storage (Git LFS) tool to solve this problem.

![](/images/2016/schacon-stark.png)

It turns out that GitHub's own "Iron Man", Scott Chacon, had already
experimented with this in a project called [Git Media](https://github.com/alebedev/git-media). It uses internal hooks
inside Git to intercept access to large files, storing them in various cloud
storage services (like S3), instead of the Git repository. It's an interesting
prototype, but the game dev community was not using it. Surely we could easily
release this as an official GitHub product. I told a colleague at GDC that we'd
be back next year with something. Ha!

I pitched this idea at an internal mini summit for the GitHub Product team in
late 2012, hoping to convince others to join me in building this. Unfortunately,
there were too many important projects to tackle. I needed another way to
convince the company that we should be pursuing this.

Around the same time, GitHub hired its first User Experience Researcher: Chrissie
Brodigan. She gave a talk about what she does, and how she's going to _turn all
of us into UX researchers_. This sounded insane to me. I get all the
feedback I need from emails and Twitter! So, I emailed this crazy woman to see
if she could help with a new feature we were about to launch.

Interviews turned to actionable feedback, which resulted in some important adjustments to the feature before its launch. With the success of this small
research project behind us, we turned towards a more ambitious question: how can
we enable developers to work with large files on GitHub?

We interviewed a diverse set of candidates (according to industry, use case, and
location) about their large file use. A common set of themes emerged, and were
published to the rest of the company in OctoStudy 8. These interviews informed
a list of suggestions and aspirations, which directly influenced the design of
what would eventually become Git LFS.

Being involved in these two UXR reports turned out to be the best experience
I've had at GitHub. I'm thrilled to see Chrissie's growing team move on to more
challenging and important studies for the company. Read more about that in her
post, [New Year, New User Journeys](https://medium.com/@tenaciouscb/new-year-new-user-journeys-c07880f147f2).

![](/images/2016/smasher-1.png)

This UXR report was enough to get approval for the project. Scott Barron joined
me on the new Storage Team in late 2013. Finally, it was time to get to work!

In addition to slinging code, we had to coordinate with other internal teams at
GitHub. This was a unique product launch that touched so many parts of the
company. We setup a weekly video chat to keep interested parties in the loop.
The attendees of each meeting varied wildly, as a team's involvement would begin
and end.

* The Billing Team, in the midst of their own large refactoring, implemented
the crucial bits to our payment system that we needed.
* The Creative Team produced awesome graphics and videos to help promote the
project.
* The Communications Team produced [this amazing ad for LFS](https://www.youtube.com/watch?v=_11d1ZsEZ8g).
* The Docs Team keep the Git LFS documentation updated on help.github.com.
* The Legal and Outreach teams helped nail down the open source licensing, code
of conduct, and [CLA tracker](https://cla.github.com/).
* The Marketing Team found a suitable place to launch, and helped with the
[external website](https://git-lfs.github.com/) and messaging.
* The Native Team defined what Git LFS needs to integrate with GitHub Desktop
and other similar Git tools.
* The Security and Infrastructure teams reviewed the architecture of the backend
systems, making sure we're doing things responsibly.
* The Support Team reviewed the product, looking for common support scenarios
that we would have to handle.
* The Training Team was another valuable source of user feedback, and produced
a [great video](https://www.youtube.com/watch?v=uLR1RNqJ1Mw) and presentation about Git LFS.

I also met Saeed Noursalehi, a PM for Visual Studio Online at Microsoft, through
both our companies' involvement in the [libgit2](https://libgit2.github.com/)
project. They too were concerned with the same large file problem, and provided
extremely valuable feedback on our early ideas and API based on their own
observations.

![](/images/2016/smasher-2.png)

We announced the Git LFS open source project at the Git Merge conference in
April 2015. Pitching a tool that challenges Git's decentralized model to a room
full of Git enthusiasts and experts was intimidating. Overall, it went pretty
well. o one threw tomatoes or called me names.

Coincidentally, John Garcia from Atlassian announced Git LOB, _their_ solution
for large files in Git, immediately after my presentation. The core ideas behind
the projects were very similar, but their version wasn't yet ready for public
consumption.

Like most launches though, this was just the beginning. While the client was
released, we were keeping the actual server component behind an Early Access
program. Our UXR team used this to collect valuable feedback from a controlled
group of beta users.

For six months, we refined specs, pushed bug fixes, and even redesigned the
server API. Most importantly, the newly open sourced project saw outside
contributors for the first time.

Steve Streeting, lead developer of Git LOB at Atlassian, reached out to us soon
after Git LFS launched. We both agreed it made sense to put our weight behind a
single solution, instead of competing head to head, fragmenting the community,
and duplicating even more work. What really impressed me was his willingness to
jump in, on a competitor's site especially, and make major improvements to Git
LFS.

The project also saw contributions from Andy Neff and Stephen Gelm, who focused
on packaging Git LFS for Linux. They started with scripts to build packages for
their respective distros, which evolved into internal tools for building and
testing Linux packages for release on my Macbook Pro.

Then in October 2015, I shared a stage with Saeed and Steve at GitHub Universe to
announce Git LFS v1.0, and its availability on GitHub.com. By the end of the
year, Git LFS was supported by two other Git hosts, with support announced
for a fourth soon.

![](/images/2016/smasher-3.png)

Git LFS has launched, its Epstein drives are running. This year we will be using
thrusters to adjust the project's trajectory, making constant small tweaks.
Fixing bugs and edge cases as they are discovered. Writing good
documentation to help new users transition or start new projects with LFS.
Documenting or automating the processes that run the project.

Most of all, I'm just excited about doing this in the **open**. I look forward
to helping new and experienced people contribute to the project. Find us at the
[Git LFS repository](https://github.com/github/git-lfs) or our [chat
room](https://gitter.im/github/git-lfs). If you're interested in working on LFS
or similar features with us at GitHub, [let me know](mailto:rick@github.com)!

![Izzy Kane, first human worthy of the Shiar Imperial Guard, boots up for the first time](/images/2016/smasher-4.png)

<small>(images taken from Avengers Vol. 5, #1 and #5 by Marvel Comics)</small>
