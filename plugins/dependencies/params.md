# dependencies parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `dependencies` section of `.claude/project-params.md`, read by
dependency-manager.

## Recommend when
- The project has a package manifest with a lockfile (`package-lock.json`, `pnpm-lock.yaml`,
  `yarn.lock`, `poetry.lock`, `composer.lock` and similar). Evidence: the files.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| packages | each package folder and its package manager | manifests and lockfiles | no |
| policy | rules before adding or upgrading | project docs (dependency policy) | no |
| install_scripts | how install scripts are reviewed | `allowScripts` or similar in the manifest, project docs | no |
| pinned_packages | packages that must not change | project docs, comments in the manifest | no |
| verification_commands | lint, test and build per package | scripts; flag placeholder scripts | no |
