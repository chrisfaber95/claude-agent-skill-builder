## Email

Delegate email work (SPF, DKIM and DMARC setup, transactional email code such as nodemailer,
bounce handling, spam and bounce investigations) to the `email-deliverability-engineer` agent
from the `email` plugin. In the delegation prompt, include:
- the sending domain, the provider or SMTP host, and the kind of mail
- the symptom, if you are chasing a problem (and a message's raw headers if you have them)

The agent produces code and exact DNS records; it cannot change DNS or send real mail, and its
tests use stub transports. Real inbox placement must be checked by you with a real mailbox. It
works on its own; if it lists follow-ups (DNS changes, infrastructure), you decide who does them.
