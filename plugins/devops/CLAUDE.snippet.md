## DevOps

Delegate CI pipelines (for example GitHub Actions workflows), Dockerfiles and docker-compose
setups to the `devops-engineer` agent from the `devops` plugin. In the delegation prompt,
include:
- the CI provider, and the packages or services to build and check
- which CI checks must be required before merging (check names matter)
- the target environment, if any

The agent writes the files and validates them locally. It never deploys, pushes images, changes
cloud resources, or edits repository settings and secrets; it lists those as steps for you. It
works on its own; follow-ups it lists are for you to route.
