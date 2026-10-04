---
name: run-tests
description: "Procedure for running Playwright tests and analyzing results: ensure the app is running, execute the test suite, collect results and failures, and report findings with artifacts."
argument-hint: "[optional: test file or pattern, browsers]"
allowed-tools: [Bash, Read, Grep, Glob]
---

Run tests and report results: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the frontend-tester
subagent, state the assumption and return the question.

## Steps

1. Preconditions:
   - `package.json`, `playwright.config.ts/js`, and the `tests/` directory exist and are readable.
   - `@playwright/test` is installed: `npm list @playwright/test`.
   - The dev server is running or will be started by the `webServer` config.
2. Check the `webServer` setting in `playwright.config.ts`:
   - If `webServer` is configured with a `command`, `npx playwright test` will start and stop the
     app automatically. Proceed to step 4.
   - If no `webServer`: check if the app is already running at the configured `baseURL` (default
     `http://localhost:3000`). Send a HEAD or GET to the `baseURL` to check. If it responds, the
     port is in use and the test will use it. If not, return the error and ask the user to start
     the dev server, or provide the command to start it.
3. If the port is not running and no `webServer` is configured, start the dev server:
   - Detect the dev command: look for `test:dev` or `dev` in `package.json` scripts. If found,
     run `npm run dev` with `--headless` or equivalent (check the script first). Use `run_in_background`
     so you control when it stops.
   - Poll the `baseURL` every 2 seconds for up to 30 seconds. Once it responds, proceed.
   - Stop only the process you started after the tests complete.
4. Run tests:
   - Default: `npx playwright test`.
   - Specific test file: `npx playwright test <file>`.
   - Specific browser(s): `npx playwright test --project=chromium --project=firefox`.
   - Use `--reporter=list` for concise output (also generates `html` report by default).
   - Capture both stdout and stderr.
5. Collect results:
   - Summary: the first line usually shows "X passed, Y failed, Z skipped".
   - Failures: list each failed test name and the first error message (assertion failure, timeout,
     element not found, navigation failed).
   - Artifacts: `test-results/` contains traces (`.zip` files), `playwright-report/` contains
     the interactive HTML report. Report artifact paths so the user can inspect them.
6. Investigate if requested:
   - A single test can be re-run with `--repeat-each=5` to check for flakiness (passes sometimes,
     fails others).
   - Open the trace: `npx playwright show-trace <path>` in a browser (local preview only).
7. Report: pass/fail/skip counts, failed test titles and their first error line (not a full
   stack trace unless the error is complex), artifact paths, and flakiness if re-run. Report
   only the first error per test; the user can read the HTML report for details.
