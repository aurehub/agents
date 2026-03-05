# Build Pipeline Unification Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace placeholder target scripts with a real unified build pipeline that generates Claude/OpenClaw agent outputs from `core/agents` and enforces drift checks in CI.

**Architecture:** Introduce one canonical entrypoint (`scripts/build.sh`) that parses `core/agents/*.yaml` and renders target markdown files for both `claude/agents` and `openclaw/agents`. Keep target-specific scripts as thin wrappers for compatibility. CI runs generation in `--check` mode to prevent manual drift.

**Tech Stack:** Bash, POSIX shell utilities (`sed`, `diff`, `mktemp`), GitHub Actions.

---

### Task 1: Baseline behavior test for current scripts

**Files:**
- Modify: `scripts/build-claude.sh`
- Modify: `scripts/build-openclaw.sh`
- Test: shell command checks from repo root

**Step 1: Write failing expectation**
- Define expected behavior: script should materialize/update files under `claude/agents` and `openclaw/agents`, not just print paths.

**Step 2: Run check to prove failure (old state)**
Run: `./scripts/build-claude.sh && ./scripts/build-openclaw.sh && git status --short`
Expected (old state): no generated content updates despite changed `core/agents/*.yaml`.

**Step 3: Commit baseline context**
Run:
```bash
git add README.md CLAUDE.md AGENTS.md
# optional baseline docs commit if needed
```

### Task 2: Implement unified builder

**Files:**
- Create: `scripts/build.sh`
- Modify: `scripts/build-claude.sh`
- Modify: `scripts/build-openclaw.sh`

**Step 1: Write failing check-mode expectation**
Run: `./scripts/build.sh all --check`
Expected (before implementation): command fails (missing file or unsupported behavior).

**Step 2: Implement minimal shared logic in `scripts/build.sh`**
- Parse `id`, `title`, `summary` from each `core/agents/*.yaml`.
- Render output markdown with frontmatter (`name`, `description`).
- Support targets: `claude`, `openclaw`, `all`.
- Support `--check`: compare temporary generated output with tracked target files.

**Step 3: Keep wrapper scripts thin**
- `scripts/build-claude.sh` delegates to `build.sh claude`.
- `scripts/build-openclaw.sh` delegates to `build.sh openclaw`.

**Step 4: Verify**
Run:
```bash
chmod +x scripts/build.sh scripts/build-claude.sh scripts/build-openclaw.sh
./scripts/build.sh all
./scripts/build.sh all --check
```
Expected: generation succeeds, check mode passes.

### Task 3: Integrate CI and docs

**Files:**
- Modify: `.github/workflows/validate.yml`
- Modify: `README.md`
- Modify: `CLAUDE.md`
- Modify: `AGENTS.md`

**Step 1: Update CI to use canonical command**
- Assert scripts exist.
- Run: `./scripts/build.sh all --check`.

**Step 2: Update docs to reflect canonical workflow**
- Document `scripts/build.sh` as single source of truth.
- Keep wrappers documented as compatibility aliases.

**Step 3: Verify docs + CI references**
Run:
```bash
rg -n "build\.sh|build-claude\.sh|build-openclaw\.sh" README.md CLAUDE.md AGENTS.md .github/workflows/validate.yml
```
Expected: references consistent and current.

### Task 4: Final verification and commit

**Files:**
- Modify: `claude/agents/example-agent.md` (if regenerated)
- Modify: `openclaw/agents/example-agent.md` (if regenerated)
- Commit all build pipeline changes

**Step 1: Full verification**
Run:
```bash
./scripts/build.sh all
./scripts/build.sh all --check
git status --short
```
Expected: check passes; only intended files changed.

**Step 2: Commit**
Run:
```bash
git add scripts/ .github/workflows/validate.yml README.md CLAUDE.md AGENTS.md claude/agents openclaw/agents docs/plans/2026-03-05-build-pipeline-unification.md
git commit -m "feat: unify agent build pipeline from core definitions"
```

**Step 3: Push and smoke check**
Run:
```bash
git push
```
Expected: branch updated successfully.
