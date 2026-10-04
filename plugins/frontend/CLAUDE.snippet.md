## Frontend

Delegate frontend development (new web apps, components and pages, data fetching and real-time
updates, accessibility and performance work) to the `frontend-developer` agent from the
`frontend` plugin. In the delegation prompt, include:
- what to build or change, and the design reference (mockup, tokens, an existing screen to match)
- the API contract or endpoints, if the UI talks to a backend
- constraints: framework and browser support, dependencies that must not be added

The agent follows the project's existing framework and conventions, installs dependencies the
task needs, runs the dev server, type check, lint, tests and build, and reports the results. It
never commits (it reports `package.json` changes), never changes backend contracts, and does not
write browser end-to-end tests: it leaves `data-testid` attributes on key elements and lists
them in its result. It works on its own; follow-ups it lists are for you to route.
