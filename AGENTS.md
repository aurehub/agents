# Repository Guidelines

## Project Structure & Module Organization
This repository is content-only and multi-platform, with separate outputs for Claude Code and OpenClaw.

- `core/`: platform-neutral source definitions and schema files.
- `claude/`: Claude plugin payload (`.claude-plugin/plugin.json`, `agents/`, `template/`).
- `openclaw/`: OpenClaw payload (`manifest.json`, `agents/`, `template/`).
- `scripts/`: helper scripts for validation/export checks.

## Build, Test, and Development Commands
No application build or automated test suite exists; validate structure and consistency instead.

- `./scripts/build-claude.sh`: verify Claude output path and layout.
- `./scripts/build-openclaw.sh`: verify OpenClaw output path and layout.
- `rg --files core claude openclaw`: list managed files for quick review.
- `git diff -- core claude openclaw`: confirm only intended files changed.

## Coding Style & Naming Conventions
Use concise Markdown and deterministic metadata.

- Agent filenames use kebab-case (example: `incident-responder.md`).
- Claude agent files require frontmatter `name` and `description`.
- Keep semantic behavior aligned between `claude/agents/` and `openclaw/agents/`.

## Testing Guidelines
Validation is review-based.

- Ensure each changed agent has corresponding files in both platform targets.
- Verify Claude frontmatter is present and valid after edits.
- Re-check docs and command examples when paths change.

## Commit & Pull Request Guidelines
Use Conventional Commits, consistent with repo history (`feat: ...`, `docs: ...`, `chore: ...`).

- Keep each commit scoped to one structural or content change.
- PRs should include purpose, impacted paths, and compatibility notes (Claude/OpenClaw).
- Link related issues when available.

## Marketplace Separation
Marketplace index lives in a dedicated repository (for example `aurehub/claude-marketplace`) and should point to this repo's `claude/` subdirectory.
