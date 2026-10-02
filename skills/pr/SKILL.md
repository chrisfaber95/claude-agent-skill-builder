---
name: pr
description: "Procedure for opening a GitHub pull request for the current branch with gh: Conventional Commits title, summary drawn from every commit on the branch, and a test plan. Followed by the git-workflow-manager agent; in a main session, delegate PRs to that agent rather than running this directly."
argument-hint: "[base branch, default: repo default branch]"
allowed-tools: [Bash, Read, Grep]
---

Open a pull request for the current branch. Base branch (may be empty): $ARGUMENTS

Confirmation: in a main session, ask the user before pushing or creating the PR. When running as
the git-workflow-manager subagent, push or create the PR only if the delegation prompt authorized
it ("push", "open the PR"). Otherwise stop after drafting and return the title, the body and the
exact commands.

## Steps

1. Run these checks:
   - `gh auth status`. If gh is not authenticated, stop.
   - The base is `$ARGUMENTS` if given, otherwise
     `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
   - If the current branch is the base, offer to create a `feat/…` or `fix/…` branch first.
   - `git status`: if there are uncommitted changes, ask whether to commit them first with the
     `commit` skill or leave them out.
   - `gh pr view --json url` succeeds: a PR already exists. Show its URL and stop.
2. Read the whole branch, not just the last commit:
   - `git fetch origin <base>`
   - `git log origin/<base>..HEAD --format='%h %s%n%b'`
   - `git diff origin/<base>...HEAD --stat`, plus the full diff where you need detail
3. Draft the PR:
   - Title: a Conventional Commits summary under 70 characters. It is usually the dominant
     commit type, for example `feat(skills): add git workflow skills`.
   - Body:
     ```
     ## Summary
     - 1-3 bullets on what changed and why

     ## Test plan
     - [ ] concrete steps to verify
     ```
     End the body with the session's PR attribution line if one is supplied.
4. Show the title and body, and say whether a push is needed. Ask for confirmation.
5. After the user confirms:
   - If there is no upstream or the branch is ahead, run `git push -u origin HEAD`.
     Never force-push.
   - Create the PR with a heredoc:
     ```
     gh pr create --base <base> --title "<title>" --body "$(cat <<'EOF'
     ...
     EOF
     )"
     ```
6. Return the PR URL.
