## API design

Delegate API design (new or changed endpoints, OpenAPI specs, compatibility checks) to the
`api-designer` agent from the `api` plugin, before implementing. In the delegation prompt,
include:
- the feature or endpoint, and who calls it
- the existing API conventions or spec file to match
- constraints: auth scheme, versioning rules, anything that must not break

The agent designs and specifies; it does not implement handlers unless you ask. It works on its
own; if it lists follow-ups (database, backend, tests, client), you decide who does them.
