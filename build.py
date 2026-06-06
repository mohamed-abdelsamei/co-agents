#!/usr/bin/env python3
"""Build the GitHub Copilot bundle from the canonical co-agents source.

The canonical source (authored for Claude Code, but written tool-neutrally) lives in:

    agents/        the six specialist personas      (*.md, frontmatter: name/description/tools)
    commands/      the /team-* workflows            (*.md, frontmatter: description/argument-hint)
    skills/team-memory/SKILL.md   memory conventions
    templates/coagents/           project-memory scaffold
    copilot/       Copilot-specific overlay         (maestro agent + copilot-instructions)

This script emits the VS Code Copilot layout into dist/copilot/:

    dist/copilot/
      agents/<name>.agent.md           personas (incl. the Maestro)
      prompts/<name>.prompt.md          /team-* commands
      instructions/team-memory.instructions.md
      copilot-instructions.md
      templates/coagents/...            (verbatim, for install.sh's memory scaffold)

Usage:  python3 build.py            # build into dist/copilot/
        python3 build.py --check    # build to a temp dir and report, don't write dist/

No third-party dependencies — standard library only.
"""

from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "dist" / "copilot"
DOCTRINE = ROOT / "shared" / "doctrine"      # shared, tool-neutral conductor doctrine
CONDUCTORS = ROOT / "conductors"             # per-tool conductor templates (with <!-- include: X -->)

# ─── Tool vocabulary: canonical (Claude) tool names → Copilot tool/toolset names ──
TOOL_MAP = {
    "Read": ["codebase"],
    "Grep": ["search"],
    "Glob": ["search"],
    "Edit": ["editFiles"],
    "Write": ["editFiles"],
    "Bash": ["runCommands"],
    "WebSearch": ["fetch"],
    "WebFetch": ["fetch"],
}

# Which agent each /team-* prompt runs under (defaults to maestro).
PROMPT_AGENT = {
    "team-grill": "reviewer",
}

# Agents each specialist may hand off to (Copilot custom-agent `agents` field).
SPECIALISTS = ["architect", "engineer", "tester", "reviewer", "researcher", "scribe"]


# ─── Frontmatter helpers ──────────────────────────────────────────────────────

def split_frontmatter(text: str) -> tuple[list[tuple[str, str]], str]:
    """Return ([(key, raw_value), ...], body). Preserves key order; raw values."""
    if not text.startswith("---\n"):
        raise ValueError("file has no frontmatter")
    end = text.index("\n---", 4)
    pairs = []
    for line in text[4:end].splitlines():
        if not line.strip():
            continue
        key, _, value = line.partition(":")
        pairs.append((key.strip(), value.strip()))
    body = text[end + len("\n---"):]
    return pairs, body.lstrip("\n")


def fm_get(pairs, key, default=None):
    for k, v in pairs:
        if k == key:
            return v
    return default


def parse_list(raw: str) -> list[str]:
    """'Read, Grep, Glob' or '[read, search]' -> ['Read','Grep','Glob']."""
    return [x.strip() for x in raw.strip().strip("[]").split(",") if x.strip()]


def map_tools(raw: str) -> list[str]:
    """Canonical tool list -> deduped, order-stable Copilot toolset list."""
    out: list[str] = []
    for t in parse_list(raw):
        for mapped in TOOL_MAP.get(t, []):
            if mapped not in out:
                out.append(mapped)
    return out


def sq(value: str) -> str:
    """YAML single-quoted scalar: wrap in '…', doubling any internal single quote."""
    return "'" + value.replace("'", "''") + "'"


def yaml_list(items: list[str]) -> str:
    return "[" + ", ".join(sq(i) for i in items) + "]"


# ─── Builders ─────────────────────────────────────────────────────────────────

def build_agent(path: Path) -> tuple[str, str]:
    """agents/<name>.md -> ('agents/<name>.agent.md', content)."""
    pairs, body = split_frontmatter(path.read_text())
    name = fm_get(pairs, "name") or path.stem
    desc = (fm_get(pairs, "description") or "").strip().strip('"')
    tools = map_tools(fm_get(pairs, "tools", "")) or ["codebase", "search", "editFiles", "fetch"]
    handoffs = [a for a in SPECIALISTS if a != name]  # peers it can delegate to

    fm = [
        "---",
        f"description: {sq(desc)}",
        f"tools: {yaml_list(tools)}",
        f"agents: {yaml_list(handoffs)}",
        "---",
        "",
    ]
    return f"agents/{name}.agent.md", "\n".join(fm) + body


def build_prompt(path: Path) -> tuple[str, str]:
    """commands/<name>.md -> ('prompts/<name>.prompt.md', content)."""
    pairs, body = split_frontmatter(path.read_text())
    name = path.stem
    desc = (fm_get(pairs, "description") or "").strip().strip('"')
    hint = (fm_get(pairs, "argument-hint") or "").strip().strip('"')
    agent = PROMPT_AGENT.get(name, "maestro")

    # Claude's $ARGUMENTS -> Copilot's ${input} prompt variable.
    body = body.replace("$ARGUMENTS", "${input}")

    fm = [
        "---",
        f"description: {sq(desc)}",
        f"agent: {sq(agent)}",
    ]
    if hint:
        fm.append(f"argument-hint: {sq(hint)}")
    fm += ["---", ""]
    return f"prompts/{name}.prompt.md", "\n".join(fm) + body


def build_memory_instructions() -> tuple[str, str]:
    """skills/team-memory/SKILL.md -> instructions/team-memory.instructions.md (applyTo '**')."""
    src = ROOT / "skills" / "team-memory" / "SKILL.md"
    pairs, body = split_frontmatter(src.read_text())
    fm = ["---", "applyTo: '**'", "---", ""]
    return "instructions/team-memory.instructions.md", "\n".join(fm) + body


# ─── Conductor templates (shared doctrine, expanded into each tool's conductor) ──

_INCLUDE = re.compile(r"^[ \t]*<!--[ \t]*include:[ \t]*([\w-]+)[ \t]*-->[ \t]*$", re.MULTILINE)


def expand_includes(text: str) -> str:
    """Replace `<!-- include: NAME -->` lines with shared/doctrine/NAME.md content."""
    def repl(m: "re.Match[str]") -> str:
        part = DOCTRINE / f"{m.group(1)}.md"
        if not part.exists():
            raise FileNotFoundError(f"doctrine partial not found: {part.relative_to(ROOT)}")
        return part.read_text().rstrip("\n")
    return _INCLUDE.sub(repl, text)


def render_conductor(name: str) -> str:
    """Expand a conductors/<name> template against the shared doctrine."""
    return expand_includes((CONDUCTORS / name).read_text())


# ─── Main ─────────────────────────────────────────────────────────────────────

def build() -> dict[str, str]:
    files: dict[str, str] = {}

    for p in sorted((ROOT / "agents").glob("*.md")):
        rel, content = build_agent(p)
        files[rel] = content

    for p in sorted((ROOT / "commands").glob("*.md")):
        rel, content = build_prompt(p)
        files[rel] = content

    rel, content = build_memory_instructions()
    files[rel] = content

    # Copilot conductors — rendered from conductors/*.template.md + shared/doctrine/.
    instructions = render_conductor("copilot-instructions.template.md")
    files["copilot-instructions.md"] = instructions          # project scope: .github/copilot-instructions.md
    files["agents/maestro.agent.md"] = render_conductor("maestro.agent.template.md")

    # Global (user-profile) scope can't use copilot-instructions.md (that's repo-only), so emit
    # the same content as an always-apply instructions file.
    files["instructions/co-agents.instructions.md"] = "---\napplyTo: '**'\n---\n\n" + instructions

    # Project-memory scaffold (install.sh lays this down for project-scope installs).
    for p in sorted((ROOT / "templates" / "coagents").rglob("*")):
        if p.is_file():
            files[f"templates/coagents/{p.relative_to(ROOT / 'templates' / 'coagents')}"] = p.read_text()

    return files


def main() -> int:
    check = "--check" in sys.argv
    files = build()
    # The Claude conductor is generated to the repo root (committed, not under dist/).
    claude_md = render_conductor("CLAUDE.template.md").rstrip("\n") + "\n"

    if not check:
        if OUT.exists():
            shutil.rmtree(OUT)
        for rel, content in files.items():
            dest = OUT / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(content)
        (ROOT / "CLAUDE.md").write_text(claude_md)

    agents = sum(1 for f in files if f.startswith("agents/"))
    prompts = sum(1 for f in files if f.startswith("prompts/"))
    where = "(check only, not written)" if check else str(OUT.relative_to(ROOT))
    print(f"co-agents → Claude (CLAUDE.md) + Copilot: {agents} agents, {prompts} prompts, "
          f"{len(files)} Copilot files {where}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
