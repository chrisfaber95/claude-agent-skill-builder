---
name: debug-test
description: "Procedure for debugging failing or flaky Playwright tests: reproduce the failure, identify the root cause (selector, timing, app behavior), fix the test or suggest app changes, and verify. Followed by the frontend-tester agent; in a main session, delegate test debugging to that agent."
argument-hint: "<test name or file>"
allowed-tools: [Bash, Read, Grep, Glob, Edit]
---

Debug this test: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the frontend-tester
subagent, state the assumption and return the question.

## Steps

1. Understand the failure: run the test once to capture the error message, screenshot, or trace.
   - If a screenshot or trace exists from a prior run, read it first.
   - Run the test again with `--debug` to see the browser state when the failure occurs.
2. Classify the failure:
   - **Selector is wrong or brittle**: element not found, or found a different element. Check
     `page.locator()` in the test against the actual HTML structure. If the HTML changed, update
     the selector or use a more stable one (add `data-testid`, use a role, use visible text).
   - **Timing issue**: element not yet visible, page not yet loaded, animation in progress. Wait
     for the element to be visible/stable before interacting with it. Never add a hardcoded wait;
     use `page.waitForSelector`, `page.waitForNavigation`, or Playwright's built-in waits.
   - **Test logic is wrong**: the test does the wrong thing (wrong URL, wrong form field, wrong
     assertion). Rewrite it to match the intended user flow.
   - **App behavior is wrong**: the app does not do what the test expects (form does not submit,
     page does not navigate, data is not saved). The bug is in the app, not the test. Propose
     the app change to the main session.
   - **Flaky test**: passes some runs, fails others. Usually a timing issue, async operation not
     waited for, or test isolation (state from a prior test). Add explicit waits, or isolate the
     test (run in fresh browser context, or reset state in `beforeEach`).
3. Inspect the HTML and app state:
   - Screenshot or trace: what does the page look like when the test fails?
   - Check the test output: any console errors or warnings?
   - Read the app code: does the element exist but is hidden? Is the async operation complete?
4. Fix the test or the app:
   - **Test fix**: update the selector, add a wait, fix the test logic. Re-run and confirm it
     passes.
   - **App fix**: document what the app should do differently, propose the change to the main
     session. The test is correct as written.
5. If the test was flaky, re-run it several times to confirm the fix: `npx playwright test
   <test> --repeat-each=5`.
6. Report: the root cause, what you changed (test or app), evidence (before/after output), and
   whether re-running passes consistently.
