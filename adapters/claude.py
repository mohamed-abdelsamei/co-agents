"""Claude Code adapter — emits a Claude *plugin* (not a project file-copy).

The plugin is distributed via a marketplace and copied to a cache on install,
so it must be self-contained: bundled instructions/templates are referenced with
``${CLAUDE_PLUGIN_ROOT}``. Output paths are rooted at ``claude/``.
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
ROOT = "${CLAUDE_PLUGIN_ROOT}"

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

# Appended to every agent so the universal standards stay in effect without a
# project CLAUDE.md (which the plugin does not ship).
ALWAYS_ON = (
    f"\n\n## Always-On Standards\n\n"
    f"Before acting, run the pre-check in `{ROOT}/instructions/before-acting.md`. "
    f"Follow the structural rules in `{ROOT}/instructions/code-quality.md`."
)


def _rw(text: str) -> str:
    return claude_rewrite(text, ROOT)


def build(model: Model) -> dict[str, str]:
    out: dict[str, str] = {}

    out[".claude-plugin/plugin.json"] = (
        json.dumps(PLUGIN_MANIFEST, indent=2, ensure_ascii=False) + "\n"
    )

    # Agents: name + Claude-mapped tools (+ model); body rewritten; standards appended.
    for a in model.agents:
        pairs = [
            ("name", a.name),
            ("description", _rw(fm_get(a.pairs, "description"))),
            ("tools", ", ".join(map_claude_tools(parse_list(fm_get(a.pairs, "tools", "[]"))))),
        ]
        if fm_get(a.pairs, "model"):
            pairs.append(("model", fm_get(a.pairs, "model")))
        out[f"agents/{a.name}.md"] = render_frontmatter(pairs) + _rw(a.body) + ALWAYS_ON

    # Commands: allowed-tools from the referenced agent; agent directive prepended.
    for c in model.commands:
        agent = fm_get(c.pairs, "agent", "")
        pairs = [("description", _rw(fm_get(c.pairs, "description")))]
        if fm_get(c.pairs, "argument-hint"):
            pairs.append(("argument-hint", _rw(fm_get(c.pairs, "argument-hint"))))
        pairs.append(("allowed-tools", ", ".join(map_claude_tools(model.agent_tools(agent)))))
        directive = f"> Act as the **{agent}** agent (`{ROOT}/agents/{agent}.md`).\n"
        out[f"commands/{c.name}.md"] = (
            render_frontmatter(pairs) + "\n" + directive + _rw(c.body)
        )

    # Instructions: keep description, drop applyTo (no glob auto-apply in Claude).
    for i in model.instructions:
        pairs = [("description", _rw(fm_get(i.pairs, "description")))]
        out[f"instructions/{i.name}.md"] = render_frontmatter(pairs) + _rw(i.body)

    # Skills.
    for rel, content in model.skills.items():
        out[f"skills/{rel}"] = _rw(content)

    # Templates the bootstrap commands (/co-setup, /co-init) instantiate into a
    # project, since the plugin ships no project CLAUDE.md or .co-agents/ skeleton.
    out["templates/CLAUDE.md"] = _rw(model.main_instructions)
    for rel, content in model.shared.items():
        out[f"templates/{rel}"] = content

    return out
