# typescript parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `typescript` section of `.claude/project-params.md`, read by
typescript-pro.

## Recommend when
- A package has a `tsconfig.json` or depends on `typescript`, with `.ts`/`.tsx` source files.
  Evidence: the file path. A plain JavaScript project is not recommended (only a planned
  migration would justify it, and the user can add it by hand).

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| package_folders | where TypeScript is used | folders with `tsconfig.json` | no |
| typescript_version | available language features | `typescript` version | no |
| strictness | flags in force | `strict`, `noImplicitAny`, `strictNullChecks`, `noUncheckedIndexedAccess` in `tsconfig` | no |
| typecheck_command | verification | `typecheck` script, else `npx tsc --noEmit` | no |
| validation_library | runtime validation at boundaries | `zod`, `valibot`, `io-ts`, `yup` | no |
