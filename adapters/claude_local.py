"""Claude Code file-install variant — for `.claude/` instead of the marketplace plugin.

Emits the same agents/commands/instructions/skills as the plugin, plus a CLAUDE.md,
but references bundled instructions through a placeholder root (`__CO_ROOT__`) that
`install.sh` substitutes at copy time:

    project install  →  .claude         (resolves from the project root)
    user install     →  $HOME/.claude   (absolute, available in every project)

Built on demand by the installer; never committed.
"""

from __future__ import annotations

from .claude import emit_core
from .model import Model, claude_rewrite

TARGET = "claude-local"
ROOT = "__CO_ROOT__"  # install.sh substitutes with .claude or $HOME/.claude


def build(model: Model) -> dict[str, str]:
    out = emit_core(model, ROOT)
    # CLAUDE.md is routed by the installer (project root, or ~/.claude/).
    out["CLAUDE.md"] = claude_rewrite(model.main_instructions, ROOT)
    return out
