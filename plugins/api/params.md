# api parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `api` section of `.claude/project-params.md`, read by api-designer.

## Recommend when
- An API specification exists (`openapi.*`, `swagger.*`, `*.graphql` schema). Evidence: the file.
- Or a backend serves an API to a client that lives in a separate package or repository of the
  same project (for example a server package and a client package). Evidence: both manifests.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| spec_location | where the contract lives | spec files | no |
| consumers | who calls the API | client packages, docs | no |
| base_path_and_versioning | URL scheme | route prefixes in code (`/api`, `/v1`) | no |
| error_format | error response shape | existing error handler | no |
| pagination | how lists are paged | existing list endpoints | no |
| auth_scheme | how callers authenticate | auth middleware and dependencies | no |
| spec_validator | how specs are checked | a validator in scripts or dependencies | no |
