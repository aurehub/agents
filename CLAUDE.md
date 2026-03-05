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
  ├── agents/
  └── template/
scripts/
  ├── build.sh
  ├── build-claude.sh
  ├── build-openclaw.sh
  └── deploy-openclaw-agents.sh
```

Marketplace files are maintained in a separate repository and reference this repo's `claude/` path.

## Updating Agents

```bash
cp claude/template/subagent-template.md claude/agents/<agent-name>.md
mkdir -p openclaw/agents/<agent-name>
cp openclaw/template/* openclaw/agents/<agent-name>/
```

If needed, update canonical metadata in `core/agents/` first.

Then regenerate target outputs:

```bash
./scripts/build.sh all
./scripts/deploy-openclaw-agents.sh --check
```

`deploy-openclaw-agents.sh` registers each agent via `openclaw agents add --non-interactive` and then copies generated files into the matching workspace directory.

## Conventions

- Agent names use kebab-case across all targets
- Keep `claude/` and `openclaw/` outputs aligned semantically
- Treat `core/` as canonical intent source whenever possible
- Use `scripts/build.sh` as the single build entrypoint
