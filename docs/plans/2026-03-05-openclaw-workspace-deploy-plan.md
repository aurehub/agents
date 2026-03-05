# OpenClaw Workspace Deploy Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace current OpenClaw target output with workspace-aligned agent templates and provide a deployment script that copies generated agents into `~/.openclaw`.

**Architecture:** Keep `core/agents/*.yaml` as canonical source. Generate `openclaw/agents/<agent-id>/` directories with workspace bootstrap files (`AGENTS.md`, `IDENTITY.md`, `SOUL.md`, `TOOLS.md`, `USER.md`). Add a deployment script to copy each generated agent into `~/.openclaw/workspace-<agent-id>/`.

**Tech Stack:** Bash scripts, YAML scalar parsing via `sed`, file copy via `cp`/`mkdir`.

---

### Task 1: Redefine OpenClaw output structure

**Files:**
- Modify: `scripts/build.sh`
- Modify: `openclaw/` generated contents

**Steps:**
1. Extend builder to render OpenClaw output as directories per agent.
2. Generate files: `AGENTS.md`, `IDENTITY.md`, `SOUL.md`, `TOOLS.md`, `USER.md`.
3. Remove legacy `openclaw/manifest.json` usage from generation expectations.
4. Verify with `./scripts/build.sh openclaw` and inspect tree.

### Task 2: Add deployment script to `~/.openclaw`

**Files:**
- Create: `scripts/deploy-openclaw-agents.sh`

**Steps:**
1. Add script to copy `openclaw/agents/<id>/*` -> `~/.openclaw/workspace-<id>/`.
2. Add `--target-dir` override for custom `.openclaw` base.
3. Add `--check` mode to preview actions.
4. Verify with dry-run and real run against temp path.

### Task 3: Update docs and validation

**Files:**
- Modify: `README.md`
- Modify: `CLAUDE.md`
- Modify: `AGENTS.md`
- Modify: `.github/workflows/validate.yml`

**Steps:**
1. Document OpenClaw as workspace-template target (not plugin manifest target).
2. Add deploy command examples.
3. Update CI checks for new output paths.
4. Run `./scripts/build.sh all --check` and `git status --short`.

### Task 4: Commit and push

**Files:** all changed files

**Steps:**
1. Final verification commands.
2. Commit with conventional message.
3. Push to `main`.
