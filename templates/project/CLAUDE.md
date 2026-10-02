## Git

Delegate every git and GitHub operation (commit, push, branch, PR, CI check, merge, branch
cleanup, release, merge/rebase conflicts, git setup) to the `git-workflow-manager` agent from the
my-toolkit plugin. Do not run these yourself. Project-specific git rules live in `WORKFLOW.md`,
if present; the agent reads it.

In every delegation prompt, include:
- which actions are authorized: "commit", "push", "PR", "merge", "cleanup", "release",
  "continue the rebase" (anything not listed is returned as a proposal)
- the Co-Authored-By trailer and PR attribution line for this session, if any
- for a PR: why the change exists, architecture decisions, exactly which tests and checks were
  run, how it was manually validated, known limitations, and the revision id and name if one is
  used. The agent writes "Not provided" for anything missing and never invents test results.

If the agent returns "Needs approval", show the drafts to the user. Once the user approves,
delegate again with that action authorized.

Final report after each piece of work (you write it, the agent only supplies the git facts):
what was implemented and why, tests run, CI status, PR number, merge status, limitations and
follow-ups. Keep it concise, then ask the user whether the implementation is correct and whether
to move on to the next planned item.

## SQL

Delegate all database work (writing or reviewing queries, designing and building databases,
slow-query tuning, migrations, local database setup, roles, seed data, imports, backup and
restore) to the `sql-pro` agent from the my-toolkit plugin. In the delegation prompt, include:
- the engine and version if known, plus the requirements, query, or table names
- what may be executed and against which database: "read" (default), "execute on <named
  non-production database>", "containers" (start the docker-compose database). Without these the
  agent only writes files and returns the commands.
- for builds: the entities, main reads and writes, expected volume, and any retention or privacy
  needs

The agent never runs against production unless you name it, never drops or rewrites existing
data, and never prints or commits credentials. Review its migrations before they are applied, and
commit through `git-workflow-manager`.
