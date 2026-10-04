## Automated testing

Delegate unit, integration and API tests (writing them, reproducing a bug with a failing test,
fixing flaky tests, finding coverage gaps) to the `test-automator` agent from the `testing`
plugin. In the delegation prompt, include:
- what to test, or the change to cover
- the package folder, and how tests are run if it is not obvious

The agent uses the project's own test runner, never uses live databases, payment providers or
mail servers, and reports the real results of the commands it ran (it does not count a
placeholder `npm test` as a pass). Browser end-to-end tests are outside its scope. It works on
its own; follow-ups it lists are for you to route.
