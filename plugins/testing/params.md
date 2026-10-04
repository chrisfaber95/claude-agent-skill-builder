# testing parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `testing` section of `.claude/project-params.md`, read by test-automator.

## Recommend when
- A package has source code with logic that can be unit or API tested (a server, a library, or a
  frontend app with components). Evidence: the manifest and source folder. Also mention when the
  `test` script is a placeholder, since that is a reason to add tests.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| runners_per_package | which runner and command to use | `jest`, `mocha`, `vitest`, `ava`, `node --test`, `pytest`; `test` scripts | no |
| placeholder_scripts | scripts that must never be reported as a test run | `test` script printing "no test specified" or exiting without running tests | no |
| test_folders | where tests live and their naming | existing test files | no |
| test_database_rule | how tests get a database | test config, compose files, project docs | no, default "no live database; fixtures or a test database" |
| external_services_rule | mocking payments, mail and other services | project docs | no, default "always mocked" |
| coverage_tool | how coverage is measured | `c8`, `nyc`, `--coverage` in scripts | no |
| must_cover | what the project says must be tested | project docs | no |
