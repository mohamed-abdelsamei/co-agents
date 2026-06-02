"""Adapter registry. Add an editor by writing a new module and listing it here.

Each adapter module exposes ``TARGET: str`` and ``build(model) -> {relpath: content}``
with paths rooted at the target's dist subdirectory (``dist/<TARGET>/``).
"""

from . import claude, claude_local, copilot

ADAPTERS = {m.TARGET: m for m in (claude, claude_local, copilot)}
