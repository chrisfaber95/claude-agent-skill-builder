# CI, Merge, After Merge and Final Report

Part of the [revision workflow](../WORKFLOW.md).

### Step 11 — CI verification

After creating the PR, inspect GitHub Actions and other required checks. Use GitHub CLI where possible: `gh pr checks <PR>` (add `--watch` for asynchronous CI checks).

Do not assume that a successful local test run means GitHub CI has passed.

CI is defined in `.github/workflows/ci.yml` (one job per package: ServerNest, Klant, Employees). Wait for it with `gh pr checks <PR> --watch`. A job that is pending, failed, cancelled or missing counts as not passed.

The repository is private on a plan without branch protection, so GitHub does **not** block a merge for you. This rule is the only gate: run `gh pr checks <PR>` immediately before merging and merge only when every check is `pass`. When you add or change a check, update the workflow in the same revision.

The Pull Request must be checked.

### Step 12 — Merge policy

A Pull Request may be merged automatically ONLY when:

- Every CI check shows `pass` in `gh pr checks` (not pending, not skipped).
- The branch is mergeable.
- There are no unresolved merge conflicts.
- The revision is complete.
- The revision documentation is present locally in `docs/revisions/`.
- The PR description is complete.
- No required review is still outstanding.
- No required GitHub status check is failing.

When all required conditions are satisfied, merge the Pull Request. Prefer squash merging unless repository configuration explicitly specifies another strategy: `gh pr merge <PR> --squash --delete-branch`.

Do NOT use `gh pr merge --admin` to bypass failed checks, branch protection, or review requirements. Never bypass repository safety controls merely to get the revision merged.

#### Stacked PRs

Avoid them. When a revision genuinely depends on an unmerged one:

- Open the child PR with `--base <parent-branch>`, and say so at the top of its description.
- Merge the parent first. Do not use `--delete-branch` on the parent while the child still targets it (GitHub would close the child). Instead merge the parent, run `gh pr edit <child> --base main`, rebase the child on `origin/main`, push, wait for CI again, then merge the child and delete both branches.
- Never merge a child into its parent branch and call that "merged".

### Step 13 — After merge

After the PR is merged:

- Verify that the merge succeeded.
- Verify that the revision exists on main.
- Verify that the local revision document exists.
- Verify that the local REVISION_SUMMARY.md contains the revision.
- Delete the merged `feature/*` branch locally and on GitHub (`gh pr merge --delete-branch` does the remote one; use `git branch -D` for the local one). You may delete any `feature/*` branch whose PR is merged and whose local tip matches `origin`; check with `git rev-parse` first. Never delete `main`, an unmerged branch, or a branch with unpushed commits. `.claude/settings.local.json` allows these commands for `feature/*` only.
- Update the local main branch.
- Use the merged state as the starting point for the next revision.

Never begin the next revision from an outdated branch.

## Final Response After Each Revision

After completing a revision, report:

- Revision number
- Revision title
- What was implemented
- Why it was implemented
- Tests run
- CI status
- PR number
- Merge status
- Any limitations or follow-up work
- Ask user if the implementation is correct and you can move on to the next revision planned

Keep this summary concise.

The canonical detailed history belongs in docs/revisions/.
