---
name: payment-review
description: "Procedure for reviewing a payment flow for security and correctness: amount tampering, card data exposure, webhook authentication, duplicate and out-of-order events, status transitions, secrets, refunds, logging and test versus live separation, with severity-ranked findings. Read-only. Followed by the payment-integration agent; in a main session, delegate payment reviews to that agent."
argument-hint: "<payment code, diff or flow to review>"
allowed-tools: [Read, Glob, Grep, Bash]
---

Review the payment flow: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
payment-integration subagent, state the assumption and return the question. This is a review:
report findings; do not edit. Do not call any live provider API.

## Steps

1. Trace the whole flow in the code: where the amount is computed, where the payment is
   created, where the customer is redirected, where the webhook lands, where order status is
   changed, and where refunds happen. Read the provider's documentation for the facts you rely
   on and say where you could not confirm them.
2. Check each of these and record evidence (file and line) for every finding:
   - **Amount integrity**: is the amount computed on the server from server-side data? Can a
     client-supplied price, quantity, discount or currency change what is charged? Is money
     handled with exact arithmetic and a single documented rounding rule? Is the amount compared
     with the provider's reported amount before an order is marked paid?
   - **Card data**: could card numbers, CVC or bank details reach the server, the logs or the
     database? Is hosted checkout or tokenization used?
   - **Webhook authentication**: is the event verified (signature over the raw body, or a fetch
     of the payment from the provider by id) before anything changes? Is the endpoint safe if
     someone posts a forged request with a real order's payment id?
   - **Idempotency and races**: can a double submit create two payments? Can two concurrent
     webhook deliveries apply side effects twice? Is the status update atomic?
   - **Status model**: are transitions enforced in one place? Can an order go from paid back to
     pending, or become paid from the return page alone?
   - **Ordering and duplicates**: are late, repeated and out-of-order webhooks handled?
   - **Side effects**: are confirmation email, stock changes and invoicing triggered exactly once
     by the transition that actually changes the order to paid?
   - **Refunds and cancellations**: who is authorized to trigger them, are amounts checked
     against what was paid, are partial refunds tracked, is there an audit trail?
   - **Secrets**: keys and webhook secrets from the environment only, not in code, logs, errors,
     the client bundle or committed files; test and live keys separated; startup refuses a live
     key in a test environment.
   - **Errors and logging**: no secrets or personal data in logs, safe messages to customers, a
     recoverable state after provider errors and timeouts, timeouts on every provider call.
   - **Access control**: can a user see or pay for another user's order by changing an id?
   - **Tests**: do tests cover the transitions, duplicates, tampering and failures, without live
     keys or the network?
3. Rank findings blocker (money can be lost or stolen, card data exposed, forged webhook
   accepted), major (wrong status or double side effect under realistic conditions), minor.
   For each finding give the file and line, the scenario in which it goes wrong, and a minimal
   fix. Do not report style preferences.
4. Say what you checked, what you could not check (anything that needs a real provider
   interaction), and give an overall verdict. If you found nothing, say what you examined so
   the claim means something.
