## Payments

Delegate payment code (provider integration, webhooks, refund logic) and payment security
reviews to the `payment-integration` agent from the `payments` plugin. Review everything it
changes closely before committing. In the delegation prompt, include:
- the provider (for example Mollie or Stripe) and the flow to build or review
- where the existing order and payment code lives

The agent works in the provider's test mode only, keeps card data out of the application, never
logs or commits keys, and tests with a mocked provider. It cannot verify real provider behavior,
so it lists what only a real sandbox payment would confirm. It works on its own; if it lists
follow-ups (checkout UI, schema, API design), you decide who does them.

Handoffs: the agent's result may end with Handoffs entries (`to`, `why`, `task`, `context`,
`needs authorization`). Route an entry to the named agent only if that agent is installed (it is
in your list of available agents); otherwise do the work yourself or show it to the user. Never
grant authorization the user has not given; ask first.
