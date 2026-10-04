## Frontend Testing

Delegate all frontend testing work (setting up Playwright, writing or reviewing tests, running
tests, debugging failures) to the `frontend-tester` agent from the `playwright` plugin. In the
delegation prompt, include:
- what to test: the URL or feature, user flow, or test scenarios
- whether running tests is authorized and on which environment (local is default; for staging,
  name it by full URL)

The agent uses the Playwright MCP server for browser exploration and to generate stable
selectors. It may install `@playwright/test` as a dev dependency, download browsers, and start
the local dev server. It does not commit; it reports the test files and any `package.json`
changes in its result. It works on its own; follow-ups it lists are for you to route.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
