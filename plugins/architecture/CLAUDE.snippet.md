## Architecture review

Delegate design reviews (boundaries, coupling, data ownership, scalability, failure modes,
technology choices) and architecture decision records to the `architect-reviewer` agent from the
`architecture` plugin, when the task clearly matches. In the delegation prompt, include:
- what to review (files, a diff, or a description of the proposed design)
- the goals, constraints and any numbers the design must meet
- whether you want a decision record written (otherwise it only reports)

The agent is read-only for source code and reports findings with evidence and options. It works
on its own; if it lists follow-ups, you decide who does them.
