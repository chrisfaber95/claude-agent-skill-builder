## Frontend Testing

Delegate all frontend testing work (setting up Playwright, writing or reviewing tests, running
tests, debugging failures) to the `frontend-tester` agent from the `playwright` plugin. In the
delegation prompt, include:
- what to test: the URL or feature, user flow, or test scenarios
- whether running tests is authorized and on which environment (local is default; for staging,
  name it by full URL)

The agent uses the Playwright MCP server for browser exploration and to generate stable
selectors. It may install `@playwright/test` as a dev dependency, download browsers, and start
the local dev server. Test files are committed with the project through the `git` plugin. Report
any `package.json` changes in the result.
