---
description: "Templates for all project memory file types. Referenced by memory.instructions.md."
applyTo: ".co-agents/**"
---

# Memory Templates

## Constitution (`constitution.md`)

```markdown
# Project Constitution

**Date**: YYYY-MM-DD
**Status**: draft | active

## Project Identity

- **Name**: {project name}
- **Purpose**: {one-sentence description}
- **Primary stack**: {languages, frameworks, platforms}

## Principles

### Quality Standards
- {e.g., All public APIs must have tests}

### Testing Rules
- {e.g., TDD required for domain logic}

### Security Requirements
- {e.g., All user input validated at boundaries}

### Conventions
- {e.g., File naming: kebab-case}
- {e.g., Commit format: conventional commits}

### Research & Knowledge (for research-heavy or data projects — omit if not relevant)
- {e.g., Reproducibility: experiments must record inputs, seeds, and environment}
- {e.g., Data provenance: every dataset has a documented source and license}
- {e.g., Citation: claims trace to primary sources with access dates}
- {e.g., Review gate: findings reviewed before they inform a decision}

## Technical Constraints

- {e.g., Must support Node.js >= 18}

## Governance

- Architecture changes require ADR in decisions.md
- Exceptions to principles must be documented with rationale
```

## Decisions (`decisions.md`)

Append-only log. Each entry:

```markdown
## YYYY-MM-DD — {Short Decision Title}

**Status**: accepted | superseded | deprecated
**Context**: Why this decision was needed
**Decision**: What was decided
**Rationale**: Why this option was chosen over alternatives
**Consequences**: What follows from this decision
**Informed by**: {link to research/{topic}.md, an RFC, or docs/ — if applicable}
```

## Architecture (`docs/architecture.md`)

```markdown
# Architecture Overview

**Last updated**: YYYY-MM-DD
**Status**: draft | active

## System Overview

{1-2 paragraphs: what the system does and its boundaries}

## Components

| Component | Responsibility | Technology | Location |
|-----------|---------------|------------|----------|
| {name} | {what it does} | {stack} | {path or service} |

## Data Flow

{Description + Mermaid diagram}

## Infrastructure

- **Cloud**: {provider}
- **IaC**: {CDK, Terraform, etc.}
- **Environments**: {dev, staging, prod}
```

## Improvements (`improvements.md`)

```markdown
## YYYY-MM-DD — {Title}

**Priority**: low | medium | high
**Category**: tech-debt | improvement | optimization
**Source**: {review, implementation, research, debugging}
**Description**: {What the issue is and why it matters}
**Suggested fix**: {How to address it, if known}
```

## Requirements (`requirements/{feature}.md`)

```markdown
# {Feature Name}

**Date**: YYYY-MM-DD
**Status**: draft | approved | implemented

## Overview

What this feature does and why it exists

## Requirements

- **REQ-001**: {Specific, testable requirement}
- **REQ-002**: {Another requirement}

> **ID convention**: Use a feature prefix for globally unique IDs: `{PREFIX}-REQ-001` (e.g., `AUTH-REQ-001`, `ORD-REQ-002`). The prefix (3-4 uppercase letters) is derived from the feature name.

## Architecture

High-level design decisions with rationale

## Constraints

- {Technical or business constraints}

## Acceptance Criteria

- **AC-001** ({PREFIX}-REQ-001): {Testable criterion}
- **AC-002** ({PREFIX}-REQ-002): {Testable criterion}

## Non-functional Requirements

- Performance: {measurable targets}
- Security: {specific requirements}

## Open Questions

- {Questions that still need answers}
```

## Tasks (`tasks/{feature}-tasks.md`)

```markdown
# {Feature} — Implementation Tasks

**Requirements**: `../requirements/{feature}.md`
**Date**: YYYY-MM-DD

## Setup

- [ ] **{PREFIX}-001** — {Clear action description}
  - **Requires**: {PREFIX}-REQ-001
  - **Depends on**: none
  - **Approach**: standard | TDD
  - **Complexity**: S | M | L
  - **Acceptance**: {Specific testable criteria}

## {User Story Title}

- [ ] **{PREFIX}-002** — {Clear action description} `[P]`
  - **Requires**: {PREFIX}-REQ-002
  - **Depends on**: {PREFIX}-001
  - **Approach**: TDD
  - **Complexity**: M
  - **Acceptance**: {Specific testable criteria}
```

Complexity reflects **effort + uncertainty**, not just file count: **S** (small, well-understood — e.g. a single file or a short task), **M** (moderate effort or some unknowns — multiple files, a focused experiment), **L** (large or high-uncertainty — complex logic, open-ended investigation). Split anything larger than L. For non-code work (research, writing, data), read these as effort/risk rather than files.

## Review Report (`reviews/{feature}-review.md`)

```markdown
# {Feature} — Review Report

**Date**: YYYY-MM-DD
**Reviewer**: @architect

## Summary

{1-2 paragraph assessment}

## Requirement Alignment

| # | Requirement | Status | Details |
|---|-------------|--------|---------|
| {PREFIX}-REQ-001 | {description} | pass / partial / fail | {notes} |

## Findings

### Critical (must fix)
1. **{file:line}** — {description} (REQ-XXX)

### Important (should fix)
1. **{file:line}** — {description}

### Suggestions (nice to have)
1. **{file:line}** — {description}

## Fix Tasks

- [ ] {description} — {file} (from Critical #1)

## Verdict

**Approved** | **Changes Requested** | **Needs Rework**
```

## Consistency Analysis (`reviews/{feature}-analysis.md`)

```markdown
# {Feature} — Consistency Analysis

**Date**: YYYY-MM-DD
**Analyzer**: @architect

## Coverage Summary

| Artifact | Items | Covered | Gaps |
|----------|-------|---------|------|
| Requirements | {count} | {count} | {count} |
| Tasks | {count} | {count} | {count} |
| Decisions | {count} | {count} | {count} |

## Findings

### Critical (blocks implementation)
1. {description}

### Warning (may cause issues)
1. {description}

### Info (housekeeping)
1. {description}

## Recommendation

{Ready to implement / needs fixes first}
```

## Research (`research/{topic}.md`)

```markdown
# {Topic Title}

**Date**: YYYY-MM-DD
**Last updated**: YYYY-MM-DD
**Status**: draft | complete

## Research Question

{The main question, then the sub-questions it breaks into}

## Scope

{What's covered, what's explicitly out, and any assumptions/methodology}

## Summary

{2-3 sentence overview and key takeaway}

## Key Findings

- **[High|Medium|Low]** {Finding} — {source} ({source date})

## Conflicting Evidence

- {Where sources disagree, and how it was resolved (or left open)}

## Comparison (if applicable)

| Criteria | Option A | Option B |
|----------|----------|----------|
| {criterion} | {assessment} | {assessment} |

## Recommendations

- {Recommended approach with rationale}

## Open Questions

- {What remains unanswered or needs further research}

## Decision Impact

{What this implies for the project — link any ADR in decisions.md it informed}

## Sources

- {Title} — {link} (accessed YYYY-MM-DD)
```

## Knowledge Index (`research/README.md`)

A living map of what the project has researched. Update it whenever a research file is added or changed.

```markdown
# Research Knowledge Index

**Last updated**: YYYY-MM-DD

## Topics

| Topic | Status | Key takeaway | Confidence | File |
|-------|--------|--------------|------------|------|
| {topic} | draft / complete | {one line} | high/med/low | `{topic}.md` |

## What We Know

- {Settled conclusions the project relies on}

## Open Questions

- {Cross-cutting questions not yet resolved — candidates for the next research pass}
```

## Experiment (`experiments/{experiment-name}.md`)

```markdown
# Experiment: {Title}

**Date**: YYYY-MM-DD
**Status**: success | partial | failed
**Time spent**: {duration}

## Hypothesis

{Testable statement}

## Approach

{What we built/tried}

## Findings

- {Key findings}
- {Surprises or gotchas}

## Verdict

{Confirmed / partially confirmed / rejected}

## Next Steps

- {What to do with this knowledge}
```

## Demo Script (`experiments/{demo-name}-demo.md`)

```markdown
# Demo: {Title}

**Date**: YYYY-MM-DD
**Audience**: {who this is for}
**Duration**: {estimated time}

## Goal

{What we're demonstrating and the key takeaway}

## Prerequisites

- {Setup step}

## Script

### Step 1: {Title}
**Do**: {action to perform}
**Say**: {talking point}
**Show**: {expected output}

## Fallback

- If {X fails}: {workaround}
```
