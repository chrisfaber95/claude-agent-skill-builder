---
name: email-auth-setup
description: "Procedure for setting up and checking email authentication for a sending domain: SPF, DKIM and DMARC records with alignment, a staged DMARC rollout, and read-only DNS verification. Produces the exact records as a proposal because it cannot change DNS. Followed by the email-deliverability-engineer agent; in a main session, delegate email authentication setup to that agent."
argument-hint: "<sending domain and provider>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Set up or check email authentication for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
email-deliverability-engineer subagent, state the assumption and return the question. You
cannot change DNS: return exact records and steps for a human to apply.

## Steps

1. Establish the facts: the domain mail is sent from (the visible `From` domain), every service
   that sends mail for it (the app's provider or SMTP host, a marketing tool, the company mail
   system), and whether transactional and marketing mail share a domain. Prefer separate
   subdomains for transactional and marketing mail so one stream's reputation does not harm the
   other.
2. Look at the current state with read-only lookups on the named domain only:
   - SPF: `nslookup -type=TXT <domain>` (or `dig TXT <domain>`), find the record starting with
     `v=spf1`
   - DKIM: `nslookup -type=TXT <selector>._domainkey.<domain>` for each selector the provider
     documents
   - DMARC: `nslookup -type=TXT _dmarc.<domain>`
   Record what exists, and note when a lookup is not possible from this environment.
3. SPF: one record only per domain (two `v=spf1` records invalidate both). It must include
   every legitimate sender through the provider's documented `include:` mechanism and stay
   within 10 DNS lookups (each `include`, `a`, `mx`, `exists` and `redirect` counts). End with
   `~all` while testing and `-all` once the sender list is confirmed complete. Write the full
   proposed record.
4. DKIM: use the provider's own signing: they supply a selector and a public key (as a TXT or
   CNAME record) for you to publish. Prefer 2048-bit keys where the provider offers them.
   Provide the exact record name and value as the provider documents them; do not invent keys.
   Plan key rotation by adding a new selector before retiring the old one.
5. DMARC, staged: publish `v=DMARC1; p=none; rua=mailto:<address that exists and is monitored>`
   first and collect aggregate reports for a few weeks. Fix every legitimate sender that fails
   alignment (the SPF or DKIM domain must align with the `From` domain). Then move to
   `p=quarantine` (optionally with `pct=` to ramp), and to `p=reject` only when reports show
   legitimate mail passes. Explain that stricter policies can block real mail.
6. Alignment: SPF aligns when the envelope-from domain matches the `From` domain; DKIM aligns
   when the `d=` domain matches. DMARC needs at least one of them to pass and align. Check
   which one the provider's setup gives you, and set up a custom return-path or signing domain
   if the provider supports it and alignment fails.
7. Sending identity: the `From` address uses the authenticated domain, has a real mailbox for
   replies (or a clear no-reply policy), and the server's sending IP, if you run your own, has
   reverse DNS that matches its hostname. Mention MTA-STS and TLS-RPT as optional hardening.
8. Bulk senders: large mailbox providers publish requirements for bulk senders (authentication,
   one-click unsubscribe on marketing mail, a low spam-complaint rate). Check the providers' current
   guidance for the thresholds before quoting them.
9. Deliver the proposal as a table: record type, host, value, TTL, purpose, and the order to
   apply them in. List the verification step to run afterwards (the same lookups, then a test
   message to a mailbox you control and a check of its `Authentication-Results` header for
   `spf=pass`, `dkim=pass` and `dmarc=pass`).
10. Report: the current state you observed, the proposed records, the rollout order and
    timeline, what you could not verify, and what a human must do.
