---
name: safe-migration
description: "Procedure for writing a safe database schema migration: adding columns, indexes and constraints, renames, drops and backfills, with lock analysis, a rollback, and verification. Followed by the sql-pro agent; in a main session, delegate schema migrations to that agent."
argument-hint: "<schema change to make>"
allowed-tools: [Bash, Read, Grep, Glob, Edit, Write]
---

Plan and write a migration for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the sql-pro
subagent, state the assumption and return the question. Write the migration; do not run it
against any database unless the delegation prompt authorized running statements on a named,
non-production database.

## Steps

1. Find the migration tool and its conventions (Flyway, Liquibase, Prisma, Knex, TypeORM, Alembic,
   Django, Rails, EF Core, plain `.sql` files). Match the existing naming, numbering, and
   up/down style. Do not introduce a new tool. Read the latest migrations for the pattern.
2. Establish the engine and version, the affected tables' sizes, and whether the application
   keeps running during deploy. A change on a small table in a stopped app can be simple; a
   change on a large live table needs the careful path below.
3. Classify the change and choose the pattern:
   - **Add nullable column**: usually cheap. Adding a column with a default can rewrite the
     table on some engines and versions (older PostgreSQL, MySQL without `ALGORITHM=INSTANT`,
     SQL Server on large tables). Check this engine and version's documentation, and prefer the
     metadata-only form.
   - **Add NOT NULL / constraints**: add as nullable or `NOT VALID`/`WITH NOCHECK`, backfill,
     then validate or enforce in a separate step so the lock stays short.
   - **Add index on a live table**: use the online form (PostgreSQL `CREATE INDEX CONCURRENTLY`,
     which cannot run inside a transaction block, so mark the migration non-transactional;
     MySQL `ALGORITHM=INPLACE, LOCK=NONE`; SQL Server `ONLINE = ON` where the edition supports it).
   - **Rename or change a type**: use expand and contract: add the new column, write to both,
     backfill, switch reads, then drop the old one in a later migration. Never rename in place
     while the old code still runs.
   - **Drop column/table**: only after nothing reads or writes it. Ship the drop separately and
     later than the code change, and flag it as destructive in the report.
   - **Backfill**: in batches by primary key range with a pause or commit between batches, never
     one giant `UPDATE`. Make it idempotent and resumable.
4. Write the migration:
   - one logical change per migration, small enough to review
   - a down/rollback step where the tool supports it. If a step is irreversible (data loss),
     say so explicitly at the top of the file
   - set a lock timeout on risky DDL (for example PostgreSQL `SET lock_timeout`) so it fails
     fast instead of queuing behind long transactions and blocking everything
   - no application data or secrets in the file
5. Verify without touching shared data: apply up and down on a fresh local or scratch database
   if one is available and authorized; otherwise review the SQL against the engine's
   documentation and mark it "unverified".
6. Report: the migration file path(s), the lock and rewrite risk per step, expected duration
   drivers (table size), the deploy order relative to application code (for expand and
   contract), the rollback, and anything destructive. State only durations you measured.
