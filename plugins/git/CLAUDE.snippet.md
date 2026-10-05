## Git

Delegate every git and GitHub operation (commit, push, branch, PR, CI check, merge, branch
cleanup, release, merge/rebase conflicts, git setup) to the `git-workflow-manager` agent from the
`git` plugin. Do not run these yourself. Project-specific git rules live in the `git` section
of `.claude/project-params.md`; the agent reads it.

Commit, push, PR and merge are pre-authorized for git work: do not ask the user before
delegating them. When a piece of work is finished, delegate "commit, push, open the PR and merge
it"; the agent merges only once CI and every merge gate pass. If the `git` section of
`.claude/project-params.md` sets `merge_mode: ask`, PRs are still opened without asking, but ask
the user before delegating a merge.

In every delegation prompt, include:
- any restriction on those defaults ("commit only", "no push", "don't merge") and any extra
  action the user authorized: "cleanup", "release", "continue the rebase" (anything else is
  returned as a proposal)
- the Co-Authored-By trailer and PR attribution line for this session, if any
- for a PR: why the change exists, architecture decisions, exactly which tests and checks were
  run, how it was manually validated, known limitations, and the revision id and name if one is
  used. The agent writes "Not provided" for anything missing and never invents test results.

If the agent returns "Needs approval" (a failed gate, red or pending CI, possible secrets, an
action outside the defaults), show the drafts to the user. Once the user approves, delegate again
with that action authorized.

Final report after each piece of work (you write it, the agent only supplies the git facts):
what was implemented and why, tests run, CI status, PR number, merge status, limitations and
follow-ups. Keep it concise, then ask the user whether the implementation is correct and whether
to move on to the next planned item.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
