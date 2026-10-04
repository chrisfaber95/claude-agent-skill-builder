# docs parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `docs` section of `.claude/project-params.md`, read by
documentation-engineer.

## Recommend when
- The project keeps documentation: a `README.md` with real content, an `ARCHITECTURE.md`, a
  `docs/` folder, or documentation rules in CLAUDE.md. Evidence: the files.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| doc_locations | where docs live | `README.md`, `docs/`, `ARCHITECTURE.md` | no |
| update_rules | which docs change with which kind of change | project docs and CLAUDE.md | no |
| per_change_records | required record per change, folder and template | project docs (for example a revisions folder) | no |
| local_only_docs | docs that are never committed | project docs, `.gitignore`, docs outside any repo | no |
| audience | who reads the docs | README content | no |
