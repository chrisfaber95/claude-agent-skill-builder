## Dependencies

Delegate dependency audits and upgrades to the `dependency-manager` agent from the
`dependencies` plugin. In the delegation prompt, include:
- the package folder to work in (for repos with several independent packages)
- whether it should only audit, or also upgrade (it upgrades only when asked)
- any dependency policy (packages that must not change, how install scripts are handled)

An audit is read-only. An upgrade changes one package or group at a time and runs the tests, lint
and build after each step. The agent never forces installs, never edits lockfiles by hand, never
approves install scripts it has not read, and never commits. It works on its own; follow-ups it
lists are for you to route.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
