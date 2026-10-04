# devops parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `devops` section of `.claude/project-params.md`, read by devops-engineer.

## Recommend when
- The project has CI or container files: `.github/workflows/*.yml`, `.gitlab-ci.yml`,
  `Dockerfile`, `docker-compose*.yml`, `compose*.yml`. Evidence: the files.

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| ci_provider_and_files | where pipelines live | workflow files | no |
| jobs_and_check_names | job names that may gate merges | `name:` of each job | no |
| per_package_commands | what each job runs | scripts per manifest; flag placeholder scripts | no |
| container_files | Dockerfiles and compose files | files | no |
| runtime_versions | versions CI must use | `engines`, `.nvmrc`, base images | no |
| secrets_needed | secret names CI needs (never values) | `secrets.*` references in workflows | no |
| deploy_target | where the app is deployed | not detectable | no, leave empty |
