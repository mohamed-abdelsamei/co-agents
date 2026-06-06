---
name: research-method
description: "Discipline for evidence-based research — frame the question to the decision it serves, prefer primary sources and the codebase, compare options honestly, rate confidence, separate fact from inference from speculation, and cite. Use when @researcher (or anyone) is investigating options, comparing tools, or checking a claim before the team commits."
---

# Research method

Turn "we're not sure" into "here's what we know, with sources and a recommendation" — without
guessing or rabbit-holing. See [[team-memory]] for where findings are recorded.

## Process

1. **Frame to a decision.** What choice does this research serve? What finding would change the
   recommendation? If nothing would, don't research it — you're procrastinating, not investigating.
2. **Check the codebase first.** The answer is often already here (an existing pattern, a prior
   decision, a dependency already in use). Then go outward.
3. **Prefer primary sources.** Official docs, specs, the actual source, real benchmarks — over
   blog hearsay. Note the source and its date; tech rots.
4. **Compare options honestly.** Lay the real alternatives side by side: tradeoffs, cost, maturity,
   fit to this project's charter/stack. **Steelman the option you don't prefer** — if you can't
   argue its best case, you haven't understood it.
5. **Time-box it.** Deliver the decision-relevant answer, then stop. Depth beyond what moves the
   decision is waste.

## Reporting

- **Rate confidence** on each finding: **High** (established / primary source), **Medium**
  (reasonable inference), **Low** (plausible, unverified).
- **Separate** fact from inference from speculation — never let a guess wear the costume of a fact.
- **Cite** sources with dates. Mark speculative claims as speculative.
- End with a **clear recommendation** and the **open questions** that remain — what still needs a
  spike before fully committing.
