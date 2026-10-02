---
name: db-setup
description: "Procedure for setting up and operating a database: a reproducible local or dev instance (docker-compose), roles and least-privilege access, connection settings, seed data and imports, and backup and restore with a tested restore. Followed by the sql-pro agent; in a main session, delegate database setup and operations to that agent."
argument-hint: "<engine and what to set up>"
allowed-tools: [Bash, Read, Grep, Glob, Edit, Write]
---

Set up or operate the database for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the sql-pro
subagent, state the assumption and return the question. Write the files; start containers or run
statements only as the sql-pro safety rules allow. Never touch a production database, and never
write real credentials to a file that is committed.

## Steps

1. Establish the engine and version, the environment (local dev, CI, staging, production), and
   what already exists (`docker-compose*`, `.env.example`, init scripts, migration tool). Extend
   what exists instead of replacing it.
2. Local or dev instance:
   - a `docker-compose` service with a pinned image version (not `latest`), a named volume for
     data, a published port that does not clash with other local services, and a healthcheck
   - configuration from environment variables; commit an `.env.example` with placeholder values
     and make sure the real `.env` is git-ignored
   - an init mechanism for first start (the image's init-scripts directory, or the migration
     tool run on startup) so a fresh checkout reaches a working database with documented
     commands
   - a short note in the README: how to start, migrate, seed and reset
3. Roles and access (least privilege):
   - a migration/owner role that can change the schema, and a separate application role with
     only the table privileges the app needs (`SELECT`, `INSERT`, `UPDATE`, `DELETE`); a
     read-only role for reporting. The application never connects as a superuser or `sa`/`root`.
   - schema and default privileges set so new tables get the right grants
   - connection settings: TLS where the environment supports it, sensible pool size (not larger
     than the server's connection limit divided across app instances), and timeouts
4. Seed data and imports:
   - reference data as an idempotent script (upsert, or insert guarded by `NOT EXISTS`)
   - development sample data separate from reference data, and never real personal data
   - bulk loads through the engine's fast path (PostgreSQL `COPY`, MySQL `LOAD DATA`, SQL Server
     `BULK INSERT`/`bcp`, Oracle SQL*Loader or external tables), into a staging table first, then
     validate types, nulls and duplicates, then merge into the real tables in one transaction
5. Backup and restore:
   - the engine's native tools (PostgreSQL `pg_dump`/`pg_restore` and base backups with WAL
     archiving for point-in-time recovery; MySQL `mysqldump` or a physical backup tool; SQL Server
     `BACKUP DATABASE`; Oracle RMAN or Data Pump)
   - state the retention, where backups are stored, and who can read them
   - a backup is only real once restored: restore into a scratch database and run a few sanity
     queries (row counts, latest timestamps). Document the restore command.
6. Operations notes (document, do not change global settings yourself): connection limits,
   memory and autovacuum/statistics maintenance settings worth reviewing, slow-query logging, and
   monitoring queries (long-running transactions, lock waits, table and index size, replication
   lag). Deliver these as recommendations or as read-only scripts.
7. Report: the files created, the commands to start, migrate, seed and restore, the roles and
   what each can do, the assumptions, and what you did not verify (for example, if Docker was not
   available to start the container).
