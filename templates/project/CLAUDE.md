## Git

Delegate every git and GitHub operation (commit, push, branch, PR, release, merge/rebase
conflicts, git setup) to the `git-workflow-manager` agent from the my-toolkit plugin. Do not run
these yourself. In the delegation prompt, include:
- which actions are authorized ("commit only", "commit and push", "open the PR", "release",
  "continue the rebase")
- the Co-Authored-By trailer and PR attribution line for this session, if any

If the agent returns "Needs approval", show the drafts to the user. Once the user approves,
delegate again with that action authorized.
