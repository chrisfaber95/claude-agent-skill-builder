# node parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `node` section of `.claude/project-params.md`, read by node-specialist.

## Recommend when
- A Node.js server, worker or CLI exists: a package with a Node server framework (`express`,
  `fastify`, `koa`, `@nestjs/core`, `@hapi/hapi`) or a `bin` entry, or a start script running
  `node`/`nodemon`. Evidence: the manifest line or script. A frontend-only package is not enough.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| package_folder | where to run commands | folder of the server package | no |
| node_version | which runtime features are allowed | `engines.node`, `.nvmrc`, `.node-version` | no |
| module_system | import style | `"type": "module"` or CommonJS | no |
| start_command | running locally | `start`/`dev` scripts | no |
| process_manager | signal handling and shutdown | `pm2`, `nodemon`, Docker `CMD` | no |
| load_testing | where load tests may run | not detectable | no, default local instance only |
