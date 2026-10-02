---
name: schema-design
description: "Procedure for designing and building a database schema from requirements: entities, keys, types, constraints, indexes, an ER diagram, seed data and the SQL or migration files that create it. Followed by the sql-pro agent; in a main session, delegate database design and builds to that agent."
argument-hint: "<what the database must store and do>"
allowed-tools: [Bash, Read, Grep, Glob, Edit, Write]
---

Design and build a database for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the sql-pro
subagent, state the assumption and return the question. Write all files; execute statements only
as the sql-pro safety rules allow (authorized, named, non-production database).

## Steps

1. Gather requirements. If the delegation prompt or the repo does not answer them, state your
   assumptions explicitly: the entities and how they relate, the main reads and writes (access
   patterns), expected data volume and growth, transactional (OLTP) or analytical use, engine and
   version, multi-tenancy, audit or history needs, and retention or privacy requirements.
2. Check what exists: current migrations, ORM models, the migration tool, naming conventions.
   Extend and match them. For an existing database use the `safe-migration` skill for the changes.
3. Model the entities:
   - one table per entity; a junction table for many-to-many; a nullable self-reference for
     hierarchies (or a closure/path table if deep reads dominate)
   - normalize to third normal form first; denormalize only for a named access pattern and write
     the reason next to it
   - for analytics requests, design a star schema (facts at a stated grain, conformed dimensions,
     a date dimension) instead
4. Choose keys and types:
   - primary key on every table; a surrogate key (`bigint` identity/serial, or UUID if ids must be
     generated outside the database) plus a unique constraint on the natural key where one exists
   - money as exact decimals (`NUMERIC`/`DECIMAL`) with a stated scale, never floating point
   - timestamps in UTC with time zone support where the engine has it (`timestamptz`,
     `DATETIMEOFFSET`); store dates as dates
   - text lengths and character set deliberate (UTF-8); no unbounded free text in indexed columns
   - small closed sets as lookup tables or `CHECK` constraints; use native enums only if values
     will rarely change
5. Enforce integrity in the database, not only in the application: `NOT NULL` by default,
   `UNIQUE`, `CHECK`, and foreign keys with an explicit `ON DELETE` choice (`RESTRICT` by
   default; `CASCADE` only for owned child rows). Add `created_at`/`updated_at` where useful, and
   soft delete or an audit table only when the requirements ask for it.
6. Add indexes from the access patterns, not by habit: indexes for foreign keys that are joined
   or filtered on (PostgreSQL does not create them automatically; MySQL InnoDB does), unique
   indexes for natural keys, and composite indexes ordered equality columns first, then range or
   sort columns. Each index costs writes and storage, so list the query it serves.
7. Name consistently with the project's convention (default: `snake_case`, singular or plural
   table names matching existing tables, `<table>_id` foreign keys, explicit constraint and index
   names).
8. Deliver files in the project's migration format (see `safe-migration`), or a single
   `schema.sql` if there is no tool, including:
   - the DDL, in dependency order
   - seed or reference data (lookup rows) as a separate idempotent file; sample data for
     development only if asked, never real data
   - an ER description as a Mermaid `erDiagram` in the docs or the PR text
   - a short list of the main queries the schema was designed for, with the index each uses
9. Verify. If authorized, apply the DDL to a fresh scratch database, insert a few valid rows, and
   confirm that invalid ones (null, duplicate, orphan foreign key, bad check value) are rejected.
   Run the listed main queries and check their plans use the intended indexes. Otherwise mark the
   schema "unverified" and say why.
10. Report: files written, the ER diagram, the assumptions you made, the trade-offs (what was
    denormalized and why), and the open questions.
