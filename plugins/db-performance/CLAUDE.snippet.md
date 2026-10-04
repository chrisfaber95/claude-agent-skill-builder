## Database performance

Delegate database performance work (finding expensive queries, index strategy, read-only health
checks) to the `database-optimizer` agent from the `db-performance` plugin. In the delegation
prompt, include:
- the engine and version, and the slow symptom or table sizes
- which non-production database it may read (default: none, it analyzes the repo only) and
  whether it may execute statements ("execute" must be explicit)
- the migration tool the project uses

The agent measures from the engine's own statistics, delivers changes as migration files with a
rollback, and never alters a live database. It works on its own; if it lists follow-ups
(application code, schema redesign), you decide who does them.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
