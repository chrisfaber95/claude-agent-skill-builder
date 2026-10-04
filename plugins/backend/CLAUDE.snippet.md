## Backend

Delegate server-side work (endpoints, use-case logic, validation, auth checks, error handling,
service hardening) to the `backend-developer` agent from the `backend` plugin when the task
clearly matches. In the delegation prompt, include:
- what to build or change, and the API contract or spec if there is one
- constraints: no new dependencies, files or areas that must not change

The agent follows the project's existing framework and layering, runs the tests, lint and build,
and reports what it ran. It never commits, never touches live databases or services, and works on
its own; if it lists follow-ups (schema, API design, e2e tests, review), you decide who does them.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
