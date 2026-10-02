---
name: example-skill
description: "Example skill template. Replace this with your actual skill description."
when_to_use: "When you need to demonstrate the skill structure"
disable-model-invocation: false
allowed-tools: [Read, Grep, Glob]
---

## Overview

This is a template SKILL.md file. Skills are instructions Claude follows to help with specific tasks.

### Replace with your skill

1. Rename the directory from `example-skill` to your skill name
2. Update the `name` frontmatter field
3. Write your skill description and instructions in the markdown below
4. Add `allowed-tools` that your skill needs
5. Set `disable-model-invocation: true` if the skill should only be triggered manually (e.g., /my-skill)

### Key frontmatter fields

- `name`: Becomes the CLI command (/my-skill)
- `description`: Why Claude should use this skill (auto-invocation trigger)
- `when_to_use`: Additional context for when to invoke
- `allowed-tools`: Pre-approved tools (no permission prompts)
- `disable-model-invocation`: true = manual only, false = auto-invoke based on description

### Example instructions structure

Keep instructions clear and step-by-step. Claude will follow them literally.

See other skills in this directory for more examples.
