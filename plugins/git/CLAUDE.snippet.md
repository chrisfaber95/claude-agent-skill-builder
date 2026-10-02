## Git

Delegate every git and GitHub operation (commit, push, branch, PR, CI check, merge, branch
cleanup, release, merge/rebase conflicts, git setup) to the `git-workflow-manager` agent from the
`git` plugin. Do not run these yourself. Project-specific git rules live in `WORKFLOW.md`,
if present; the agent reads it.

In every delegation prompt, include:
- which actions are authorized: "commit", "push", "PR", "merge", "cleanup", "release",
  "continue the rebase" (anything not listed is returned as a proposal)
- the Co-Authored-By trailer and PR attribution line for this session, if any
- for a PR: why the change exists, architecture decisions, exactly which tests and checks were
  run, how it was manually validated, known limitations, and the revision id and name if one is
  used. The agent writes "Not provided" for anything missing and never invents test results.

If the agent returns "Needs approval", show the drafts to the user. Once the user approves,
delegate again with that action authorized.

Final report after each piece of work (you write it, the agent only supplies the git facts):
what was implemented and why, tests run, CI status, PR number, merge status, limitations and
follow-ups. Keep it concise, then ask the user whether the implementation is correct and whether
to move on to the next planned item.
