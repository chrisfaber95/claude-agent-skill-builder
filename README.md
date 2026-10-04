# claude-agent-skill-builder

My personal Claude Code agents and skills. This repo is a marketplace (`chris-marketplace`) with
one plugin per agent. Each plugin holds the agent and the skills it follows, so everything for one
agent lives in one folder and a project enables only the agents it needs.

## Layout

```
.claude-plugin/marketplace.json     lists the plugins below
plugins/
  git/                              plugin "git"  -> skills run as /git:<skill>
    .claude-plugin/plugin.json
    agents/git-workflow-manager.md
    skills/commit, pr, merge, release, resolve-conflicts
    CLAUDE.snippet.md               paste into a project's CLAUDE.md
  sql/                              plugin "sql"  -> skills run as /sql:<skill>
    .claude-plugin/plugin.json
    agents/sql-pro.md
    skills/query-writing, schema-design, query-tuning, safe-migration, db-setup
    CLAUDE.snippet.md
  frontend/                         plugin "frontend" -> skills run as /frontend:<skill>
    .claude-plugin/plugin.json
    agents/frontend-developer.md
    skills/scaffold-app, build-component, data-fetching, accessibility-review, performance-review
    CLAUDE.snippet.md
  playwright/                       plugin "playwright" -> skills run as /playwright:<skill>
    .claude-plugin/plugin.json
    .mcp.json                       declares Playwright MCP server
    agents/frontend-tester.md
    skills/setup, write-test, run-tests, debug-test
    CLAUDE.snippet.md
templates/
  project/.claude/settings.json     enables the plugins in a project
  project/WORKFLOW.md               optional per-project rules, one section per agent
  plugin/                           skeleton for a new agent plugin
```

Skills are only discovered one level deep (`skills/<name>/SKILL.md`), so grouping is done by
plugin, not by nested folders.

## Agents

- `git-workflow-manager` (haiku, plugin `git`) - all git/GitHub work: commit, push, PR, CI check,
  merge, branch cleanup, release, conflicts, workflow audits. Acts only on what the delegation
  authorizes; otherwise returns drafts for approval.
- `sql-pro` (sonnet, plugin `sql`) - all database work: queries, designing and building databases,
  tuning, migrations, local/dev setup, roles, seed data, imports, backup/restore. Always writes
  files; executes against a database only when the delegation names what is authorized.
- `frontend-developer` (sonnet, plugin `frontend`) - builds frontend apps and UI in the project's
  own framework (React, Vue, Angular, ...): scaffolding, components, data fetching and real-time,
  accessibility and performance reviews. Verifies with type check, lint, tests and build; leaves
  `data-testid` hooks for `frontend-tester`; never commits.
- `frontend-tester` (sonnet, plugin `playwright`) - all frontend testing: setting up Playwright,
  writing and reviewing tests, running test suites, debugging failures. Uses the Playwright MCP
  server to explore pages and generate selectors. Writes test files; runs them only when
  authorized (default: local localhost, not production).

Skills are each agent's procedures; the agent loads them by name (`git:commit`,
`sql:query-tuning`, `frontend:build-component`, `playwright:setup`, ...) and you can also run them directly as
`/<plugin>:<skill>`.

## Use in a project

1. This repo lives at github.com/chrisfaber95/claude-agent-skill-builder (private; each device
   needs `gh auth login` or a git credential).
2. Copy `templates/project/.claude/settings.json` into the project's `.claude/` and delete the
   plugins the project does not need.
3. Paste the matching `plugins/<name>/CLAUDE.snippet.md` into the project's `CLAUDE.md`.
   Optionally copy `templates/project/WORKFLOW.md` to the project root and fill it in. Commit.
4. On any device, open the project in Claude Code and accept the marketplace/plugin prompt.
5. Project-specific skills/agents go in the project's own `.claude/skills/` and `.claude/agents/`
   and are committed with that project.

## Add a new agent (tester, reviewer, coder, ...)

1. Copy `templates/plugin/` to `plugins/<name>/` and set the `name` in its `plugin.json`.
2. Write the agent in `agents/` and its procedures in `skills/<skill>/SKILL.md`. In the agent,
   reference skills as `<name>:<skill>`.
3. Add the plugin to `.claude-plugin/marketplace.json` (`"source": "./plugins/<name>"`).
4. Add a `CLAUDE.snippet.md` and, if the agent needs per-project rules, a section in
   `templates/project/WORKFLOW.md`.

## Update

Edit here, bump `version` in the plugin's `plugin.json`, push. In a project run
`/plugin marketplace update` (or restart) to pull the new version.

## Try locally

    claude --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\git --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\sql --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\frontend --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\playwright
