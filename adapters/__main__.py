#!/usr/bin/env python3
"""Build the co-agents kit from src/ into dist/.

Single source of truth lives in src/ (authored in GitHub Copilot dialect). Each
registered adapter emits its target's native artifact:

    dist/claude/    a Claude Code plugin (committed; the marketplace points here)
    dist/copilot/   GitHub Copilot layout (.github/...)   — built on demand, gitignored
    dist/shared/    tool-agnostic payload (memory + docs)  — built on demand, gitignored

Usage (run from the repo root):
    python3 -m adapters                  # build all targets
    python3 -m adapters claude copilot   # build specific targets
    python3 -m adapters --check          # fail if committed dist/ is out of sync with src/
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

from . import ADAPTERS
from .model import load_model

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"
DIST = ROOT / "dist"


def _needs_shared(targets: list[str]) -> bool:
    """Shared payload (memory + docs) is consumed by file-copy installers, not plugins."""
    return any(t != "claude" for t in targets)


def generate(targets: list[str]) -> dict[str, str]:
    """Return {dist-relative path: content} for the selected targets + shared payload."""
    model = load_model(SRC)
    out: dict[str, str] = {}
    for target in targets:
        for rel, content in ADAPTERS[target].build(model).items():
            out[f"{target}/{rel}"] = content
    if _needs_shared(targets):
        for rel, content in model.shared.items():
            out[f"shared/{rel}"] = content
    return out


def write(out: dict[str, str], targets: list[str]) -> None:
    scopes = list(targets) + (["shared"] if _needs_shared(targets) else [])
    for scope in scopes:
        sub = DIST / scope
        if sub.exists():
            shutil.rmtree(sub)
    for rel, content in out.items():
        dest = DIST / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(content)
    print(f"Built {len(out)} files into dist/ ({', '.join(targets)})")


def check(out: dict[str, str], targets: list[str]) -> int:
    scopes = set(targets) | ({"shared"} if _needs_shared(targets) else set())
    expected = {DIST / rel for rel in out}
    actual = {
        p for p in DIST.rglob("*")
        if p.is_file() and p.relative_to(DIST).parts[0] in scopes
    } if DIST.exists() else set()

    drift = []
    for rel, content in out.items():
        dest = DIST / rel
        if not dest.exists():
            drift.append(f"missing: {rel}")
        elif dest.read_text() != content:
            drift.append(f"changed: {rel}")
    for extra in sorted(actual - expected):
        drift.append(f"stale:   {extra.relative_to(DIST).as_posix()}")

    if drift:
        print("dist/ is out of sync with src/ — run `python3 -m adapters`:")
        for d in drift:
            print(f"  {d}")
        return 1
    print(f"dist/ is in sync with src/ ({', '.join(targets)}).")
    return 0


def main(argv: list[str]) -> int:
    check_mode = "--check" in argv
    requested = [a for a in argv if not a.startswith("-")]
    unknown = [t for t in requested if t not in ADAPTERS]
    if unknown:
        print(f"Unknown target(s): {', '.join(unknown)}. Known: {', '.join(ADAPTERS)}")
        return 2
    targets = requested or list(ADAPTERS)

    out = generate(targets)
    if check_mode:
        return check(out, targets)
    write(out, targets)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
