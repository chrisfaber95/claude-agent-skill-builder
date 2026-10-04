# frontend parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `frontend` section of `.claude/project-params.md`, read by
frontend-developer.

## Recommend when
- A package depends on `vue`, `react`, `@angular/core`, `svelte`, `solid-js`, `preact`, `next`
  or `nuxt`, or the source contains `.vue`, `.svelte`, `.jsx` or `.tsx` files. Evidence: the
  manifest line or a file path.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| package_folder | where to run commands | folder of the manifest with the framework dependency | no |
| framework | idioms and version-specific features | dependency and its version | no |
| build_tool | dev server and build | `vite`, `@vue/cli-service`, `webpack`, `next`, `@angular/cli` | no |
| dev_command_and_url | starting the app | `serve`/`dev`/`start` script; port from config or script | no |
| styling | how to style components | `tailwindcss`, `bootstrap`, `bootstrap-vue`, `sass`, CSS modules, styled-components | no |
| state_and_data | state and data libraries in use | `vuex`, `pinia`, `redux`, `@tanstack/*`, `axios`, `swr` | no |
| component_layout | where components go and how they are named | folder structure under `src/` | no |
| unit_test_runner | component tests | `vitest`, `jest`, `@vue/test-utils`, `@testing-library/*`, `karma`; script name | no |
| lint_and_typecheck | verification commands | `lint`, `typecheck` scripts | no |
| browser_support | supported browsers | `browserslist` in manifest or `.browserslistrc` | no |
| testid_convention | `data-testid` naming | existing `data-testid` values in source | no |
| accessibility_target | target level for reviews | project docs | no, default WCAG 2.2 AA |
| forbidden_dependencies | packages that must not be added | project docs | no |
