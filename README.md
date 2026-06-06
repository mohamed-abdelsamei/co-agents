# Co-Agents

A reusable **team of AI agents** for your work and pet projects. Six specialists — each with a
distinct **personality and point of view** — run a real feature lifecycle: **brainstorm a
requirement from multiple angles, agree on a solution, split it into tasks, then build, test,
review, and document it.** A master conductor (the **Maestro**) frames the work, convenes the
team, routes requests, and keeps the rationale. Every project gets its own committed **memory
folder** so discussions and decisions are never lost between sessions.

It runs in **GitHub Copilot (VS Code)** and **Claude Code** from one source. Talk to the
**Maestro** and let it delegate, or address **any specialist directly** — and if a request isn't
theirs, they hand it to the right teammate.

## The team

| Agent | Persona | Bias (kept honest by the team) | Owns |
|-------|---------|-------------------------------|------|
| **Maestro** | Calm facilitator (the conductor — a selectable agent in Copilot; the main session in Claude Code) | Forces a decision | Framing, routing, brainstorm rounds, synthesis, memory |
| `@architect` — **Sol** | Systems thinker | Leans to structure; can over-engineer | Analysis, design, task breakdown |
| `@engineer` — **Max** | Pragmatist | Ships fast; can under-design | Implementation, debugging, spikes |
| `@tester` — **Vera** | The breaker | Thorough; can over-test | Test plans, verification, edge cases |
| `@reviewer` — **Cass** | Constructive red-teamer | Risk-focused; can slow things down | Code review + decision critique |
| `@researcher` — **Ada** | Evidence-driven scholar | Rigorous; can rabbit-hole | Options, prior art, sourced findings |
| `@scribe` — **Quill** | Clear voice | Thorough; can over-document | Docs + recording the team's work |

The biases are deliberate. When Sol wants structure and Max wants to ship, that tension is the
point — a brainstorm with six agreeable agents is just one opinion repeated.

**The team challenges you, too.** By design, no agent is a yes-man: they push back on weak
reasoning — yours included — before acting on it. Everything they record is written for *you* to
read and understand later (plain language, terms defined, the *why* always explained), and you can
interrogate any of it: ask what a decision means with `/team-ask`, or have your own reasoning
grilled one sharp question at a time with `/team-grill`.

From one canonical source, the six personas, nine commands, and memory conventions run in both
tools; `build.py` generates the native Copilot bundle.

## Install

### GitHub Copilot (VS Code)

Install globally, for every workspace, from a clone of this repo:

```bash
git clone https://github.com/mohamed-abdelsamei/co-agents.git
cd co-agents
./install.sh                 # → your VS Code user profile (all workspaces)
```

Or install the team into a single repo's `.github/` (preserves any existing
`copilot-instructions.md`):

```bash
./install.sh --project /path/to/your/repo
```

Needs `python3`. After installing, open Copilot Chat and pick the **Maestro** agent (or a
specialist) from the agents dropdown, or run a `/team-*` prompt. Run `--dry-run` first to preview,
`--help` for all options.

> **How global install works:** the build emits VS Code custom agents (`*.agent.md`), prompt
> files (`*.prompt.md`), and an always-apply instructions file, and the installer drops them into
> your VS Code user-profile `prompts/` folder, which VS Code discovers in every workspace. Memory
> (`.coagents/`) is per-project — run `/team-init` (new) or `/team-onboard` (existing) inside a
> project to create it.

### Claude Code (plugin)

```
/plugin marketplace add mohamed-abdelsamei/co-agents
/plugin install co-agents
```

### Then bring the team onto your project (once)

- **New project** (little/no code) → `/team-init` — a short interview, then it scaffolds memory.
- **Existing project** → `/team-onboard` — the team scans and *understands* your codebase and any
  existing context files (`CLAUDE.md`, `AGENTS.md`, `copilot-instructions.md`, `context.md`, …)
  **without modifying them**, then builds its memory to complement them.

## Commands

| What you want | Command |
|---------------|---------|
| Start the team on a **new** project | `/team-init` |
| Onboard the team to an **existing** project | `/team-onboard` |
| Debate a topic from every angle and decide | `/team-brainstorm <topic>` |
| Turn a feature/requirement into a plan + tasks | `/team-plan <feature>` |
| Build a task: implement → test → review | `/team-build <task>` |
| Review code, or stress-test a decision | `/team-review <target>` |
| Ask about any decision, term, or topic | `/team-ask <question>` |
| Be interrogated on your own reasoning | `/team-grill <idea>` |
| Hand any request to the Maestro to route | `/team-delegate <request>` |

Or skip the commands and just talk: pick the Maestro (or a specialist) and ask in plain language.
In Copilot, choose the agent from the agents dropdown; in Claude Code, `@`-mention it
(`@architect design the schema`, `@reviewer poke holes in this plan`).

## How it works

The **Maestro** is the conductor: it frames the problem, brings in the right specialists, runs the
debate, synthesizes a decision, and records it. The six specialists do the focused work.

**The marquee flow — `/team-brainstorm`:**

1. The Maestro frames the question and picks who belongs at the table.
2. Those specialists give their views **independently** — each in character.
3. The Maestro surfaces the **agreements and the real tensions**.
4. A focused **rebuttal round**: the conflicting agents respond to each other.
5. The Maestro **synthesizes** a recommendation — which arguments won, which tradeoffs were
   accepted, what's still open.
6. The decision and discussion are written to project memory.

**Delegation.** Ask for anything. The Maestro classifies it and routes to the one right
specialist — or convenes the team if it's big. If a specialist gets something out of its lane,
it names the right teammate and the Maestro re-routes.

> **How the orchestration differs by tool:** in **Copilot**, the Maestro and specialists are
> custom agents that hand off to each other natively, and a brainstorm is held in one chat where
> the Maestro speaks as each persona in turn before synthesizing. In **Claude Code**, a subagent
> can't spawn other subagents, so the main session plays Maestro — spawning specialists as
> subagents, carrying handoffs and the debate state between them. Same team and commands; the
> conductor's mechanics adapt to each tool.

## Project memory (`.coagents/`)

`/team-init` (new project) or `/team-onboard` (existing project) creates a committed folder that
travels with your repo:

```
.coagents/
  charter.md       project principles + stack (read first, every session)
  discussions/     brainstorm summaries
  decisions/       ADR-style decision log
  requirements/    specs
  tasks/           task breakdowns + status
  research/        sourced findings
  reviews/         reviews + critiques
```

Durable, polished docs (architecture overviews, guides) live in `docs/` — one home per
artifact, no duplicates. Conventions are documented in the bundled **team-memory** skill.

## Skills

The team carries shared *method* as skills, so the deep know-how lives in one place instead of
being copy-pasted into every persona:

| Skill | What it encodes |
|-------|-----------------|
| **team-memory** | How the `.coagents/` memory works and who writes where |
| **codebase-onboarding** | Understanding an unfamiliar repo without modifying it (powers `/team-onboard`) |
| **decision-and-spec** | Testable requirements (given/when/then) and ADRs with real rationale |
| **research-method** | Sourcing, confidence rating, and citation discipline |
| **facilitation** | Running a debate that ends in a decision (steelman, surface assumptions) |

It also **leverages tools already at hand** rather than reinventing them — phrased as "if
available", so it gracefully no-ops where they aren't:

- **Claude Code built-ins** (loaded on demand): the reviewer uses `code-review` / `security-review`,
  the tester uses `verify` / `run`, the engineer uses `simplify`.
- **An optional companion skill:** the scribe uses [`humanizer`](https://github.com/blader/humanizer)
  (a separate, MIT-licensed skill you install yourself — *not* a built-in) to make recorded prose
  read naturally.

**Tool differences.** The five bundled skills above are compiled into Copilot as always-apply
instructions by `build.py`, so they work in both tools (which is why they're kept concise). The
Claude built-ins and `humanizer` are **Claude Code only** — Copilot has no skill system. If you
want humanizer-style cleanup in Copilot, port its `SKILL.md` into a VS Code prompt file
(`humanizer.prompt.md` in your user `prompts/` folder) and invoke it with `/humanizer`.

## Layout

One canonical source; the Copilot bundle is generated.

```
agents/             the six specialist personas        (canonical)
commands/           /team-* commands, tool-neutral     (canonical)
skills/             the team's shared-method skills    (canonical)
templates/          starting content for a project's .coagents/ (init/onboard)
shared/doctrine/    conductor doctrine shared by both tools (team, challenge, routing, …)
conductors/         per-tool conductor templates (include the shared doctrine)
build.py            renders conductors + generates the Copilot bundle
CLAUDE.md           the Claude conductor — GENERATED (do not edit by hand)
.claude-plugin/     plugin.json + marketplace.json     (Claude Code plugin manifest)
install.sh          builds + installs the Copilot bundle (global or per-project)
.github/workflows/  CI: build + frontmatter/sync checks
dist/copilot/       generated Copilot bundle (git-ignored)
```

### Editing

The conductor doctrine (team roster, challenge ethos, writing rules, routing, memory) lives **once**
in `shared/doctrine/` and is included into each tool's conductor via `<!-- include: X -->` markers
in `conductors/`. So:

- **Shared behavior** (applies to both tools) → edit `shared/doctrine/`.
- **Tool-specific orchestration** → edit `conductors/CLAUDE.template.md` (Claude) or
  `conductors/copilot-instructions.template.md` / `conductors/maestro.agent.template.md` (Copilot).
- **Personas / commands / memory conventions** → edit `agents/`, `commands/`, `skills/`.

After **any** change, run `python3 build.py` (or `./install.sh`, which builds first). This
regenerates `CLAUDE.md` and `dist/copilot/` — never edit those by hand. CI fails if `CLAUDE.md` is
out of sync, so commit it alongside your source change.

## Design principles

- **Single-level orchestration.** One conductor (the Maestro) drives many specialists; specialists
  don't drive each other. Delegation is conductor-mediated. This matches Claude Code's constraint
  (subagents can't spawn subagents) and keeps control flow legible.
- **Productive disagreement.** Personas carry deliberate, opposing biases so a brainstorm produces
  real tension, not consensus theater. The Maestro's job is to force a decision out of it.
- **Memory is the product.** Decisions and their rationale are written to a committed `.coagents/`
  folder, in plain language, for a human to read later. A conclusion that isn't written down
  didn't happen.
- **Respect what's already there.** Onboarding reads existing context files (`CLAUDE.md`,
  `AGENTS.md`, `copilot-instructions.md`, …) and never modifies them — they're authoritative.
- **One source, native targets.** Author once; generate each tool's native format.

## Known limitations

- **Guardrails are instructional, not enforced.** Memory write-scoping and "stay in your lane"
  rules are prose the model follows, not hard permissions. Agents can do whatever their granted
  tools allow.
- **Brainstorms cost tokens.** Convening several specialists across rounds is expensive; pick the
  smallest table that still disagrees, and prefer a single rebuttal round.
- **Copilot orchestration is newer ground.** VS Code recently renamed chat modes to custom agents;
  exact handoff behavior can vary by version. The installer prints the `chat.*FilesLocations`
  settings if your build doesn't auto-discover user files.

## License

MIT
