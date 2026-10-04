---
name: workload-analysis
description: "Procedure for finding the most expensive queries in a database workload from the engine's own statistics (slow query log, pg_stat_statements, performance_schema, Query Store), reading their plans, and ranking causes and fixes by measured impact. Read-only by default. Followed by the database-optimizer agent; in a main session, delegate workload analysis to that agent."
argument-hint: "<database, symptom or time window to analyze>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Analyze the database workload: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
database-optimizer subagent, state the assumption and return the question. Read-only on a named
non-production database; if no database is reachable, analyze the query code and schema in the
repo and mark every conclusion unverified.

## Steps

1. Establish the engine, version, data volume per important table (row counts, from the
   statistics or `COUNT(*)` on small tables only), the symptom, and when it happens.
2. Get the workload from the engine's own statistics. Check that the feature is enabled before
   relying on it, and say when it is not:
   - PostgreSQL: the `pg_stat_statements` extension (total time, mean time, calls, rows);
     `pg_stat_activity` for what runs now
   - MySQL: `performance_schema.events_statements_summary_by_digest` or the `sys` schema
     statement summaries, and the slow query log if enabled
   - SQL Server: Query Store, or the `sys.dm_exec_query_stats` views
   - Oracle: AWR or ASH reports (these need a licensed option; check before using) or
     `V$SQL`
   Rank statements by total time first (frequent cheap queries often cost more than one slow
   one), then by mean time and by rows examined versus rows returned.
3. For each of the top offenders, get the plan with `EXPLAIN` (execution of the statement only
   if authorized and safe; see the agent's rules). Read it for: full scans where an index
   lookup is expected, large gaps between estimated and actual rows, sorts or hashes spilling
   to disk, joins on unindexed columns, and functions or casts on indexed columns.
4. Find the pattern in the application code that issues each query (search the repo for the
   statement text or the ORM call): an N+1 loop, a missing `LIMIT`, `SELECT *`, filtering in
   application memory, `OFFSET` pagination on deep pages, or the same query repeated within a
   request.
5. Classify each fix: rewrite the query, change application code, add or change an index (use
   the `index-strategy` skill), refresh statistics, or a structural change (partitioning,
   summary table, caching) presented as a proposal with trade-offs. Prefer the cheapest change
   that moves the measured numbers.
6. Compare against the project's stated targets (for example table sizes, user counts). A query
   that is slow only at a scale the project will never reach is low priority; say so.
7. Report a ranked table: statement (normalized, no parameter values with personal data),
   calls, total and mean time, rows examined versus returned, the cause, the proposed fix, and
   the evidence source. State the time window the statistics cover and what could not be
   measured.
