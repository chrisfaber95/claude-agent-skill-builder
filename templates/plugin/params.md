# REPLACE_ME parameters

Read by the project-setup installer. "Recommend when" decides whether the plugin is pre-selected;
"Parameters" become the `REPLACE_ME` section of `.claude/project-params.md`, read by the agent.

## Recommend when
- Concrete evidence only: a dependency, a file or a folder that shows this project needs the
  agent. Name it exactly so the installer can show it as the reason. Never "always useful".

## Parameters
| Key | Used for | How to detect | Ask if unknown |
|---|---|---|---|
| example_key | what the agent uses this value for | where in the project it can be found | no, default `...` / yes |
