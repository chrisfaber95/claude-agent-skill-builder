# claude-agent-skill-builder

Central repo for my personal Claude Code skills and agents. It is a plugin (`my-toolkit`) and a marketplace (`chris-marketplace`) in one.

## Layout

- `skills/<name>/SKILL.md` - global skills (invoked as `/my-toolkit:<name>`)
- `agents/<name>.md` - global subagents
- `.claude-plugin/plugin.json` - plugin manifest
- `.claude-plugin/marketplace.json` - lets projects install this repo by name
- `templates/project/.claude/settings.json` - copy into each project
- `templates/project/CLAUDE.md` - append to each project's CLAUDE.md
- `templates/project/WORKFLOW.md` - optional per-project rules the agents read (one section per agent)

## Contents

Agents:
- `git-workflow-manager` (haiku) - does all git/GitHub work: commit, push, PR, CI check, merge,
  branch cleanup, release, conflicts, workflow audits. Acts only on what the delegation
  authorizes; otherwise returns drafts for approval.
- `sql-pro` (sonnet) - all database work: writing/reviewing queries, designing and building
  databases, query tuning from execution plans, safe migrations, local/dev setup, roles, seed
  data, imports, backup/restore. Always writes files; executes against a database only when the
  delegation names what is authorized.

Skills (each agent's procedures; also callable directly as `/my-toolkit:<name>`):
- `commit` - focused Conventional Commits commit with secret check, never skips hooks, verified push
- `pr` - GitHub PR with a structured description (summary, why, changes, architecture, testing, validation, limitations)
- `merge` - CI verification, merge gates, squash merge, merged-branch cleanup (never `--admin`)
- `release` - semver bump from commits, CHANGELOG, tag, push
- `resolve-conflicts` - merge/rebase/cherry-pick conflict resolution
- `query-writing` - queries and data modifications: grain, joins, NULLs, dates, safe UPDATE/DELETE, review checklist
- `schema-design` - build a database from requirements: model, keys, types, constraints, indexes, ER diagram, seed data
- `query-tuning` - evidence-based slow query tuning (plan, bottleneck, rewrite/index, verify)
- `safe-migration` - schema migrations with lock analysis, expand/contract, batched backfills, rollback
- `db-setup` - dev database (docker-compose), least-privilege roles, seed/import, backup and tested restore

Each future agent (tester, reviewer, coder, ...) gets its own skills the same way; shared
project-specific rules go in the project's `WORKFLOW.md`, one section per agent.

## Use in a project

1. This repo lives at github.com/chrisfaber95/claude-agent-skill-builder (private; each device needs `gh auth login` or a git credential).
2. Copy `templates/project/.claude/settings.json` into the project's `.claude/`, append
   `templates/project/CLAUDE.md` to the project's `CLAUDE.md`, optionally copy
   `templates/project/WORKFLOW.md` to the project root and fill it in, and commit.
3. On any device, open the project in Claude Code and accept the marketplace/plugin prompt.
4. Project-specific skills/agents go in the project's own `.claude/skills/` and `.claude/agents/` and are committed with that project.

## Update

Edit here, bump `version` in `plugin.json`, push. In a project run `/plugin marketplace update` (or restart) to pull the new version.

## Try locally

    claude --plugin-dir N:\Projects\claude-agent-skill-builder
