# db-performance parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `db-performance` section of `.claude/project-params.md`, read by
database-optimizer.

## Recommend when
- The sql plugin's evidence is present, and the project states data volume or performance
  targets, or reports slow queries (project docs, issues, comments). Evidence: the database
  dependency plus the document or note. A database alone is not enough; then list it unselected.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| engine_and_version | which statistics views exist | as for the sql plugin | no |
| performance_targets | what "fast enough" means (rows, users, latency) | project docs | no |
| statistics_available | slow query log, `pg_stat_statements`, performance_schema | config files, compose settings | no |
| readable_database | non-production database it may read | compose service, `.env.example` | yes: may it read it (default no) |
| migration_tool | how index changes are delivered | as for the sql plugin | no |
