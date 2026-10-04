# review parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `review` section of `.claude/project-params.md`, read by code-reviewer.

## Recommend when
- The project contains source code under version control (a package manifest or source files,
  and a git repository). Evidence: the manifest and `.git`.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| review_rules | rules a review enforces | rules documents referenced from CLAUDE.md, contribution guides | no |
| checks_per_package | lint, test and build commands the reviewer may run | scripts per manifest; flag placeholder scripts | no |
| sensitive_areas | code that always gets a security pass | folders or files for auth, payments, uploads, admin | no |
| base_branch | what a branch is compared against | default branch | no |
