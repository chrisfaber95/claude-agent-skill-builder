---
name: query-writing
description: "Procedure for writing or reviewing SQL queries and data modifications: pin down the result grain, write set-based SQL in the right dialect, handle NULLs, ties and date ranges, verify against sample data, and make UPDATE/DELETE statements safe. Followed by the sql-pro agent; in a main session, delegate SQL authoring and review to that agent."
argument-hint: "<what the query must return or change>"
allowed-tools: [Bash, Read, Grep, Glob, Edit, Write]
---

Write or review the SQL for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the sql-pro
subagent, state the assumption and return the question. Follow the sql-pro safety rules:
SELECTs are fine; run data-modifying statements only when authorized on a named non-production
database.

## Writing a query

1. Pin down the question: the result grain ("one row per what?"), the columns, the filters, the
   ordering, and the parameters. Find the engine and version, and write in that dialect. If the
   engine is unknown, write ANSI SQL and note the engine-specific alternatives.
2. Read the real schema (migrations, models, `information_schema`) for table and column names
   and types. Never guess column names.
3. Build it up in readable steps: start from the driving table, add joins one at a time, then
   aggregate. Use CTEs for named steps; use window functions (`ROW_NUMBER`, `RANK`, `LAG`/`LEAD`,
   running totals) instead of self-joins for ranking and comparisons; use `EXISTS` for existence
   checks; use recursive CTEs for hierarchies; use upserts (`INSERT … ON CONFLICT`,
   `ON DUPLICATE KEY UPDATE`, `MERGE`) for insert-or-update.
4. Get the details right:
   - Join type: `LEFT JOIN` when the left rows must survive. Filters on the right table belong in
     the `ON` clause, or the left join silently becomes an inner join.
   - Fan-out: a join to a one-to-many table repeats rows. Aggregate before joining, or check the
     row count against the grain.
   - NULLs: comparisons with NULL are unknown. Use `IS NULL`, `COALESCE`, and `NOT EXISTS`
     instead of `NOT IN` with a nullable subquery.
   - Ties: add a unique tiebreaker to `ORDER BY` when order matters or when paginating.
   - Dates and time zones: use half-open ranges (`>= :start AND < :end`), and be explicit about
     which time zone the boundaries are in. Do not wrap an indexed column in a function.
   - Types: do not compare mismatched types; cast the parameter, not the column.
   - Columns: name them explicitly (no `SELECT *` outside throwaway exploration).
   - Parameters: always use bind parameters. Never build SQL from user input by concatenation.
5. Verify before declaring it done. Check the query against a small fixture (in a scratch
   database, or reasoned by hand) that includes the edge cases: no matching rows, NULLs,
   duplicates, ties, and boundary dates. Compare row counts with the intended grain. For large
   tables look at the plan, and use the `query-tuning` skill if it is slow.
6. Add a short comment on the intent where it is not obvious, and keep the query formatted
   consistently (one clause per line, aligned joins).

## Data modifications (INSERT, UPDATE, DELETE, MERGE)

- Write the `WHERE` first. Run the same predicate as a `SELECT count(*)` (and a sample of the
  rows) and confirm the count is what you expect before you write the modification.
- Wrap the change in a transaction and check the affected row count. Prefer small batches by key
  range for large tables.
- For deletions of real data, prefer an archive step, or return the statement for review. Never
  run `DELETE`/`UPDATE` without a `WHERE` unless the request is explicitly for the whole table.
- Make scripts idempotent where possible (`IF NOT EXISTS`, upserts, guarded updates).

## Reviewing a query

Check correctness first, then performance: wrong grain, fan-out, `LEFT JOIN` turned inner, NULL
traps, unstable ordering, off-by-one date ranges, injection risk. Then check for non-sargable
predicates, implicit casts and missing indexes. Report each finding with the line and a fix.

## Report

Return the query, the assumptions about schema and engine, how you verified it (sample cases or
"unverified"), and any follow-up (an index, a migration, a slow-query concern).
