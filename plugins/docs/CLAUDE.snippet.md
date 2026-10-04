## Documentation

Delegate documentation work (README, guides, API reference, architecture overview, and updating
docs after a change) to the `documentation-engineer` agent from the `docs` plugin. In the
delegation prompt, include:
- what to document, or what changed (a diff or branch)
- the audience, and where the project keeps its docs
- any per-change documents the project requires (the agent follows the rules in `CLAUDE.md` and
  `WORKFLOW.md`)

The agent changes documentation files only, verifies commands and examples by running them when
that is safe and local, and reports mismatches between code and docs instead of changing code. It
works on its own; follow-ups it lists are for you to route.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
