## Project memory

Every project this team works on keeps a committed `.coagents/` folder. Run `/team-init` (new
project) or `/team-onboard` (existing) to create it. Layout and conventions live in the
**team-memory** skill; the short version:

```
.coagents/
  charter.md       project principles + stack (read this first, every session)
  discussions/     dated brainstorm summaries
  decisions/       ADR-style decision log (one file per decision)
  requirements/    specs
  tasks/           task breakdowns + status
  research/        sourced findings
  reviews/         review + critique reports
```

**One home per artifact** — durable docs in `docs/`, operational memory in `.coagents/`, no
duplicates. At the start of a session in a project that has `.coagents/`, skim `charter.md` and
recent `decisions/` so you and the team don't relitigate settled calls.