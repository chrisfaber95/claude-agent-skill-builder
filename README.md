# claude-agent-skill-builder

My personal Claude Code agents and skills. This repo is a marketplace (`chris-marketplace`) with
one plugin per agent. Each plugin holds the agent and the skills it follows, so everything for one
agent lives in one folder and a project enables only the agents it needs.

## Independence and handoffs

Every plugin works on its own. No agent requires another agent or plugin to be installed or
loaded, and none loads another plugin's skills. Remove any plugin and the others still work.

Agents can still pass work to each other, but only to agents that are installed:

- **Handoffs** (all agents): when part of a task belongs to another specialty, the agent ends its
  result with a Handoffs entry (`to`, `why`, `task`, `context`, `needs authorization`). The main
  session routes it to the named agent if that agent is installed, otherwise does it itself or
  shows it to you. Authorization is never passed on; the main session asks you first.
- **Consults** (implementer agents, which have the `Agent` tool): an agent may ask another
  installed agent for read-only help (a review, an analysis, design advice), at most twice per
  task, without passing any authorization. Writes, git operations and database execution always
  go back through the main session. Reviewers, the git agent and the installer only use handoffs.
  Claude Code ignores agent-name limits on subagents, so these limits are enforced by the agents'
  instructions, not by the platform.

| Agent | Typically hands off to |
|---|---|
| `frontend-developer` | frontend-tester, api-designer, backend-developer, code-reviewer, git-workflow-manager |
| `backend-developer` | api-designer, sql-pro, test-automator, payment-integration, email-deliverability-engineer, code-reviewer, git-workflow-manager |
| `sql-pro` / `database-optimizer` | each other, backend-developer, code-reviewer, git-workflow-manager |
| `payment-integration` | code-reviewer, backend-developer, frontend-developer, sql-pro, test-automator, git-workflow-manager |
| `test-automator` / `frontend-tester` | each other, the implementer for bugs found, code-reviewer, git-workflow-manager |
| `code-reviewer` / `architect-reviewer` | the implementer for each finding, test-automator, documentation-engineer |
| `git-workflow-manager` | code-reviewer, devops-engineer, test-automator, documentation-engineer |

Each agent's own "Working with other agents" section has its full list.

## Layout

```
.claude-plugin/marketplace.json     lists all plugins
plugins/<name>/
  .claude-plugin/plugin.json
  agents/<agent>.md
  skills/<skill>/SKILL.md           run as /<name>:<skill>; the agent loads them as <name>:<skill>
  CLAUDE.snippet.md                 delegation instructions for a project's CLAUDE.md
  params.md                         when the installer recommends the plugin, and its project parameters
  .mcp.json                         only if the plugin needs an MCP server (playwright)
plugins/project-setup/              the installer (no agent; skill /project-setup:install)
templates/
  project/.claude/settings.json     manual alternative to the installer (delete unused lines)
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
for anything else. Reviewers (`code-reviewer`, `architect-reviewer`) are read-only. The git
agent has defaults: commit, push, PR and merge (only once CI and every merge gate pass) are
authorized unless the delegation restricts them; set `merge_mode: ask` in its section of
`.claude/project-params.md` to keep opening PRs without asking but approve merges yourself.

## Use in a project

This repo lives at github.com/chrisfaber95/claude-agent-skill-builder (private; each device
needs `gh auth login` or a git credential).

### With the installer (recommended)

The installer is installed per project: it goes into that project's `.claude/settings.json`, so
it is committed with the project and every device that opens the project gets it. Add it in one
of two ways:

**With commands**, in Claude Code opened in the project, choosing **project** scope in both
pickers:

    /plugin marketplace add chrisfaber95/claude-agent-skill-builder
    /plugin install project-setup@chris-marketplace

(The CLI equivalent is `claude plugin marketplace add chrisfaber95/claude-agent-skill-builder
--scope project` and `claude plugin install project-setup@chris-marketplace -s project`. Both
default to user scope, so pass the scope.)

**Without commands**, put this in the project's `.claude/settings.json` (merge it with what is
there), then open the project and accept the marketplace and install prompts:

```json
{
  "extraKnownMarketplaces": {
    "chris-marketplace": {
      "source": { "source": "github", "repo": "chrisfaber95/claude-agent-skill-builder" }
    }
  },
  "enabledPlugins": {
    "project-setup@chris-marketplace": true
  }
}
```

Then run `/project-setup:install` in that project. It:

1. scans the project (manifests, dependencies, test scripts, CI files, databases, payment and
   mail libraries, git repositories, existing docs and `.claude/` files)
2. pre-selects only the plugins it finds concrete evidence for, and shows that evidence; every
   other plugin of this marketplace is listed unselected so you can add it by hand, and you can
   remove any recommendation (`/project-setup:install +docs -playwright` works too)
3. fills each selected plugin's parameters from the scan and asks only for the few it cannot
   detect
4. optionally turns procedures your project already documents (for example how changes are
   tested, documented or merged here) into files in `.claude/procedures/`, each listed only in
   the sections of the agents it is for; only those agents load it, the main session does not.
   Every procedure records its source document and a hash, so agents notice when the source
   changed. Nothing is invented: steps come from your documents, and you confirm each procedure
5. offers to move same-named old agents in `.claude/agents/` to `.claude/agents-archive/`
6. shows every change and writes only after you confirm:
   - `.claude/settings.json`: marketplace plus the selected plugins (other settings kept)
   - `.claude/project-params.md`: one section per plugin with the detected values and their
     source; edit freely, a re-run keeps your edits
   - `CLAUDE.md`: one marked block with the selected plugins' delegation instructions and an
     import of the parameters file; nothing outside the block is touched

Restart Claude Code in the project (or run `/plugin`) and accept the prompts to install the
plugins. The installer stays enabled in the project, so you can re-run `/project-setup:install`
any time to add or remove plugins; remove it with `/plugin` if you no longer want it there. Only
plugins from this marketplace are ever offered.

### By hand

1. Copy `templates/project/.claude/settings.json` into the project's `.claude/` and delete the
   plugins the project does not need.
2. Paste the matching `plugins/<name>/CLAUDE.snippet.md` files into the project's `CLAUDE.md`.
3. Optionally create `.claude/project-params.md` with a section per plugin, using the keys in each
   plugin's `params.md`. Agents read their section; without the file they fall back to a root
   `WORKFLOW.md`. Commit.

Project-specific skills/agents go in the project's own `.claude/skills/` and `.claude/agents/`
and are committed with that project.

## Add a new agent

1. Copy `templates/plugin/` to `plugins/<name>/` and set the `name` in its `plugin.json`.
2. Write the agent in `agents/` and its procedures in `skills/<skill>/SKILL.md`. In the agent,
   reference skills as `<name>:<skill>`, and never reference another plugin's agent or skills.
3. Add the plugin to `.claude-plugin/marketplace.json` (`"source": "./plugins/<name>"`) and to
   `templates/project/.claude/settings.json`.
4. Add a `CLAUDE.snippet.md` and a `params.md` (from `templates/plugin/params.md`): concrete
   evidence for when the installer should recommend it, and the parameters the agent reads from
   its section of `.claude/project-params.md`.

Downloaded agent templates usually need rewriting first: remove instructions to query a
"context manager", references to agents you do not have, and made-up metrics, and add safety
rules. The `agent-installer` plugin's `vet` skill checks for these.

## Update

Edit here, bump `version` in the plugin's `plugin.json`, push. In a project run
`/plugin marketplace update` (or restart) to pull the new version. Installed plugins are cached
by version: a change without a version bump never reaches an installed copy. Before pushing, run

    bash scripts/check-versions.sh origin/main

which fails for any plugin whose files changed without a version bump.

## Evals

The `git`, `review`, `payments` and `sql` plugins have safety evals in `plugins/<name>/evals/`
(force-push refusal, hooks never skipped, the reviewer never edits, live payment keys refused,
no database execution without authorization). Run one plugin's suite with the bundled CLI:

    claude plugin eval plugins/<name> --scaffold --trust-plugin --no-publish

Each run starts real Claude sessions on your account (three runs per case plus a no-plugin
baseline by default; `--runs 1` and `--max-cost-usd` keep it small). `--scaffold` runs the
cases' own setup scripts, which only create a temporary git repo with fixture files. Add
`--allow-tools Edit Write` (and `Bash` for the shell cases) so the agents can actually act.

On Windows:
- Cases tagged `needs-shell-sandbox` (git and sql) grant Bash, and the eval runner refuses to run
  a shell it cannot sandbox; Windows has no sandbox backend. Run them on Linux or macOS. The
  review and payments cases need no shell and run on Windows.
- If the runner reports that a PATH directory could not be examined (EPERM), remove the
  unreadable entry for that command only, for example in Git Bash:
  `PATH=$(echo "$PATH" | tr ':' '\n' | grep -v 'system32/config/systemprofile' | paste -sd: -) claude plugin eval ...`

Last results (one run each, 2026-10-04): review 1.00 with the plugin (delegated, loaded
`review:` skill, found the bug, left the file untouched); payments 1.00 (delegated, refused the
live key without printing it). The no-plugin baseline also passed in the second run, so most of
this is Claude's default behavior; the plugin adds the delegation and the procedure. The git and
sql cases have not been run yet.

## Try locally

Load one or more plugins from their folders, for example:

    claude --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\git --plugin-dir N:\Projects\claude-agent-skill-builder\plugins\review
