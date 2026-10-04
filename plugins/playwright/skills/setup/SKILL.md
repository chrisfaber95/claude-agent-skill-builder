---
name: setup
description: "Procedure for setting up Playwright Test: detect package manager, install @playwright/test and browsers, create playwright.config.ts with webServer and trace settings, add npm scripts, and set up .gitignore."
allowed-tools: [Bash, Read, Write, Edit, Glob]
---

Set up Playwright Test for this project.

## Steps

1. Preconditions:
   - `package.json` exists and is readable.
   - Node.js and npm (or pnpm, yarn) are available.
   - Detect the package manager from the root: `package-lock.json` = npm, `pnpm-lock.yaml` = pnpm,
     `yarn.lock` = yarn. If multiple lockfiles exist, prefer npm (most common).
2. Check if Playwright is already installed: `npm list @playwright/test` (or equivalent). If it
   is, report the version and stop; the agent can use the existing setup.
3. Install:
   - `npm i -D @playwright/test` (or `pnpm add -D` / `yarn add -D`).
   - `npx playwright install chromium` (Chromium is the default; the agent can request other
     browsers in future runs). On Linux, this command requires no special permissions for a
     project-local install.
4. Create `playwright.config.ts` (TypeScript preferred; fall back to `.js` if `tsconfig.json`
   is missing):
   ```typescript
   import { defineConfig, devices } from '@playwright/test';
   
   export default defineConfig({
     testDir: './tests',
     fullyParallel: true,
     forbidOnly: !!process.env.CI,
     retries: process.env.CI ? 2 : 0,
     workers: process.env.CI ? 1 : undefined,
     reporter: 'html',
     use: {
       baseURL: process.env.BASE_URL || 'http://localhost:3000',
       trace: 'on-first-retry',
     },
     projects: [
       { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
       { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
       { name: 'webkit', use: { ...devices['Desktop Safari'] } },
     ],
     webServer: {
       command: 'npm run dev',
       url: 'http://localhost:3000',
       reuseExistingServer: !process.env.CI,
     },
   });
   ```
   Adjust `testDir`, `baseURL` and `webServer.url`/`command` to match the project. If the app is
   not started by npm (e.g., `python manage.py runserver`, `go run .`), provide the exact command.
5. Create `tests/` directory if it does not exist.
6. Add npm scripts to `package.json`:
   - `"test:e2e": "playwright test"`
   - `"test:e2e:ui": "playwright test --ui"` (optional, for local development)
7. Update `.gitignore`:
   ```
   /test-results/
   /playwright-report/
   /blob-report/
   /playwright/.cache/
   ```
8. Initialize the framework: `mkdir -p tests` and optionally create a `tests/example.spec.ts`
   with a passing test to verify setup. Delete this file after confirmation, or leave it as a
   template.
9. Report: files created, commands run, whether the setup was verified by running one test, and
   any changes to `package.json` (the agent does not commit; whoever handles git does).
