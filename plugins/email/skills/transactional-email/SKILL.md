---
name: transactional-email
description: "Procedure for writing or fixing server-side transactional email code (for example nodemailer over SMTP): configuration from the environment, HTML plus plain-text parts, templates, sending outside the request path, retries for transient failures only, bounce handling, header-injection safety, and tests that never send real mail. Followed by the email-deliverability-engineer agent; in a main session, delegate email sending code to that agent."
argument-hint: "<mail to send or sending problem to fix>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Build or fix the email sending for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
email-deliverability-engineer subagent, state the assumption and return the question. Never
send real mail from tests or scripts.

## Steps

1. Read how mail is sent today: the library and version, the transport setup, the from address,
   the templates, what triggers each message, how errors are handled, and the existing tests.
   Follow the project's patterns and read the library's documentation for the version in use.
2. Configuration comes from environment variables (host, port, user, password, from address),
   validated at startup, with placeholders in `.env.example`. For SMTP: port 465 uses implicit
   TLS (`secure: true`), port 587 uses STARTTLS (`secure: false` with TLS required). Never
   disable certificate verification to make a connection work. Use pooled transports if the
   volume justifies it.
3. Sender identity: send from an address on a domain whose SPF, DKIM and DMARC are set up (use
   the `email-auth-setup` skill if that is the problem). Set a `Reply-To` if replies should go
   elsewhere.
4. Build the message: a plain-text part and an HTML part (mail without a text alternative is
   more likely to be filtered), a meaningful subject, and a template system the project already
   uses; escape all user-provided values in HTML. Keep HTML simple and table-based if it must
   render in old clients, with inline styles, a sensible size, and alt text on images. For
   marketing or bulk mail add `List-Unsubscribe` and one-click `List-Unsubscribe-Post` headers
   and honor unsubscribes promptly; transactional mail (receipts, password resets) does not
   need them but must not carry promotional content.
5. Header safety: validate recipient and `From` addresses, and never put raw user input in a
   subject, address or custom header without removing carriage returns and line feeds. Do not
   let a user choose the recipient of a transactional message except in the flow designed for
   it (for example the address they are verifying).
6. Do not send in the request path. If the project has a queue or background job mechanism, use
   it; otherwise send after responding (an async function not awaited by the handler, with its
   own error handling), and say that a queue is the robust option. A failed send must never fail
   the customer's order, and must never be lost silently.
7. Retries and failures: retry transient failures (SMTP `4xx` codes, connection timeouts) with
   exponential backoff and a maximum number of attempts; do not retry permanent failures
   (`5xx`, such as a nonexistent mailbox). Log the message id, recipient domain, error code and
   attempt count, not the message body or full personal data. Record permanent failures so the
   address is not tried again.
8. Bounces and complaints: if the provider offers webhooks or a bounce mailbox, handle hard
   bounces by suppressing the address, and complaints by suppressing and flagging for review.
   Keep a suppression list that every send checks.
9. Tests: use a stub or JSON transport that captures the message instead of sending (for
   example nodemailer's `jsonTransport`), or a local capture server, and assert on recipients,
   subject, the text and HTML parts, headers and escaping. Test retry behavior with a transport
   that fails then succeeds. Tests must not use real credentials or reach a real mail server.
10. Verify: run the new and existing tests and lint. If a local capture server is available,
    send one message to it and inspect the raw message. Say plainly that real inbox placement
    cannot be tested from here.
11. Report: files changed, how sending, retries and failures behave, test results, assumptions,
    and what a human must verify with a real mailbox.
