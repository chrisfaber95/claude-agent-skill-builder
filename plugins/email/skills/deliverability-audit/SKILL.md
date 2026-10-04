---
name: deliverability-audit
description: "Procedure for diagnosing why email goes to spam, bounces or is delayed: check DNS authentication, read the headers of a sample message, review sending practices and content, list hygiene and reputation signals, and return ranked findings with fixes. Read-only. Followed by the email-deliverability-engineer agent; in a main session, delegate deliverability investigations to that agent."
argument-hint: "<domain, provider and the symptom>"
allowed-tools: [Read, Glob, Grep, Bash]
---

Investigate deliverability for: $ARGUMENTS

Wherever a step says to ask the user: in a main session, ask. When running as the
email-deliverability-engineer subagent, state the assumption and return the question. This is
read-only: do not change DNS or code, and do not send mail.

## Steps

1. Pin down the symptom and the scope: which messages (receipts, resets, marketing), to which
   mailbox providers, since when, what changed recently (new provider, new domain, new
   template, volume increase), and whether it is spam-foldering, delay, or hard bounces with an
   error code. Bounce messages contain the real reason; quote the SMTP code and text.
2. Authentication: look up SPF, DKIM (with the provider's selectors) and DMARC with read-only
   DNS commands for the named domain. Flag: multiple SPF records, over ten DNS lookups, a
   missing sender in SPF, a missing or misaligned DKIM signature, no DMARC record, and DMARC
   alignment failures. Use the `email-auth-setup` skill's rules for what correct looks like.
3. Message headers: if the request includes the raw headers of a received message, read
   `Authentication-Results` and `Received-SPF` for `pass` or `fail` of each check, the
   `From`, `Return-Path` and DKIM `d=` domains for alignment, any spam-score headers, and the
   hop timestamps for delay. Do not ask for or store message bodies beyond what is needed.
4. Sending practices (read the code): a plain-text part present, a real `From` on the
   authenticated domain, correct `Message-ID` and `Date`, no user input in headers, a sensible
   subject, not sent in a burst, retries not hammering failing addresses, and hard bounces
   suppressed. Transactional and marketing mail separated where both exist.
5. Content: image-only or very image-heavy messages, URL shorteners, mismatched link text and
   target, broken HTML, all-caps or heavy punctuation in subjects, missing unsubscribe on
   marketing mail. Treat "spam trigger words" as a weak signal.
6. List and reputation: how addresses are collected (consent, double opt-in), whether purchased
   or old lists are used, how inactive addresses are handled, role and disposable addresses,
   and complaint and bounce handling. Reputation checks that need external services (blocklist
   lookups, the mailbox providers' postmaster tools) are for a human to run; list exactly which
   to check. Commonly cited targets are a spam-complaint rate well below 0.1% and a low single
   digit bounce rate, but confirm the current thresholds in the providers' guidance.
7. Rank the findings: blockers (authentication failing, listed on a blocklist, hard bounces
   being retried), major (misalignment, missing text part, no suppression), minor. Each gets the
   evidence (the lookup output, the header line, the file and line), the likely effect, and the
   fix. Say what you could not check and what a human must check.
8. Report a summary verdict first, then the ranked findings, then the checks only a human can
   run.
