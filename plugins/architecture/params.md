# architecture parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `architecture` section of `.claude/project-params.md`, read by
architect-reviewer.

## Recommend when
- The project documents its architecture or architecture rules (`ARCHITECTURE.md`, `docs/adr/`,
  `docs/decisions/`, architecture rules referenced from CLAUDE.md). Evidence: the file.
- Having several packages alone is not enough; then list it unselected with "no documented
  architecture to review against".

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| architecture_doc | the current architecture | `ARCHITECTURE.md`, docs | no |
| architecture_rules | rules reviews are held to | rules documents referenced from CLAUDE.md | no |
| decisions_folder | where decision records go | `docs/adr/`, `docs/decisions/` | no |
| components | packages or repositories and what each owns | manifests and folder layout | no |
| performance_targets | numbers designs must meet (users, data volume, latency) | project docs | no |
