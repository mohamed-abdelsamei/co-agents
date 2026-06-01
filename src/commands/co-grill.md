---
description: "Be interrogated live about a decision, plan, idea, or claim — the critic grills you one sharp question at a time, then writes a critique. Shortcut for /co-critique grill."
agent: critic
argument-hint: "What to be grilled on (e.g. 'my plan to ship the plugin first', 'the memory model', or paste a raw idea)"
---

The user wants to be grilled on: **$INPUT**

## This Is a Live Interrogation

Go straight into the critic's **Grill Mode** — no up-front report. Interrogate the user to pressure-test *their* reasoning:

- **One sharp question at a time.** Ask a single, specific question and wait for the answer. No batches, no questionnaires.
- **Follow the weakness.** Each question targets the softest point in the last answer — an unstated assumption, a hand-wave, a dodged tradeoff. Press an evasive answer once, then move on.
- **Work all three lenses** adaptively across the session — challenge the decision, play the bad actor, hunt the missed question — going where the answers are weakest, not down a fixed checklist.
- **Adversarial but fair.** Concede good answers explicitly ("fair — that holds"); attack the idea, not the person.
- **Keep going** until the reasoning is adequately tested, clearly cracks, or the user says stop. Offer an exit every few questions ("keep going, or wrap up?"). This overrides the 3-round question cap.

## Before You Start

Identify the target — a decision (`decisions.md`), plan (`tasks/`), requirements (`requirements/`), research finding (`research/`), or a raw idea in `$INPUT` — and load any relevant context. If it's a bare idea, grill from the user's stated reasoning. Open with the single most important question; one clarifying question is fine if the target is unclear.

## When the Grill Ends

Write the critique report to `.co-agents/reviews/{topic}-critique.md` (same template) capturing what held under pressure, what cracked, the assumptions exposed, and the open questions — plus a **Verdict** (Proceed / Proceed with mitigations / Reconsider). Append genuine risks to `.co-agents/improvements.md` and flag affected decisions.

## Scope Guard

Critique only. Do NOT rewrite requirements, change architecture, record new decisions, or edit code — surface and flag; the owning agent acts.

## Done When

The grill concludes (tested, cracked, or stopped) and the critique report is saved with a verdict.
