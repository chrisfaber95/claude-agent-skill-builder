# backend parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `backend` section of `.claude/project-params.md`, read by
backend-developer.

## Recommend when
- A package depends on a server framework: `express`, `fastify`, `koa`, `@hapi/hapi`,
  `@nestjs/core`, `hono`, `restify`; or a Python, Go, Java or PHP web framework in its manifest
  (`django`, `flask`, `fastapi`, `gin`, `spring-boot`, `laravel/framework`). Evidence: the
  manifest line.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| package_folder | where to run commands | folder of the manifest with the framework | no |
| framework | idioms and middleware | dependency and version | no |
| entry_point_and_start | starting the server locally | `main`, `start`/`dev` scripts | no |
| layering | where routes, logic and data access go | folder structure; project architecture rules | no |
| validation_and_auth | existing validation and auth middleware | dependencies (`joi`, `zod`, `express-validator`, `passport`, `jsonwebtoken`) | no |
| error_format | response shape for errors | existing error handler code | no |
| api_spec | where the API contract lives | `openapi.*`, `swagger.*` files | no |
| boundaries | rules that must hold (for example payments and email only on the server) | project docs and CLAUDE.md | no |
| test_command | verification | `test` script; flag a placeholder script | no |
| local_services | what a local run needs (database, mail, payment test mode) | `.env.example` names, compose files | no |
