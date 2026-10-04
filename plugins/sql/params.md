# sql parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `sql` section of `.claude/project-params.md`, read by sql-pro.

## Recommend when
- A package depends on a SQL driver, query builder or ORM: `mysql`, `mysql2`, `pg`, `sqlite3`,
  `better-sqlite3`, `mssql`, `oracledb`, `knex`, `sequelize`, `prisma`, `typeorm`, `drizzle-orm`,
  `objection`; or the project has `.sql` files or a `migrations/` folder. Evidence: the manifest
  line or folder.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| engine_and_version | dialect and features | driver, compose image tag, connection string scheme in `.env.example` | no |
| access_layer | how code talks to the database | driver, query builder or ORM in use | no |
| schema_source | where the schema is defined | migrations, schema files, ORM models | no |
| migration_tool | how changes are delivered | tool dependency, `migrations/` folder, scripts | no |
| local_database | the database agents may read | compose service, `.env.example` | yes: may agents read it (default no) |
| execute_allowed | databases agents may run DDL/DML on | not detectable | no, default none |
| production_access | production databases | not detectable | no, always none |
