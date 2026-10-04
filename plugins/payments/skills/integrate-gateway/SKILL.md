---
name: integrate-gateway
description: "Procedure for integrating or changing a payment provider flow on the server: server-side amount calculation, creating the payment, hosted checkout redirect, order and payment status model, idempotency, test-mode configuration and tests with a mocked provider. Followed by the payment-integration agent; in a main session, delegate payment integration to that agent and review its changes closely."
argument-hint: "<provider and the flow to build or change>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Integrate or change the payment flow for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
payment-integration subagent, state the assumption and return the question. Test mode only;
never use a live key.

## Steps

1. Read the provider's current documentation for the API version in use and write down what you
   confirmed: how a payment or order is created, the amount and currency format, redirect and
   webhook URLs, the status values and their meaning, and how test mode is selected. Formats
   differ between providers (for example some take an amount as a string with two decimals plus
   a currency, others take integer minor units), so check before coding. If you cannot check,
   say so.
2. Read the existing order and payment code and the status model. Describe the target flow
   before writing it: order created pending, payment created with the provider, customer
   redirected to the provider's hosted page, customer returned to a status page, payment
   confirmed by webhook, order updated.
3. Compute the amount on the server from the server's own data (prices, discounts, shipping,
   tax) at the moment the payment is created. Use exact decimal or integer arithmetic, never
   floating point for money. Round once, with a documented rule. Ignore any price or total sent
   by the client.
4. Create the payment through the provider's API from the server only. Include a unique
   reference to your order, the return URL, and the webhook URL (the provider must be able to
   reach it; local development needs a tunnel the user starts, and you should say so rather than
   start one). Store the provider's payment id, the amount, the currency and the initial status
   against the order.
5. Keep card data out of the application: redirect to the provider's hosted checkout, or use
   their client components that tokenize in the browser. Nothing in the server or its logs
   should ever see a card number.
6. Status handling: define the allowed transitions (for example pending to paid, failed,
   expired or canceled; paid to refunded) and enforce them in one function so no code can move
   an order backwards (a paid order must never go back to pending). The return page only reads
   the stored status; it never marks an order paid. Only the verified webhook flow does.
7. Idempotency: protect order and payment creation against double submits (a unique constraint
   on the order reference, an idempotency key where the provider supports it, a check before
   creating a second payment for the same order).
8. Configuration: the API key and webhook secret come from environment variables, with test
   values documented in `.env.example` as placeholders. Fail fast at startup if the key is
   missing, and refuse to run a test environment with a key that looks live.
9. Errors: handle provider errors and timeouts (set a timeout on the call), show the customer a
   safe message and a way to retry, log the provider's error code and your ids but not secrets
   or personal data, and leave the order in a recoverable state.
10. Tests with the project's runner and a mocked provider (or the provider's sandbox if the
    project already uses it): amount calculation, payment creation request contents, each
    status transition including a rejected backwards transition, duplicate submit, and provider
    failure. The tests must not depend on a live key or network.
11. Verify: run the new and existing tests and lint. Say clearly what a real sandbox payment
    would still need to confirm.
12. Report the flow as implemented, files changed, test results, assumptions about the provider's
    behavior and where you confirmed them, and the points a human reviewer should read first.
