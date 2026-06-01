"""Parse src/ into a tool-agnostic model, with shared transform helpers.

Source files are authored in GitHub Copilot dialect. Adapters consume the
``Model`` and emit each tool's native layout.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

# Canonical tool vocabulary (src) -> Claude Code tool names.
CLAUDE_TOOL_MAP = {
    "read": ["Read"],
    "search": ["Grep", "Glob"],
    "edit": ["Edit", "Write"],
    "web": ["WebFetch", "WebSearch"],
    "agent": ["Task"],
    "git": ["Bash"],
    "execute": ["Bash"],
    "todo": ["TodoWrite"],
}

# Universal instructions (applyTo "**") that must always be in context.
UNIVERSAL_INSTRUCTIONS = ["before-acting", "code-quality"]


# ─── Frontmatter ──────────────────────────────────────────────────────────────

def split_frontmatter(text: str) -> tuple[list[tuple[str, str]], str]:
    """Return ([(key, raw_value), ...], body). Preserves key order and raw values."""
    if not text.startswith("---\n"):
        raise ValueError("file has no frontmatter")
    end = text.index("\n---", 4)
    fm_block = text[4:end]
    body = text[end + len("\n---"):]
    if body.startswith("\n"):
        body = body[1:]
    pairs = []
    for line in fm_block.splitlines():
        if not line.strip():
            continue
        key, _, value = line.partition(":")
        pairs.append((key.strip(), value.strip()))
    return pairs, body


def fm_get(pairs, key, default=None):
    for k, v in pairs:
        if k == key:
            return v
    return default


def parse_list(raw: str) -> list[str]:
    """'[read, search, edit]' -> ['read', 'search', 'edit']."""
    return [x.strip() for x in raw.strip().strip("[]").split(",") if x.strip()]


def render_frontmatter(pairs: list[tuple[str, str]]) -> str:
    lines = "\n".join(f"{k}: {v}" for k, v in pairs)
    return f"---\n{lines}\n---\n"


def map_claude_tools(canon: list[str]) -> list[str]:
    out: list[str] = []
    for tool in canon:
        for mapped in CLAUDE_TOOL_MAP.get(tool, []):
            if mapped not in out:
                out.append(mapped)
    return out


def claude_rewrite(text: str, instr_root: str) -> str:
    """Rewrite Copilot-dialect references for a Claude target.

    ``instr_root`` is the path prefix where bundled instructions/agents/commands
    live in the target — e.g. ``.claude`` for a project install or
    ``${CLAUDE_PLUGIN_ROOT}`` for a plugin.
    """
    replacements = [
        (".github/instructions/", f"{instr_root}/instructions/"),
        (".github/agents/", f"{instr_root}/agents/"),
        (".github/prompts/", f"{instr_root}/commands/"),
        (".github/skills/", f"{instr_root}/skills/"),
        (".github/copilot-instructions.md", "CLAUDE.md"),
        ("copilot-instructions.md", "CLAUDE.md"),
        (".instructions.md", ".md"),
        (".agent.md", ".md"),
        (".prompt.md", ".md"),
        ("$INPUT", "$ARGUMENTS"),
    ]
    for old, new in replacements:
        text = text.replace(old, new)
    return text


# ─── Model ────────────────────────────────────────────────────────────────────

@dataclass
class ParsedFile:
    name: str
    pairs: list[tuple[str, str]]
    body: str
    raw: str  # verbatim source text, for identity (Copilot) output


@dataclass
class Model:
    main_instructions: str
    agents: list[ParsedFile] = field(default_factory=list)
    commands: list[ParsedFile] = field(default_factory=list)
    instructions: list[ParsedFile] = field(default_factory=list)
    skills: dict[str, str] = field(default_factory=dict)   # relpath -> content
    shared: dict[str, str] = field(default_factory=dict)   # relpath -> content (memory/, docs/)

    def agent_tools(self, name: str) -> list[str]:
        """Canonical tool list for an agent, by name."""
        for a in self.agents:
            if a.name == name:
                return parse_list(fm_get(a.pairs, "tools", "[]"))
        return []


def _parse_dir(d: Path) -> list[ParsedFile]:
    out = []
    for path in sorted(d.glob("*.md")):
        raw = path.read_text()
        pairs, body = split_frontmatter(raw)
        out.append(ParsedFile(name=path.stem, pairs=pairs, body=body, raw=raw))
    return out


def load_model(src: Path) -> Model:
    model = Model(main_instructions=(src / "main-instructions.md").read_text())
    model.agents = _parse_dir(src / "agents")
    model.commands = _parse_dir(src / "commands")
    model.instructions = _parse_dir(src / "instructions")

    for path in sorted((src / "skills").rglob("*")):
        if path.is_file():
            model.skills[path.relative_to(src / "skills").as_posix()] = path.read_text()

    for path in sorted((src / "shared").rglob("*")):
        if path.is_file():
            model.shared[path.relative_to(src / "shared").as_posix()] = path.read_text()

    return model
