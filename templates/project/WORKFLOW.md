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
