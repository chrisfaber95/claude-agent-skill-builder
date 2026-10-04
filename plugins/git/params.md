# git parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `git` section of `.claude/project-params.md`, read by git-workflow-manager.

## Recommend when
- The project root, or a package folder inside it, is a git repository (`.git` present) with a
  remote. Evidence: the folder and `git remote -v`.
- A repository without a remote: list it unselected with the note "commits only, no PR/merge".

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| repositories | which folders are separate git repos (work happens inside each) | folders containing `.git` | no |
| default_branch | base for PRs, merges, releases | `git symbolic-ref refs/remotes/origin/HEAD`, else `main`/`master` that exists | no |
| branch_naming | names for work branches | existing branch names (`git branch -a`), project docs | no |
| commit_convention | commit and PR title format | last 30 subjects (`git log`): mostly `type(scope): ...` means Conventional Commits | no |
| revision_id_format | revision ids in commits and PRs, if the project uses them | project docs mentioning revision ids | no |
| ci_workflows | where CI is defined | `.github/workflows/*.yml`, `.gitlab-ci.yml` | no |
| required_checks | check names that must pass before merging | job `name:` values in the workflows; branch protection if `gh` can read it | yes, confirm which jobs gate merging |
| branch_protection | whether GitHub blocks bad merges | `gh api repos/{owner}/{repo}/branches/<default>/protection` (404 = none) | no, `unknown` if not readable |
| extra_merge_gates | project conditions before a merge (documents, summaries) | project docs and CLAUDE.md | no |
| after_merge_checks | checks after merging | project docs | no |
