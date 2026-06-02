"""GitHub Copilot adapter — emits the .github/ layout.

Source is authored in Copilot dialect, so bodies are copied verbatim; only the
file names/locations change. Output paths are rooted at ``copilot/``.
"""

from __future__ import annotations

from .model import Model

TARGET = "copilot"


def build(model: Model) -> dict[str, str]:
    out: dict[str, str] = {}

    # Source is authored in Copilot dialect — emit bodies verbatim, rename files.
    for a in model.agents:
        out[f".github/agents/{a.name}.agent.md"] = a.raw
    for c in model.commands:
        out[f".github/prompts/{c.name}.prompt.md"] = c.raw
    for i in model.instructions:
        out[f".github/instructions/{i.name}.instructions.md"] = i.raw
    for rel, content in model.skills.items():
        out[f".github/skills/{rel}"] = content

    out[".github/copilot-instructions.md"] = model.main_instructions
    return out
