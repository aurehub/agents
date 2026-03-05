# Repository Guidelines

## Project Structure & Module Organization
This repository is content-focused: it stores AI agent definitions, not runnable application code.

- `agents/`: one directory per agent (for example `agents/example-agent/`).
- `template/`: canonical starter used when creating a new agent.
- Root docs: `README.md` (overview) and `CLAUDE.md` (repo-specific agent instructions).

Each agent directory should be self-contained and must include:
- `README.md` for purpose and usage.
- `CLAUDE.md` for system prompt/configuration.

## Build, Test, and Development Commands
There is no build pipeline or automated test suite in this repository. Use lightweight content checks:

- `cp -r template agents/<agent-name>`: scaffold a new agent.
- `rg --files agents template`: verify expected files exist.
- `git status`: review staged/unstaged changes before commit.
- `git diff -- agents/<agent-name>`: confirm only intended agent files changed.

## Coding Style & Naming Conventions
Treat all files as documentation/config content.

- Use Markdown headings with concise, task-oriented language.
- Keep instructions specific and actionable; avoid generic filler.
- Agent directory names must use kebab-case (example: `incident-responder-agent`).
- Keep `template/` aligned with the standard structure used by active agents.

## Testing Guidelines
Testing is review-based rather than framework-based.

- Validate that each new/updated agent contains both required files: `README.md` and `CLAUDE.md`.
- Verify examples and paths in docs are correct (for example `agents/<name>/`).
- If behavior or workflow guidance changes, update both the agent docs and any related root documentation.

## Commit & Pull Request Guidelines
Follow the Conventional Commit pattern reflected in history (`feat: ...`, `docs: ...`).

- Commit examples: `feat: add release-notes agent template`, `docs: clarify agent naming rules`.
- Keep commits scoped to one logical change.
- PRs should include: purpose, changed paths, and a brief review checklist.
- Link related issues when applicable; include screenshots only when formatting/rendering context is useful.
