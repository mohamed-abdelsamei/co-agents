---
description: "Code quality standards referenced by all agents. Single source of truth for structural rules."
applyTo: "**"
---

# Code Quality Standards

## Structure

- **Single Responsibility**: Each function/method does one thing — if you need a comment to explain a section, extract it into a named function
- **Small functions**: Prefer functions under ~20 lines; split longer ones into well-named helpers
- **Shallow nesting**: Max 2-3 levels of indentation — use early returns, guard clauses, or helper functions to flatten logic
- **Focused files**: Split files when they cover multiple unrelated concerns
- **One level of abstraction per function**: Don't mix high-level orchestration with low-level details

## Quality Gates

- **Simplicity gate**: "Is this the simplest thing that could work?" — flag unnecessary abstractions
- **Anti-abstraction gate**: "Will this be used more than once?" — flag one-time helpers

## Standards

- Follow language conventions and project standards defined in `copilot-instructions.md`
- Enable strict typing and null safety where the language supports it
- Handle errors explicitly — no silent failures
- Clear naming, no dead code, input validation at boundaries
- Run security scans on new or modified code
- Write tests for critical paths; use TDD for complex logic
- Infrastructure stacks should have assertion tests
