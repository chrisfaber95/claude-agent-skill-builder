---
name: release
description: "Cut a semver release: derive the version bump from Conventional Commits since the last tag, update the version file and CHANGELOG.md, commit, tag, and push after confirmation."
argument-hint: "[major|minor|patch]"
disable-model-invocation: true
allowed-tools: [Bash, Read, Edit, Grep, Glob]
---

Cut a release. Requested bump (may be empty): $ARGUMENTS

## Steps

1. Preconditions: run `git status` (the tree must be clean), be on the default branch, and run
   `git fetch --tags` and `git status -sb` (the branch must not be behind its remote). If a check
   fails, stop and report it.
2. Find the last tag with `git describe --tags --abbrev=0`. If there is none, use all history and
   take the current version from the version file.
3. Find the version file. Check these in order and use the first that exists:
   `.claude-plugin/plugin.json`, `package.json`, `pyproject.toml`, `Cargo.toml`, `VERSION`.
   If there is none, ask the user.
4. List the commits since the last tag with `git log <tag>..HEAD --format='%h %s%n%b'`. If there
   are none, stop.
5. Choose the bump. If `$ARGUMENTS` is major, minor or patch, use it. Otherwise:
   - `!` after the type, or a `BREAKING CHANGE:` footer: major (minor while the version is 0.x)
   - any `feat`: minor
   - anything else: patch
6. Update the version in the version file. If `package.json` has a lockfile, run the package
   manager's version command instead, so the lockfile stays in sync.
7. Prepend a section to `CHANGELOG.md` (create the file if it is missing):
   ```
   ## vX.Y.Z - YYYY-MM-DD
   ### Breaking changes
   ### Features
   ### Fixes
   ### Other
   ```
   Use one bullet per commit (`summary (shorthash)`) and drop empty headings.
8. Show the user the new version, the changelog section and the diff, then ask for confirmation.
9. After the user confirms:
   - `git add <version file> CHANGELOG.md [lockfile]`
   - `git commit -m "chore(release): vX.Y.Z"` (plus the session's Co-Authored-By trailer)
   - `git tag -a vX.Y.Z -m "vX.Y.Z"`
   - `git push --follow-tags`
10. If `gh` is available, offer to run `gh release create vX.Y.Z --notes-file -` with the
    changelog section. Do not run it unless the user agrees.

Never move or delete an existing tag, and never force-push.
