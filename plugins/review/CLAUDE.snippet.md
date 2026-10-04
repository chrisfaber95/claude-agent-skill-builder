## Code review

Before committing or merging, delegate a review of the change to the `code-reviewer` agent from
the `review` plugin. In the delegation prompt, include:
- what to review: the working-tree diff, a branch against its base, a PR number, or named files
- what the change is meant to do
- whether it should also do a security-focused pass (it does for anything touching auth, input,
  data access, secrets, files or payments)

The agent is read-only: it reports findings ranked by severity with file and line, and never
edits code. You (or another agent you choose) make the fixes. It works on its own; if it lists
follow-ups needing a specialist, you decide who handles them.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
