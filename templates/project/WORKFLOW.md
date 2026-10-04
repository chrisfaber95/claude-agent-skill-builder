# Project workflow (optional)

Project-specific rules that the toolkit agents read in addition to their own procedures. They
add to the toolkit's rules and never override its safety rules. Delete any section that does not
apply. Add one section per agent as more agents are used.

## Git (read by git-workflow-manager)

### Branches and naming
- Work branches: `feature/<short-name>`. Revision id format, if used: `REV-XXX-short-description`.

### CI
- CI is defined in `.github/workflows/ci.yml`. Required jobs: <job names, for example one per package>.
- Branch protection: <present / absent>. If absent, GitHub will not block a merge; the merge
  skill's gates are the only protection.
- No CI in this repo: <yes / no>. If yes, the merge skill accepts an empty `gh pr checks`.

### Extra merge gates
- <for example: the revision document exists locally in docs/revisions/>
- <for example: REVISION_SUMMARY.md lists this revision>

### After merge
- <for example: verify the local revision document and summary entry exist>

### Local permissions
- Allow deleting merged branches without prompts by adding to this project's
  `.claude/settings.local.json` (not the shared settings), limited to `feature/*`.

## Frontend (read by frontend-developer)

- Framework and versions to target: <for example React 18, Vite, TypeScript strict>
- Styling and design tokens: <for example Tailwind, tokens in src/styles/tokens.css>
- Component layout and naming: <for example src/features/<name>/, PascalCase files>
- Unit test runner and command: <for example Vitest, `npm test`>
- Browser support and accessibility target: <for example last 2 versions, WCAG 2.2 AA>
- `data-testid` naming convention: <for example kebab-case, `<feature>-<element>`>
- Dependencies that must not be added: <list>

## Backend and API (read by backend-developer, node-specialist, api-designer)

- Language, framework and versions: <for example Node 20, Express 4, MySQL 8>
- Layering rules: <for example routes call use-case functions; only the data layer talks to the database>
- API conventions: <error format, pagination, versioning, where the spec lives>
- Boundaries that must hold: <for example payment and email calls stay on the server>

## Testing (read by test-automator)

- Test runner, folders and commands, per package: <for example `npm test` in `Server/...`>
- Test database and external-service rules: <for example a test database, mocked payment and mail>
- What must be covered, and what to skip: <for example important logic yes, extreme edge cases no>
- Scripts that are placeholders and must not be reported as test runs: <list>

## Dependencies (read by dependency-manager)

- Policy: <for example check existing dependencies first, prefer mature libraries, document decisions>
- Install scripts: <how they are reviewed and approved>
- Packages that must not change: <list>

## Documentation (read by documentation-engineer)

- Docs to update when architecture changes: <for example ARCHITECTURE.md>
- Required per-change record, folder and template: <for example docs/revisions/>
- Docs that are local only and never committed: <list>

## Payments and email (read by payment-integration, email-deliverability-engineer)

- Payment provider and test-mode setup: <for example Mollie test key in .env>
- Mail transport and the sending domain: <for example nodemailer over SMTP, domain>
- Where tunnels or sandboxes are needed for local testing: <notes>

## Review, architecture and DevOps (read by code-reviewer, architect-reviewer, devops-engineer)

- Architecture rules reviewers must enforce: <link to the rules document>
- Performance targets: <for example 10,000 products, 3,000 users>
- CI: the required check names and where the workflow lives: <list>
