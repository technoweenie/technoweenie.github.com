--- 
layout: post
title: XP SP2 Firewall problems
---
I loaded the Public Beta of XP SP2 and had a few problems.  First, the Security Center kept complaining that I have no AV(Antivirus) software.  So, I disabled the Security Center service.

Secondly, the Windows Firewall kept working, but would not let me configure it.  I would get this error message:

bq. Due to an unidentified problem, Windows cannot display Windows Firewall settings.

I found a message on the "Microsoft Newsgroups":http://communities.microsoft.com/newsgroups/default.asp?icp=xpsp2&slcid=us that solved my problem.  Just run these commands:

regsvr32 %windir%\system32\atl.dll
regsvr32 %windir%\system32\hnetcfg.dll

So far, I've enjoyed the new firewall.  There has even been an instance where a program should not have been trying to access the internet, but it was.  

*Update:*  My bit torrent performance is up, now that I can configure the firewall properly.   Cool.
