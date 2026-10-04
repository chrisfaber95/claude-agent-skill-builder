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

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
