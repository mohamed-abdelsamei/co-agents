---
description: "Assess an existing feature or functionality — gather all details from docs and code, discuss improvements, produce an implementation plan."
agent: architect
argument-hint: "Feature or functionality to assess (e.g., 'authentication flow' or 'payment processing')"
---

The user wants to assess: **$INPUT**

## This Is an Assessment Session

Your goal is to become the expert on this feature by gathering everything the project knows about it, then facilitate a discussion about improvements.

## Workflow

### 1. Gather — Scan All Sources

Launch parallel Explore subagents to collect everything about this feature:

**Subagent A — Docs & project memory:**
- `docs/` — any architecture docs, specs, or research mentioning this feature
- `.co-agents/requirements/` — existing requirements related to this feature
- `.co-agents/decisions.md` — decisions that affect this feature
- `.co-agents/architecture.md` — architecture patterns relevant to this feature
- `.co-agents/improvements.md` — known issues or improvement ideas
- `.co-agents/research/` — prior research on related topics

**Subagent B — Codebase:**
- Key files implementing this feature (entry points, core logic, models, APIs)
- Tests covering this feature
- Dependencies and integrations
- Configuration and environment requirements

### 2. Present — Structured Summary

Present findings in this structure:

**Feature Overview**
- What it does (from docs/requirements or inferred from code)
- Current status (implemented, partial, planned)

**Documentation & Decisions**
- Requirements (with IDs if they exist)
- Architecture decisions affecting this feature
- Known improvements or issues already tracked

**Implementation Details**
- Key files and their roles
- Patterns used (with brief assessment)
- Dependencies (internal and external)
- Test coverage (what's tested, what's missing)

**Gaps & Observations**
- Discrepancies between docs and implementation
- Missing documentation or requirements
- Potential risks or technical debt

### 3. Discuss — Interactive Improvement Session

After presenting, facilitate a focused discussion:
- Ask what the user thinks works well and what doesn't
- Surface improvement opportunities you identified during gathering
- Discuss priorities and tradeoffs for potential changes
- Use structured questions to keep the discussion productive

Maximum **3 discussion rounds**. After round 3, move to planning.

### 4. Plan — Produce Improvement Plan

Based on the discussion, produce:
- A prioritized list of agreed improvements
- Record new improvements in `.co-agents/improvements.md`
- Record any architectural decisions in `.co-agents/decisions.md`
- Suggest the appropriate next step for each improvement:
  - New requirements needed → `/co-specify`
  - Ready to plan tasks → `/co-plan`
  - Needs more research → `/co-research`
  - Strategic decision required → `/co-advise`

## Scope Guard

Assessment and planning only. Do not write implementation code. When improvements are agreed, delegate to the appropriate workflow (`/co-specify`, `/co-plan`, `/co-implement`).

## Done When

Feature summary is delivered, improvements are discussed and agreed, next steps are clearly defined with the right workflow for each.
