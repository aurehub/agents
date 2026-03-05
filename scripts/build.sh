#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORE_DIR="${ROOT}/core/agents"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/build.sh <target> [--check]

Targets:
  claude     Generate claude/agents/*.md from core/agents/*.yaml
  openclaw   Generate openclaw/agents/*.md from core/agents/*.yaml
  all        Generate both targets

Flags:
  --check    Verify generated output matches working tree (no writes)
EOF
}

parse_yaml_scalar() {
  local file="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "$file" | head -n1
}

render_agent_markdown() {
  local core_file="$1"
  local out_file="$2"
  local id title summary

  id="$(parse_yaml_scalar "$core_file" "id")"
  title="$(parse_yaml_scalar "$core_file" "title")"
  summary="$(parse_yaml_scalar "$core_file" "summary")"

  if [[ -z "${id}" || -z "${summary}" ]]; then
    echo "Invalid core agent spec (missing id/summary): ${core_file}" >&2
    return 1
  fi

  if [[ -z "${title}" ]]; then
    title="${id}"
  fi

  cat >"$out_file" <<EOF
---
name: ${id}
description: ${summary}
---

You are ${title}.

## Responsibilities

- ${summary}
- Follow repository instructions for this target
- Keep responses concise and actionable

## Operating Rules

- Prefer concrete commands and file paths
- State assumptions when context is missing
- Avoid unnecessary verbosity
EOF
}

render_openclaw_agent_dir() {
  local core_file="$1"
  local out_dir="$2"
  local id title summary

  id="$(parse_yaml_scalar "$core_file" "id")"
  title="$(parse_yaml_scalar "$core_file" "title")"
  summary="$(parse_yaml_scalar "$core_file" "summary")"

  if [[ -z "${id}" || -z "${summary}" ]]; then
    echo "Invalid core agent spec (missing id/summary): ${core_file}" >&2
    return 1
  fi

  if [[ -z "${title}" ]]; then
    title="${id}"
  fi

  mkdir -p "${out_dir}/${id}"

  cat >"${out_dir}/${id}/AGENTS.md" <<EOF
# ${title}

${summary}

## Responsibilities

- ${summary}
- Keep responses concise and actionable
- Prefer concrete commands and file paths
EOF

  cat >"${out_dir}/${id}/IDENTITY.md" <<EOF
# Identity

- Agent ID: ${id}
- Agent Name: ${title}
- Summary: ${summary}
EOF

  cat >"${out_dir}/${id}/SOUL.md" <<EOF
# Soul

Core behavioral values:
- Clarity
- Pragmatism
- Technical rigor
EOF

  cat >"${out_dir}/${id}/TOOLS.md" <<'EOF'
# Tools

Use available tools conservatively:
- Prefer local context first
- Verify before claiming success
- Surface assumptions explicitly
EOF

  cat >"${out_dir}/${id}/USER.md" <<EOF
# User Context

This workspace template is generated from core agent definition: ${id}.
Customize this file for end-user preferences after deployment.
EOF
}

generate_target_to_dir() {
  local target="$1"
  local out_dir="$2"
  local core_file agent_id out_file

  mkdir -p "$out_dir"
  if [[ "$target" == "claude" ]]; then
    rm -f "${out_dir}"/*.md
  elif [[ "$target" == "openclaw" ]]; then
    rm -rf "${out_dir:?}"/*
  fi

  for core_file in "${CORE_DIR}"/*.yaml; do
    [[ -e "$core_file" ]] || continue
    agent_id="$(parse_yaml_scalar "$core_file" "id")"
    if [[ -z "${agent_id}" ]]; then
      echo "Missing id in ${core_file}" >&2
      return 1
    fi
    if [[ "$target" == "claude" ]]; then
      out_file="${out_dir}/${agent_id}.md"
      render_agent_markdown "$core_file" "$out_file"
    elif [[ "$target" == "openclaw" ]]; then
      render_openclaw_agent_dir "$core_file" "$out_dir"
    else
      echo "Unsupported generation target: ${target}" >&2
      return 1
    fi
  done

  echo "Generated ${target} agents into: ${out_dir}"
}

check_target() {
  local target="$1"
  local target_dir="${ROOT}/${target}/agents"
  local tmp_dir rc
  tmp_dir="$(mktemp -d)"
  rc=0

  generate_target_to_dir "$target" "${tmp_dir}/${target}/agents" >/dev/null

  if ! diff -qr "${tmp_dir}/${target}/agents" "$target_dir" >/dev/null; then
    echo "Drift detected for target '${target}'. Run: ./scripts/build.sh ${target}" >&2
    diff -qr "${tmp_dir}/${target}/agents" "$target_dir" || true
    rc=1
  else
    echo "Check passed for target: ${target}"
  fi

  rm -rf "$tmp_dir"
  return "$rc"
}

run_target() {
  local target="$1"
  local check_mode="$2"

  case "$target" in
    claude|openclaw)
      if [[ "$check_mode" == "true" ]]; then
        check_target "$target"
      else
        generate_target_to_dir "$target" "${ROOT}/${target}/agents"
      fi
      ;;
    *)
      echo "Unsupported target: ${target}" >&2
      usage
      return 1
      ;;
  esac
}

main() {
  local target="${1:-}"
  local check_mode="false"

  if [[ -z "$target" ]]; then
    usage
    return 1
  fi

  shift || true
  if [[ "${1:-}" == "--check" ]]; then
    check_mode="true"
  elif [[ -n "${1:-}" ]]; then
    usage
    return 1
  fi

  if [[ ! -d "${CORE_DIR}" ]]; then
    echo "Missing core directory: ${CORE_DIR}" >&2
    return 1
  fi

  if [[ "$target" == "all" ]]; then
    run_target "claude" "$check_mode"
    run_target "openclaw" "$check_mode"
  else
    run_target "$target" "$check_mode"
  fi
}

main "$@"
