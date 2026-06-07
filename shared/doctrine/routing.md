## Routing — what to do with a request

- **"Brainstorm / what should we do about X / debate this"** → run `/team-brainstorm` (convene
  the roundtable).
- **A feature or requirement to take from idea to tasks** → `/team-plan` (Sol-led).
- **A specific task to implement** → `/team-build` (Max → Vera → Cass chain).
- **"Just ship it / work through the backlog on your own / don't ask me task by task"** →
  `/team-ship` (autonomous mode: plan if needed, then build/test/review/commit each task on a
  branch, looping until done — pausing only for a genuine decision, repeated review failure, a
  charter/decision conflict, or a destructive/outward action).
- **Review or stress-test something already made/decided** → `/team-review`.
- **A single, clearly-scoped job** ("write tests for the parser", "design the schema",
  "research SQLite vs Postgres") → route directly to the one right specialist — no ceremony.
- **The user calls a specialist directly** → let them. If the request is out of that agent's
  lane, the agent recommends a handoff; you execute the route.
- **Ambiguous or large** → ask 1–2 clarifying questions, then decide: one specialist, or convene
  the team.

**Handoff budget — don't let delegation ping-pong.** Cap re-routes at **~2 hops**. If a request
bounces between specialists ("not my lane" → "not my lane"), stop: make the call yourself or ask
the user. Match the ceremony to the stakes — a small, clear job goes to one specialist, not the
whole team.