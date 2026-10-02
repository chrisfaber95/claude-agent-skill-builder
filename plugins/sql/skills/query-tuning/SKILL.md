---
name: query-tuning
description: "Procedure for tuning a slow SQL query from evidence: get the engine and plan, find the real bottleneck, change the query or indexes, and verify with a before/after plan and identical results. Followed by the sql-pro agent; in a main session, delegate SQL tuning to that agent."
argument-hint: "<query, file, or description of the slow operation>"
allowed-tools: [Bash, Read, Grep, Glob, Edit]
---

Tune this query: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the sql-pro
subagent, state the assumption and return the question. Follow the sql-pro safety rules:
read-only by default, `EXPLAIN ANALYZE` only on SELECTs (or rolled-back transactions) and only
when execution is authorized.

## Steps

1. Establish the facts: engine and version, the exact query with realistic parameters, the
   schema of every table involved, existing indexes, approximate row counts, and what "slow"
   means (observed time, or an SLA). If a figure is missing, say so rather than guessing it.
2. Get a baseline plan without changing anything:
   - PostgreSQL: `EXPLAIN (ANALYZE, BUFFERS)` (or plain `EXPLAIN` if execution is not authorized)
   - MySQL 8: `EXPLAIN ANALYZE` (or `EXPLAIN FORMAT=TREE`)
   - SQL Server: the actual execution plan, or `SET STATISTICS IO, TIME ON`
   - Oracle: `EXPLAIN PLAN FOR …` then `DBMS_XPLAN.DISPLAY`
   Record the timing and the plan shape. If no database is reachable, work from the schema and
   mark every conclusion "unverified".
3. Find the actual bottleneck. Read the plan for:
   - large scans where an index lookup is expected, and big gaps between estimated and actual
     rows (stale statistics or correlated columns)
   - sorts or hashes spilling to disk, or a nested loop over a large outer side
   - repeated work (the same subquery or function per row), or an N+1 pattern from the caller
   Then check the query text for known causes: a function or cast on an indexed column in
   `WHERE`, mismatched types forcing an implicit cast, `OR` across columns, leading-wildcard
   `LIKE`, `SELECT *` defeating a covering index, deep `OFFSET`, `NOT IN` with a nullable
   subquery, `DISTINCT` hiding a join fan-out, and missing join conditions.
4. Fix in this order, one change at a time:
   1. Rewrite the query (sargable predicates, `EXISTS`, fewer columns, keyset pagination,
      pre-aggregate before joining).
   2. Add or adjust an index. Put equality columns first, then range or sort columns; consider
      a partial/filtered or covering index. State the cost: extra write time and storage.
   3. Refresh statistics if estimates are far off.
   4. Only then consider structural changes (partitioning, a materialized view, denormalization)
      and present them as a proposal with trade-offs.
   Do not add query hints unless nothing else works, and say why.
5. Verify. Re-run the plan after each change and compare to the baseline. Confirm the rewritten
   query returns the same result set as the original (compare counts and a checksum or `EXCEPT`
   both ways on a representative sample). Check that nearby queries on the same table do not get
   worse from a new index.
6. Deliver an index or schema change as a migration through the `safe-migration` skill, not as an
   ad-hoc statement run against the database.
7. Report: the original and final query, the plan evidence (before and after, or "unverified"),
   the index added with its write cost, and any remaining risk. State only timings you measured.
