# claude-agent-skill-builder

Central repo for my personal Claude Code skills and agents. It is a plugin (`my-toolkit`) and a marketplace (`chris-marketplace`) in one.

## Layout

- `skills/<name>/SKILL.md` - global skills (invoked as `/my-toolkit:<name>`)
- `agents/<name>.md` - global subagents
- `.claude-plugin/plugin.json` - plugin manifest
- `.claude-plugin/marketplace.json` - lets projects install this repo by name
- `templates/project/.claude/settings.json` - copy into each project

## Use in a project

1. This repo lives at github.com/chrisfaber95/claude-agent-skill-builder (private; each device needs `gh auth login` or a git credential).
2. Copy `templates/project/.claude/settings.json` into the project's `.claude/` and commit it.
3. On any device, open the project in Claude Code and accept the marketplace/plugin prompt.
4. Project-specific skills/agents go in the project's own `.claude/skills/` and `.claude/agents/` and are committed with that project.

## Update

Edit here, bump `version` in `plugin.json`, push. In a project run `/plugin marketplace update` (or restart) to pull the new version.

## Try locally

    claude --plugin-dir N:\Projects\claude-agent-skill-builder
