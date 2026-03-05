# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a collection of AI agent configurations, prompts, and templates. It contains no application code, build systems, or tests — it is a content-only repository of agent definitions.

## Architecture

```
agents/          # Each subdirectory is a self-contained agent
  └── <name>/
      ├── README.md    # Agent description and usage instructions
      ├── CLAUDE.md    # Agent system prompt / configuration
      └── ...          # Additional config files as needed

template/        # Starter template for new agents
```

## Creating a New Agent

```bash
cp -r template agents/<agent-name>
```

Then customize `README.md` and `CLAUDE.md` in the new directory.

## Conventions

- Each agent must be a self-contained directory under `agents/`
- Every agent directory must include a `README.md` (usage docs) and `CLAUDE.md` (system prompt/config)
- Agent names use kebab-case for directory names
- The `template/` directory is the canonical starting point — keep it in sync with any structural changes
