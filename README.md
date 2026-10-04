# claude-agent-skill-builder

My personal Claude Code agents and skills. This repo is a marketplace (`chris-marketplace`) with
one plugin per agent. Each plugin holds the agent and the skills it follows, so everything for one
agent lives in one folder and a project enables only the agents it needs.

## Independence rule

Every plugin works on its own. No agent requires another agent or plugin to be installed or
loaded, and none loads another plugin's skills. If a task touches another specialty (git,
database, end-to-end tests, review), the agent does what is inside its own scope and lists the
rest under "Follow-ups" for the main session to route. Remove any plugin and the others still work.

## Layout

```
.claude-plugin/marketplace.json     lists all plugins
plugins/<name>/
  .claude-plugin/plugin.json
  agents/<agent>.md
  skills/<skill>/SKILL.md           run as /<name>:<skill>; the agent loads them as <name>:<skill>
  CLAUDE.snippet.md                 paste into a project's CLAUDE.md
  .mcp.json                         only if the plugin needs an MCP server (playwright)
templates/
  project/.claude/settings.json     enables plugins in a project (delete the lines you do not use)
  project/WORKFLOW.md               optional per-project rules, one section per agent
  plugin/                           skeleton for a new agent plugin
```

Skills are only discovered one level deep (`skills/<name>/SKILL.md`), so grouping is done by
plugin, not by nested folders.

## Agents

| Plugin | Agent | Model | What it does | Skills |
|---|---|---|---|---|
| `git` | `git-workflow-manager` | haiku | all git/GitHub work: commit, push, PR, CI, merge, release, conflicts | commit, pr, merge, release, resolve-conflicts |
| `sql` | `sql-pro` | sonnet | writes queries, designs and builds databases, migrations, dev setup | query-writing, schema-design, query-tuning, safe-migration, db-setup |
| `db-performance` | `database-optimizer` | sonnet | expensive queries, index strategy, read-only health checks | workload-analysis, index-strategy, db-health-check |
| `frontend` | `frontend-developer` | sonnet | web apps and UI in the project's own framework | scaffold-app, build-component, data-fetching, accessibility-review, performance-review |
| `playwright` | `frontend-tester` | sonnet | Playwright end-to-end tests with the Playwright MCP server | setup, write-test, run-tests, debug-test |
| `backend` | `backend-developer` | sonnet | endpoints, use-case logic, validation, service hardening | build-endpoint, harden-service |
| `node` | `node-specialist` | sonnet | Node.js runtime performance and code review | node-performance, review-node |
| `typescript` | `typescript-pro` | sonnet | type design, JavaScript to TypeScript migration | type-design, migrate-to-typescript |
| `api` | `api-designer` | sonnet | API design, OpenAPI, breaking-change review | design-api, write-openapi, review-api-change |
| `architecture` | `architect-reviewer` | inherit | read-only design review, decision records | review-design, decision-record |
| `review` | `code-reviewer` | inherit | read-only change and security review | diff, security |
| `testing` | `test-automator` | sonnet | unit, integration and API tests, flaky tests, coverage gaps | write-tests, fix-flaky-tests, coverage-gaps |
| `payments` | `payment-integration` | inherit | provider integration, webhooks, payment review (test mode only) | integrate-gateway, webhook-handler, payment-review |
| `email` | `email-deliverability-engineer` | sonnet | SPF/DKIM/DMARC, transactional email code, deliverability audits | email-auth-setup, transactional-email, deliverability-audit |
| `dependencies` | `dependency-manager` | haiku | dependency audits and safe upgrades | audit-dependencies, upgrade-dependencies |
| `docs` | `documentation-engineer` | haiku | write docs, keep them in sync with code | write-docs, sync-docs |
| `devops` | `devops-engineer` | sonnet | CI pipelines, Dockerfiles, docker-compose | ci-pipeline, containerize |
| `agent-installer` | `agent-installer` | haiku | browse, vet and install community agents | browse, vet, install |

Agents are subagents: they cannot ask you questions, so they act only on what the delegation
prompt authorizes (each plugin's `CLAUDE.snippet.md` says what to include) and return proposals
for anything else. Reviewers (`code-reviewer`, `architect-reviewer`) are read-only.

## Use in a project

1. This repo lives at github.com/chrisfaber95/claude-agent-skill-builder (private; each device
   needs `gh auth login` or a git credential).
2. Copy `templates/project/.claude/settings.json` into the project's `.claude/` and delete the
   plugins the project does not need.
3. Paste the matching `plugins/<name>/CLAUDE.snippet.md` files into the project's `CLAUDE.md`.
   Optionally copy `templates/project/WORKFLOW.md` to the project root and fill in the sections
   for the agents you use. Commit.
4. On any device, open the project in Claude Code and accept the marketplace/plugin prompt.
5. Project-specific skills/agents go in the project's own `.claude/skills/` and `.claude/agents/`
   and are committed with that project.

## Add a new agent

1. Copy `templates/plugin/` to `plugins/<name>/` and set the `name` in its `plugin.json`.
2. Write the agent in `agents/` and its procedures in `skills/<skill>/SKILL.md`. In the agent,
   reference skills as `<name>:<skill>`, and never reference another plugin's agent or skills.
3. Add the plugin to `.claude-plugin/marketplace.json` (`"source": "./plugins/<name>"`) and to
   `templates/project/.claude/settings.json`.
4. Add a `CLAUDE.snippet.md` and, if the agent needs per-project rules, a section in
   `templates/project/WORKFLOW.md`.

Downloaded agent templates usually need rewriting first: remove instructions to query a
"context manager", references to agents you do not have, and made-up metrics, and add safety
rules. The `agent-installer` plugin's `vet` skill checks for these.

## Update

Edit here, bump `version` in the plugin's `plugin.json`, push. In a project run
`/plugin marketplace update` (or restart) to pull the new version.

## Try locally

Load one or more plugins from their folders, for example:

    claude --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\git --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\review
