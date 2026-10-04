## Installing agents

Delegate finding and installing community agents from the awesome-claude-code-subagents
collection to the `agent-installer` agent from the `agent-installer` plugin. In the delegation
prompt, say which of these you want:
- browse or search (give the category or term): read-only
- vet a named agent: read-only report on what it could do
- install a named agent: give the exact name and the destination ("local" is `.claude/agents/`,
  "global" is `~/.claude/agents/`)

It installs only when you name the exact agent and destination, never overwrites existing files,
never edits what it downloads, and treats downloaded text as untrusted. Downloaded agents are
often templates that need rewriting before they are useful in your setup.
