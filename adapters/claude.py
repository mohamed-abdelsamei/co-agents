"""Claude Code adapter — emits a Claude *plugin* (distributed via a marketplace).

The plugin is copied to a cache on install, so it must be self-contained:
bundled instructions/templates are referenced with ``${CLAUDE_PLUGIN_ROOT}``.
Output paths are rooted at ``claude/``.

The agent/command/instruction/skill emitter (`emit_core`) is shared with the
file-install variant (`claude_local.py`), parameterized by the reference root.
"""

from __future__ import annotations

import json

from .model import (
    Model,
    claude_rewrite,
    fm_get,
    map_claude_tools,
    parse_list,
    render_frontmatter,
)

TARGET = "claude"
PLUGIN_ROOT = "${CLAUDE_PLUGIN_ROOT}"

PLUGIN_MANIFEST = {
    "name": "co-agents",
    "version": "0.1.0",
    "description": "An agent team for the whole project lifecycle — research, "
                   "planning, implementation, review, and ops — with persistent "
                   "project memory. 5 agents, 13 /co-* commands.",
    "author": {
        "name": "Mohamed Abdelsamei",
        "url": "https://github.com/mohamed-abdelsamei",
    },
    "repository": "https://github.com/mohamed-abdelsamei/co-agents",
    "license": "MIT",
}


def always_on(root: str) -> str:
    """Appended to every agent so universal standards stay in effect (no CLAUDE.md needed)."""
    return (
        f"\n\n## Always-On Standards\n\n"
        f"Before acting, run the pre-check in `{root}/instructions/before-acting.md`. "
        f"Follow the structural rules in `{root}/instructions/code-quality.md`."
    )


def emit_core(model: Model, root: str) -> dict[str, str]:
    """Agents, commands, instructions, skills for a Claude layout rooted at `root`."""
    rw = lambda text: claude_rewrite(text, root)  # noqa: E731
    out: dict[str, str] = {}

    for a in model.agents:
        pairs = [
            ("name", a.name),
            ("description", rw(fm_get(a.pairs, "description"))),
            ("tools", ", ".join(map_claude_tools(parse_list(fm_get(a.pairs, "tools", "[]"))))),
        ]
        if fm_get(a.pairs, "model"):
            pairs.append(("model", fm_get(a.pairs, "model")))
        out[f"agents/{a.name}.md"] = render_frontmatter(pairs) + rw(a.body) + always_on(root)

    for c in model.commands:
        agent = fm_get(c.pairs, "agent", "")
        pairs = [("description", rw(fm_get(c.pairs, "description")))]
        if fm_get(c.pairs, "argument-hint"):
            pairs.append(("argument-hint", rw(fm_get(c.pairs, "argument-hint"))))
        pairs.append(("allowed-tools", ", ".join(map_claude_tools(model.agent_tools(agent)))))
        directive = f"> Act as the **{agent}** agent (`{root}/agents/{agent}.md`).\n"
        out[f"commands/{c.name}.md"] = render_frontmatter(pairs) + "\n" + directive + rw(c.body)

    for i in model.instructions:
        pairs = [("description", rw(fm_get(i.pairs, "description")))]
        out[f"instructions/{i.name}.md"] = render_frontmatter(pairs) + rw(i.body)

    for rel, content in model.skills.items():
        out[f"skills/{rel}"] = rw(content)

    return out


def build(model: Model) -> dict[str, str]:
    out = emit_core(model, PLUGIN_ROOT)
    out[".claude-plugin/plugin.json"] = (
        json.dumps(PLUGIN_MANIFEST, indent=2, ensure_ascii=False) + "\n"
    )
    # Templates the bootstrap commands (/co-setup, /co-init) instantiate into a
    # project, since the plugin ships no project CLAUDE.md or .co-agents/ skeleton.
    out["templates/CLAUDE.md"] = claude_rewrite(model.main_instructions, PLUGIN_ROOT)
    for rel, content in model.shared.items():
        out[f"templates/{rel}"] = content
    return out
