# payments parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `payments` section of `.claude/project-params.md`, read by
payment-integration.

## Recommend when
- A package depends on a payment provider SDK: `@mollie/api-client`, `mollie-api-node`, `stripe`,
  `@adyen/api-library`, `@paypal/*`, `braintree`; or source code calls a provider API. Evidence:
  the manifest line or file.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| provider_and_sdk | which provider and version | dependency and version | no |
| payment_code | where payments are created and webhooks handled | files importing the SDK; webhook routes | no |
| key_env_var | the environment variable holding the key (never its value) | `.env.example`, config code | no |
| test_mode | how test mode is selected | provider key prefix convention in docs, config | no |
| order_status_model | statuses and transitions | order model or migrations | no |
| webhook_url_local | how the provider reaches a local server (tunnel) | not detectable | no, note "user starts a tunnel" |
