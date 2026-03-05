#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="${ROOT}/openclaw/agents"
TARGET_BASE="${HOME}/.openclaw"
CHECK_MODE="false"
SKIP_REGISTER="false"

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/deploy-openclaw.sh [--check] [--target-dir <path>] [--skip-register]

Options:
  --check              Print actions without changing files or running openclaw commands
  --target-dir <path>  Override OpenClaw base directory (default: ~/.openclaw)
  --skip-register      Skip `openclaw agents add` and only sync workspace files
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      CHECK_MODE="true"
      shift
      ;;
    --target-dir)
      TARGET_BASE="${2:-}"
      if [[ -z "${TARGET_BASE}" ]]; then
        echo "Missing value for --target-dir" >&2
        exit 1
      fi
      shift 2
      ;;
    --skip-register)
      SKIP_REGISTER="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

if [[ "$CHECK_MODE" != "true" && "$SKIP_REGISTER" != "true" ]]; then
  if ! command -v openclaw >/dev/null 2>&1; then
    echo "openclaw CLI not found. Install OpenClaw or run with --skip-register." >&2
    exit 1
  fi
fi

shopt -s nullglob
agent_dirs=("${SOURCE_DIR}"/*)
if [[ ${#agent_dirs[@]} -eq 0 ]]; then
  echo "No agents found under: $SOURCE_DIR" >&2
  exit 1
fi

for agent_dir in "${agent_dirs[@]}"; do
  [[ -d "$agent_dir" ]] || continue

  agent_id="$(basename "$agent_dir")"
  workspace_dir="${TARGET_BASE}/workspace-${agent_id}"
  agent_runtime_dir="${TARGET_BASE}/agents/${agent_id}/agent"

  if [[ "$CHECK_MODE" == "true" ]]; then
    echo "[CHECK] openclaw agents add ${agent_id} --workspace ${workspace_dir} --agent-dir ${agent_runtime_dir} --non-interactive"
    echo "[CHECK] copy ${agent_dir} -> ${workspace_dir}"
    continue
  fi

  if [[ "$SKIP_REGISTER" != "true" ]]; then
    if ! openclaw agents add "${agent_id}" \
      --workspace "${workspace_dir}" \
      --agent-dir "${agent_runtime_dir}" \
      --non-interactive; then
      echo "Failed to register agent '${agent_id}'. If agent already exists, rerun with --skip-register." >&2
      exit 1
    fi
  fi

  mkdir -p "$workspace_dir"
  cp -R "$agent_dir"/. "$workspace_dir"/
  echo "Deployed ${agent_id} to ${workspace_dir}"
done
