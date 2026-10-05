---
name: install
description: "Install or update the chris-marketplace plugins for the current project: scan the project, pre-select only plugins with concrete evidence, let the user add or remove plugins from this marketplace by hand, turn documented project procedures into files only the relevant agents load, then write .claude/settings.json, .claude/project-params.md, .claude/procedures/ and a CLAUDE.md block after the user confirms. Run by hand with /project-setup:install."
argument-hint: "[optional: plugins to add or remove, for example +docs -playwright]"
disable-model-invocation: true
allowed-tools: [Read, Glob, Grep, Bash, Write, Edit]
---

Install or update the toolkit plugins for this project. User hint (may be empty): $ARGUMENTS

You run in the main session, so you can and must ask the user before writing anything. Only
plugins from the `chris-marketplace` marketplace are ever offered or enabled. If the user asks
for a plugin from anywhere else, say this installer only handles chris-marketplace and continue.
Never install anything at user level and never touch files outside this project, except reading
the marketplace catalog.

## 1. Find the catalog

Locate the local clone of chris-marketplace, in this order:
1. `known_marketplaces.json` in the plugins folder of the Claude config directory: use
   `$CLAUDE_CONFIG_DIR/plugins/known_marketplaces.json` if `CLAUDE_CONFIG_DIR` is set, otherwise
   `~/.claude/plugins/known_marketplaces.json`. Take `chris-marketplace.installLocation`.
2. If that fails, `gh api repos/chrisfaber95/claude-agent-skill-builder/contents/<path>` for each
   file you need (the repository is private; `gh` must be logged in).
3. If that fails, ask the user for a local path to the claude-agent-skill-builder repository.

From the catalog read `.claude-plugin/marketplace.json` (plugin names, descriptions, sources),
and for each plugin: `params.md` (when to recommend, parameters), `CLAUDE.snippet.md`, and the
agent name in `agents/*.md`. Leave `project-setup` itself out of the recommendation table; it is
the installer and is already enabled in this project.

## 2. Scan the project (read-only)

Work from the folder Claude Code was opened in (the project root). A project can hold several
packages or several git repositories in subfolders; scan them all, up to three levels deep,
skipping `node_modules`, `vendor`, `dist`, `build`, `.git` and hidden folders other than
`.github` and `.claude`.

Collect, with the file each fact came from:
- package manifests and lockfiles (`package.json`, `pyproject.toml`, `requirements.txt`,
  `composer.json`, `go.mod`, `pom.xml`), dependencies and their versions, and scripts
- whether each `test` script runs tests or is a placeholder
- `tsconfig.json`, framework config files, `playwright.config.*`, `cypress.config.*`
- source file types (`.vue`, `.tsx`, `.svelte`, `.sql`) and folders such as `migrations/`
- CI files and job names, Dockerfiles, compose files
- git repositories (folders with `.git`), their remotes and default branch
  (`git -C <folder> remote -v`, `git -C <folder> symbolic-ref refs/remotes/origin/HEAD`)
- project documents: `README.md`, `ARCHITECTURE.md`, `docs/`, `CLAUDE.md`, any `WORKFLOW.md`
- what is already set up: `.claude/settings.json` (enabled plugins), `.claude/project-params.md`,
  an existing project-setup block in `CLAUDE.md`, and agent files in `.claude/agents/`

Never print secrets: read `.env.example` for variable names, never the values in `.env` files.

## 3. Recommend

Apply each plugin's "Recommend when" rules from its `params.md`. A plugin is pre-selected only
when its rule matches concrete evidence in this project; no plugin is selected because it is
generally useful. Show one numbered table with every chris-marketplace plugin:

| # | Plugin | Agent | Selected | Why |
|---|---|---|---|---|
| 1 | frontend | frontend-developer | [x] | `vue@2.6` in Klant/Client/package.json |
| 2 | playwright | frontend-tester | [ ] | project uses Cypress for e2e (Klant/Client/cypress.config.js) |

For unselected plugins, "Why" says what evidence is missing, or "no evidence" with the one-line
description. Mark plugins already enabled in this project. Apply the user hint from the arguments
(`+name` adds, `-name` removes).

## 4. Confirm the selection

Ask with AskUserQuestion: "Use this selection?" with the options "Use this selection",
"Change it" (the user types changes such as `+docs -playwright` or numbers) and "Cancel". Apply
changes and show the table again until the user accepts or cancels. On cancel, stop without
writing anything.

## 5. Fill the parameters

For each selected plugin, fill every key in its `params.md` "Parameters" table from the scan,
noting the source of each value (`from Klant/Client/package.json`). Do not invent values: when a
key cannot be detected, use the table's default if it gives one, otherwise `unknown` with what to
fill in. Ask the user only for keys marked "Ask if unknown: yes" that could not be detected,
batched into one AskUserQuestion call (at most four questions; ask the most important first and
leave the rest `unknown`).

## 6. Project procedures (optional)

Turn procedures the project already documents into files that only the relevant agents load.
Never invent a procedure: every step must come from a project document.

1. Find candidate sources: documents imported or referenced from `CLAUDE.md` (for example
   `@docs/WORKFLOW.md` and the files it points to), `CONTRIBUTING.md`, `RELEASING.md`, runbooks,
   and `docs/**/*.md` or README sections written as instructions (numbered steps, "how to",
   "before creating a PR", "release", "migrations", "test locally"). Skip descriptions, history
   and anything that only restates generic practice without project-specific commands, paths,
   names or rules.
2. For each candidate, decide which selected plugin agents it is for, by topic: testing steps to
   `test-automator` (and `frontend-tester` for end-to-end parts), commit, branch, PR, CI and merge
   steps to `git-workflow-manager`, documentation and per-change records to
   `documentation-engineer`, dependency rules to `dependency-manager`, migration and database
   steps to `sql-pro`, and so on. Only agents of selected plugins qualify. One procedure can be
   for several agents.
3. Show a table: number, proposed file name, source document, for which agents, and a one-line
   summary. Ask with AskUserQuestion: "Create these procedures?" with the options "Create all",
   "Choose" (the user types numbers to keep, or reassigns agents, for example `2 -> sql-pro`) and
   "Skip procedures".
4. For each confirmed procedure, prepare `.claude/procedures/<short-name>.md`:
   ```
   # <Title>

   For: <agent names>. Only agents that list this file in their section of
   .claude/project-params.md load it.
   Source: <path> (sha256 <first 12 hex characters>), generated <YYYY-MM-DD> by /project-setup:install

   ## When this applies
   <one or two lines from the source>

   ## Steps
   1. <condensed from the source, keeping the project's own commands, paths and names>

   ## Rules from the source
   - <project rules stated in the source that these agents must follow>
   ```
   Compute the hash with `sha256sum <path> | cut -c1-12` (Git Bash, Linux; `shasum -a 256` on
   macOS; in PowerShell `(Get-FileHash <path> -Algorithm SHA256).Hash.Substring(0,12).ToLower()`).
   Condense, but do not add steps, commands or rules that are not in the source. Keep each file
   short; split a long source into several procedures by topic.
5. Add the procedure paths to the `procedures` key in the section of each agent it is for, for
   example `- procedures: .claude/procedures/test-locally.md, .claude/procedures/revision-docs.md`.
   Procedures are never added to the `CLAUDE.md` block; the main session does not load them.

On a re-run: keep a procedure file whose recorded hash still matches its source. If the source
changed, show what changed and ask before regenerating it (say that manual edits to the file will
be replaced). If a source no longer exists, ask before removing the file and its `procedures`
entries. Never overwrite or delete a procedure file without asking.

## 7. Check for conflicts

If `.claude/agents/` contains a file whose agent name equals a selected plugin's agent (for
example `code-reviewer.md` while `review` is selected), it can shadow the plugin agent. List
these and ask whether to move them to `.claude/agents-archive/` (keeping the file names). Never
delete them. If the user declines, leave them and say the old project agent may be used instead
of the plugin agent.

## 8. Preview and write

Show what will change in each file, then ask "Write these changes?" (Yes / No). Only after yes:

**`.claude/settings.json`**: read it if it exists and keep every other key. Set
`extraKnownMarketplaces.chris-marketplace` to
`{ "source": { "source": "github", "repo": "chrisfaber95/claude-agent-skill-builder" } }`. In
`enabledPlugins`, set `"<plugin>@chris-marketplace": true` for each selected plugin, and `false`
for chris-marketplace plugins that were enabled before but are now deselected. Do not add entries
for plugins that were never selected, and never change entries for other marketplaces. Leave
`project-setup@chris-marketplace` exactly as it is: never set it to `false`, and if it is not in
this file (the installer was enabled another way), do not add it. Write
valid JSON with two-space indentation.

**`.claude/project-params.md`**: create it if missing, starting with:
```
# Project parameters

Generated by /project-setup:install and read by the toolkit agents. Edit values freely; a re-run
keeps your edits. Values marked unknown should be filled in.
```
then one section per selected plugin:
```
<!-- params:<plugin> -->
## <plugin> (<agent>)
- <key>: <value> (<source>)
<!-- /params:<plugin> -->
```
On a re-run: keep existing values exactly as they are (the user may have edited them) and only
fill keys that are missing or `unknown` if the scan now finds them; add sections for newly
selected plugins; for deselected plugins, ask before removing their section.

**`CLAUDE.md`**: create it if missing. Put one block between the markers below, replacing any
previous block; never change anything outside the markers:
```
<!-- project-setup:start -->
## Toolkit agents

Project parameters for the agents: @.claude/project-params.md

<the CLAUDE.snippet.md of each selected plugin, in table order, each without its final
"Handoffs:" paragraph>

<the "Handoffs:" paragraph, once>
<!-- project-setup:end -->
```
Every snippet ends with the same "Handoffs:" paragraph; include it only once so the block stays
short.

**`.claude/procedures/*.md`**: the confirmed procedure files from step 6, and their paths in
the `procedures` key of each agent's section.

**Conflicting agents**: move the confirmed files to `.claude/agents-archive/`.

## 9. Finish

Report: the plugins enabled and disabled, files created or changed, procedures created and which
agents load them, conflicts handled, parameters still `unknown`, and the next step: restart Claude Code in this folder (or run `/plugin`) and
accept the chris-marketplace trust prompt so the plugins install; the repository is private, so
this device needs `gh auth login` or a git credential. Say that the installer stays enabled in
this project, so re-running `/project-setup:install` updates the setup and keeps edited
parameters, and that the user can remove it with `/plugin` if they do not want it there.
