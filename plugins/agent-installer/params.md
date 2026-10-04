# agent-installer parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `agent-installer` section of `.claude/project-params.md`, read by
agent-installer.

## Recommend when
- Never pre-selected. The user adds it by hand when they want to browse and vet community agents.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| default_destination | where installed agents go | not detectable | no, default `.claude/agents/` (local) |
