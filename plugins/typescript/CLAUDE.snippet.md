## TypeScript

Delegate type-system work (designing types, fixing type errors, typing API and config
boundaries, migrating JavaScript to TypeScript step by step) to the `typescript-pro` agent from
the `typescript` plugin, in projects that use or are adopting TypeScript. In the delegation
prompt, include:
- the files or area, and the current `tsconfig` strictness
- whether runtime behavior must stay unchanged (it normally must)

If the project is plain JavaScript and you did not ask for a migration, the agent does not
convert anything. It works on its own; follow-ups it lists are for you to route.
