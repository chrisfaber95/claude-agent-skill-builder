---
name: index-strategy
description: "Procedure for reviewing and changing a database's indexes: find missing, unused, duplicate and redundant indexes from workload evidence, design composite and covering indexes, weigh write cost and storage, and deliver changes as migrations with an online method and a rollback. Followed by the database-optimizer agent; in a main session, delegate index work to that agent."
argument-hint: "<table, query or database to review indexes for>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Review and design indexes for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
database-optimizer subagent, state the assumption and return the question. Write migration
files; do not create or drop indexes on a live database.

## Steps

1. Establish the engine, version and the migration tool and its conventions. List the existing
   indexes from the migrations and, where a non-production database is readable, from the
   catalog (for example PostgreSQL `pg_indexes`, MySQL `information_schema.statistics`,
   SQL Server `sys.indexes`).
2. Collect the access patterns: the real queries that touch the table (search the repo), their
   filters, joins, sort orders and limits, and how often each runs. Add what the workload
   statistics show if the `workload-analysis` skill is available or its numbers were supplied.
   Design from queries, not from habit.
3. Find indexes that can go, only as proposals and only with evidence:
   - **unused**: no scans in the engine's usage statistics (PostgreSQL `pg_stat_user_indexes`,
     MySQL `sys.schema_unused_indexes`, SQL Server `sys.dm_db_index_usage_stats`). Usage
     counters reset on restart and differ between primary and replicas; require a long enough
     window that covers a full business cycle (including month-end jobs) and check replicas.
   - **duplicate or redundant**: an index whose columns are a left prefix of another index
     serves the same lookups, unless it is unique or serves a constraint.
   Never propose dropping an index that backs a primary key, unique constraint or foreign key.
4. Find indexes to add. For each candidate state the query it serves and the plan evidence that
   it currently scans. Design rules:
   - equality columns first, then range or sort columns; the most selective equality column
     usually first
   - match the `ORDER BY` direction and columns to avoid a sort
   - cover the query with included columns (`INCLUDE` in PostgreSQL 11+ and SQL Server) or by
     adding the columns, only if the read gain justifies the size
   - partial or filtered indexes for queries that always filter on the same condition
   - functional or expression indexes only when the query uses that exact expression
   - index foreign keys that are joined or deleted through; PostgreSQL does not create these
     automatically, and MySQL InnoDB does
   - prefix indexes for long text, and full-text indexes for text search instead of `LIKE '%x%'`
5. Weigh the cost: every index slows inserts, updates and deletes on that table and uses
   storage and memory, so state the expected write overhead and the size, and refuse an index
   that serves a rare query on a hot write table without a reason.
6. Write the migration in the project's tool and style. Create indexes in an online or low-lock
   way where the engine supports it (PostgreSQL `CREATE INDEX CONCURRENTLY`, which cannot run
   inside a transaction block; MySQL `ALGORITHM=INPLACE, LOCK=NONE` where supported; SQL Server
   `ONLINE = ON` on editions that allow it), set a lock timeout where relevant, and include the
   rollback. For big tables, say how long the build may take and when to run it.
7. Verify what you can: apply the migration to a scratch or local database if authorized, then
   compare the plan and timing of the target queries before and after, and confirm the plan uses
   the new index. If you cannot run it, mark the benefit unverified.
8. Report: indexes proposed to add and to drop, each with evidence, the queries they serve, the
   cost, the migration files, the before and after measurements, and what a human must confirm
   on production (usage window, replicas, maintenance window).
