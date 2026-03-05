# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository stores reusable agent definitions with a multi-target layout:
- `claude/` for Claude Code plugin output
- `openclaw/` for OpenClaw output
- `core/` as platform-neutral source definitions

## Architecture

```text
core/
  ├── agents/            # Canonical source definitions
  └── schemas/
claude/
  ├── .claude-plugin/plugin.json
  ├── agents/
  └── template/
openclaw/
  ├── manifest.json
  ├── agents/
  └── template/
scripts/
  ├── build-claude.sh
  └── build-openclaw.sh
```

Marketplace files are maintained in a separate repository and reference this repo's `claude/` path.

## Updating Agents

```bash
cp claude/template/subagent-template.md claude/agents/<agent-name>.md
cp openclaw/template/subagent-template.md openclaw/agents/<agent-name>.md
```

If needed, update canonical metadata in `core/agents/` first.

## Conventions

- Agent names use kebab-case across all targets
- Keep `claude/` and `openclaw/` outputs aligned semantically
- Treat `core/` as canonical intent source whenever possible
