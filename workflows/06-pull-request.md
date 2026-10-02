# Pull Request

Part of the [revision workflow](../WORKFLOW.md).

### Step 10 — Create a Pull Request

Every revision MUST result in a GitHub Pull Request.

Do not merge a revision directly into main.

Create the PR using GitHub CLI where available (`gh pr create`).

The PR must have a meaningful title, e.g. `feat: add order creation tests`.

The PR description MUST include:

**Summary**

A concise description of the revision.

**Why**

Why the change exists and what problem it solves.

**Changes**

The important implementation changes.

**Architecture**

Relevant architectural decisions.

**Testing**

Exactly which tests/checks were run.

**Validation**

How the functionality was manually verified, if applicable.

**Known limitations**

Anything intentionally not implemented.

**Revision**

Reference the revision by number and name (`REV-XXX-short-description`). The revision document is local only and is not in the repo, so a link would not resolve.

Do not create vague PR descriptions.

## Pull Request Quality Requirements

Every PR should be understandable without reading every line of code.

The PR description should answer:

- What changed?
- Why was it needed?
- How was it implemented?
- What architectural decisions were made?
- How was it tested?
- What was intentionally left for later?

Avoid generic statements such as:

> "Implemented feature."

Prefer specific statements such as:

> "Added tests for order creation covering the Mollie payment call, stock/price validation and the confirmation email, with Mollie and mail mocked."
