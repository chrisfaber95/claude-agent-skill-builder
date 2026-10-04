---
name: webhook-handler
description: "Procedure for writing or fixing a payment webhook handler: authenticate the event (signature or by fetching the payment from the provider), respond quickly, process idempotently, handle out-of-order and duplicate deliveries, update order status safely, and test replays. Followed by the payment-integration agent; in a main session, delegate webhook work to that agent and review it closely."
argument-hint: "<provider and webhook to build or fix>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Write or fix the webhook handler for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
payment-integration subagent, state the assumption and return the question. Test mode only.

## Steps

1. Read the provider's webhook documentation for the API version in use: what is sent (a full
   event, or only an id), whether requests are signed, how to verify them, which status values
   exist, the retry schedule and what response code stops retries. Write down what you
   confirmed. Some providers send only a payment id and expect you to fetch the payment; others
   send a signed event. Do not assume.
2. Authenticate before acting. If the provider signs webhooks, verify the signature over the raw
   request body with the webhook secret and reject failures with a `4xx`; register the raw body
   parser for this route before any JSON parser, since parsing first changes the bytes. If the
   provider sends only an id, treat the request as untrusted and fetch the payment by id from
   the provider's API with your secret key, and use that response, not the request body, as the
   source of truth.
3. Respond fast. Do the minimum work needed to record the event, then return `2xx`. Move slow
   work (sending confirmation email, stock updates, invoices) to a background job if the
   project has one. Return a non-`2xx` only for failures that a retry could fix (database
   down), so the provider retries; return `2xx` for events you deliberately ignore or already
   processed.
4. Process idempotently. The same event or status can arrive many times. Look up the order by
   the stored provider payment id; if the stored status already equals or is ahead of the
   incoming status, do nothing and return `2xx`. Make the update atomic (a conditional update
   or a transaction with a row lock) so two concurrent deliveries cannot both apply side
   effects. Store a processed-event id or status history if the provider supplies event ids.
5. Handle ordering. Deliveries can arrive out of order or after the customer returned. Never
   move an order backwards (paid to pending); use the same transition function as the checkout
   flow. For a paid status, verify that the amount and currency match what you stored for the
   order before marking it paid, and flag a mismatch instead of accepting it.
6. Side effects once only: only the delivery that actually changes the order to paid triggers
   the confirmation email, stock decrement and similar. Make those side effects safe to repeat
   or guard them with the same atomic status change.
7. Logging: log the provider payment id, the order id and the status change. Do not log full
   payloads, secrets or personal data. Alert on repeated verification failures or amount
   mismatches.
8. Tests with a mocked provider: valid event marks the order paid; the same event twice changes
   nothing the second time; an older status after a newer one is ignored; a bad signature is
   rejected (when signed); a failed fetch from the provider returns a retryable error; an
   amount mismatch is flagged. Tests must not use live keys or the network.
9. Verify: run the new and existing tests and lint. State plainly what only a real provider
   delivery in test mode would confirm, and that the webhook URL must be reachable from the
   provider (a tunnel for local development, started by the user).
10. Report the handler's behavior step by step, files changed, tests and results, assumptions
    and where they were confirmed, and the parts a human reviewer should read first.
