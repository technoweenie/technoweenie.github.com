--- 
layout: post
title: Sql Server Views
---
I've been thinking a lot about SQL Views lately.  I have a home project I'm working on with a fair amount of stored procedures.  However, they were just simple SELECT statements, so I wanted to see how Views would fare.  

Then, I got to thinking about the performance of SQL Views.  From my findings, it seems that using Views are really no faster/slower than using the same SQL.  Here was my test:

# Complex SQL Query
# Complex SQL Query w/ ORDER BY
# Complex Query as a View
# Complex Query as an Ordered View [1]
# View with ORDER BY statements
# Ordered View with ORDER BY statements (plux extra ORDER BY not in View)
# View with All ORDER BY statements

fn1. By Ordered View, I mean the same query as the View, but with a SELECT TOP 100 PERCENT and an ORDER BY statement

After running those sevenqueries, I looked at the Execution plan and found that queries 1 and 3 took the same amount of time, and the other 3 did as well:

# 13.58%
# 14.41%
# 13.58%
# 14.41%
# 14.41%
# 15.22%
# 14.40%

This tells me that Views are just as fast as straight queries, and it doesn't really matter where you put the ORDER BY statements when ordering it.  

The last two queries showed me something, however.  In query #6 (the Ordered View with an extra ORDER BY statement), the execution plan shows 2 sort operations.  So, the Ordered View sorts with the original ORDER BY statements, and then the query sorts the view results with the extra ORDER BY statement.

The final query (The View with all ORDER BY statements) performs the sort operation in one shot, returning the results a tad quicker.  Something to think about when designing Views.

I realize this isn't exactly thorough or scientific proof.  If anyone can drop some SQL Server knowledge and insight my way, I wouldn't mind at all.
