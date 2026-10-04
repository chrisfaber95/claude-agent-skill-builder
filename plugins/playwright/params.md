# playwright parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `playwright` section of `.claude/project-params.md`, read by
frontend-tester.

## Recommend when
- A package depends on `@playwright/test` or has a `playwright.config.*`. Evidence: that file or
  manifest line.
- Or a frontend app is detected (see the frontend plugin's evidence) and the project has no other
  end-to-end framework. If it already uses `cypress`, `webdriverio`, `nightwatch` or
  `testcafe`, do not pre-select; list it unselected with "project uses <framework> for e2e".

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| package_folder | where tests and config live | folder of the frontend app | no |
| app_url | base URL for tests | dev server port in config or scripts | no |
| dev_command | starting the app for tests | `serve`/`dev`/`start` script | no |
| test_dir | where e2e tests go | `testDir` in config, else `tests/e2e` | no |
| browsers | browser projects to run | `projects` in config, else chromium | no |
| backend_needed | services the app needs during tests | API base URL in env examples or config | no |
| test_accounts | how tests log in (env var names only, never values) | `.env.example` names | no |
| staging_url | the only non-local URL tests may use | not detectable | no, leave empty (localhost only) |
