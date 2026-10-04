---
name: db-health-check
description: "Procedure for a read-only health and capacity check of a database: size and growth, statistics and maintenance state, connections and locks, cache and memory signals, replication lag, long-running work, configuration worth reviewing, and backups, reported with evidence. Followed by the database-optimizer agent; in a main session, delegate database health checks to that agent."
argument-hint: "<database to check>"
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

Check the health of: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
database-optimizer subagent, state the assumption and return the question. Read-only, on a named
non-production database. Do not change settings, run maintenance commands or kill sessions;
recommend them.

## Steps

1. Establish the engine, version, environment and how you may connect. Run only `SELECT`,
   `SHOW` and catalog and statistics views. If no database is reachable, say so and review the
   configuration files and migrations in the repo instead.
2. Size and growth: database and largest table and index sizes, row estimates, and growth over
   time if the history exists. Compare with the project's stated targets and available disk.
3. Statistics and maintenance:
   - PostgreSQL: last autovacuum and autoanalyze times, dead tuples, table and index bloat
     signals, transaction ID age
   - MySQL: table statistics freshness, fragmentation, InnoDB status highlights
   - SQL Server: statistics age, index fragmentation, Query Store state
   - Oracle: statistics gathering jobs, tablespace usage
   Stale statistics cause bad plans; note tables whose statistics lag far behind their changes.
4. Connections and concurrency: current connections against the limit, idle-in-transaction or
   long-running sessions, blocked sessions and locks, deadlock counts, and the application's
   pool size compared with the server limit.
5. Memory and cache signals: buffer cache or buffer pool hit ratios and sizes, temp file or
   temp table usage and spills to disk, sort memory. Treat ratios as hints, not verdicts; a high
   hit ratio can hide wasteful queries.
6. Replication and availability: replication lag, replica status, failover setup if present.
7. Configuration worth reviewing: the settings that most affect the workload for this engine
   (memory sizes, parallelism, connection limits, checkpoint and logging settings, slow query
   logging enabled or not). Recommend changes with the reason and the risk; do not apply them.
8. Backups and recovery: whether backups exist and their schedule if visible, whether point in
   time recovery is configured, and when a restore was last tested. You usually cannot verify
   this from inside the database; say so and list what a human should confirm.
9. Report a summary verdict, then findings ranked by risk (data loss or outage risk first, then
   performance, then tidiness), each with the evidence (the value and the query or view it came
   from), the recommendation and the risk of changing it. State what you could not check.
