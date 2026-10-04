## SQL

Delegate all database work (writing or reviewing queries, designing and building databases,
slow-query tuning, migrations, local database setup, roles, seed data, imports, backup and
restore) to the `sql-pro` agent from the `sql` plugin. In the delegation prompt, include:
- the engine and version if known, plus the requirements, query, or table names
- what may be executed and against which database: "read" (default), "execute on <named
  non-production database>", "containers" (start the docker-compose database). Without these the
  agent only writes files and returns the commands.
- for builds: the entities, main reads and writes, expected volume, and any retention or privacy
  needs

The agent never runs against production unless you name it, never drops or rewrites existing
data, and never prints or commits credentials. Review its migrations before they are applied, and
commit them yourself or with whichever git agent you use.
