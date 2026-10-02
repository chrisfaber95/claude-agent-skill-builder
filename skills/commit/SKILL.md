---
name: commit
description: "Procedure for creating a Git commit with a Conventional Commits message: review changes, stage specific files, check for secrets, commit without skipping hooks. Followed by the git-workflow-manager agent; in a main session, delegate commits to that agent rather than running this directly."
argument-hint: "[optional message hint or files]"
allowed-tools: [Bash, Read, Grep]
---

Create one commit for the current changes. User hint (may be empty): $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
git-workflow-manager subagent, stop and return the proposal to the caller.

## Steps

1. Run `git status` (never with `-uall`), `git diff`, `git diff --staged` and `git log --oneline -10`.
   If nothing has changed, say so and stop. Do not create an empty commit.
2. Decide what belongs in this commit. If the changes are unrelated to each other, propose
   splitting them and ask which group to commit first.
3. Stage files by name: `git add path/a path/b`. Avoid `git add -A` or `git add .`. If you do use
   one, run `git status` afterwards and unstage anything unexpected.
4. Secret check: do not stage `.env*`, `*.pem`, `*.key`, `credentials*`, or `*secret*` files.
   Grep the staged diff for tokens and keys (`AKIA`, `ghp_`, `gho_`, `sk-`, `-----BEGIN`,
   `password=`). If anything matches, stop and show the user.
5. Write the message in Conventional Commits format:
   - `type(scope)!: summary`, where type is one of feat, fix, docs, style, refactor, perf, test,
     build, ci, chore, revert. The scope is optional, and `!` marks a breaking change.
   - Write the summary in the imperative, lower case, under 72 characters, with no trailing period.
   - Add a body only when the reason for the change is not obvious. For a breaking change, add a
     `BREAKING CHANGE: …` footer.
   - End with the Co-Authored-By trailer if the session supplies one.
6. Commit with a heredoc so the formatting survives:
   ```
   git commit -m "$(cat <<'EOF'
   feat(skills): add release skill

   Co-Authored-By: …
   EOF
   )"
   ```
7. Never pass `--no-verify`, `--no-gpg-sign` or `--amend`. If a hook fails, the commit did not
   happen. Fix the cause, re-stage, and make a new commit.
8. Run `git status` and show the commit with `git log --oneline -1`. Push (`git push`, or
   `git push -u origin HEAD` for a new branch) only if the request explicitly includes pushing.
   Never force-push.
