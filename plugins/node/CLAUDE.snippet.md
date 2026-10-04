## Node.js runtime

Delegate Node-specific problems (slow or memory-hungry processes, blocked event loop, async and
error-handling bugs, stream and shutdown problems, Node security review) to the
`node-specialist` agent from the `node` plugin when the task clearly matches. In the delegation
prompt, include:
- the symptom or area to review, and how to reproduce it
- the Node version and framework if known
- whether running and load testing the server locally is allowed

The agent measures before and after and reports only numbers it took. It works on its own and
never touches production; if it lists follow-ups, you decide who does them.
