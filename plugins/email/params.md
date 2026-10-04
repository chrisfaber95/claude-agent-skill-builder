# email parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `email` section of `.claude/project-params.md`, read by
email-deliverability-engineer.

## Recommend when
- A package depends on a mail library or provider SDK: `nodemailer`, `@sendgrid/mail`, `postmark`,
  `mailgun.js`, `@aws-sdk/client-ses`, `resend`, `emailjs`; or a Python/PHP mail library in its
  manifest. Evidence: the manifest line.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| library_and_transport | how mail is sent (SMTP or API) | dependency; transport config in code | no |
| sending_code | where messages are built and sent | files importing the library | no |
| config_env_vars | variable names for host, user, from address (never values) | `.env.example`, config code | no |
| sending_domain | domain for SPF, DKIM and DMARC checks | from address in code or env example | yes, if mail is sent from a custom domain |
| templates | where message templates live | template folders | no |
| sends_in_request_path | whether sending blocks requests | how the send function is called | no |
| test_transport | how tests avoid real mail | test setup | no, default "stub transport" |
