# aurehub/agents

Cross-platform agent repository targeting Claude Code and OpenClaw (Codex intentionally deferred).

## Structure

```text
.
├── core/                       # Platform-neutral source definitions
│   ├── agents/
│   └── schemas/
├── claude/                     # Claude Code output (plugin root)
│   ├── .claude-plugin/plugin.json
│   ├── agents/
│   └── template/
├── openclaw/                   # OpenClaw output
│   ├── manifest.json
│   ├── agents/
│   └── template/
├── scripts/                    # Build/export helpers
└── README.md
```

## Platform Outputs

- Claude Code: [`claude/`](claude/) is the installable plugin payload.
- OpenClaw: [`openclaw/`](openclaw/) contains OpenClaw-oriented manifest and agent files.

## Authoring Workflow

1. Add or update canonical definitions in `core/agents/`.
2. Regenerate/update platform outputs in `claude/` and `openclaw/`.
3. Validate structure before commit:

```bash
./scripts/build.sh all
./scripts/build.sh all --check
rg --files core claude openclaw
```

`scripts/build.sh` is the canonical builder: it reads `core/agents/*.yaml` and generates target files in `claude/agents/` and `openclaw/agents/`.

## Marketplace Note

Marketplace index is maintained in a separate repository (`aurehub-claude-marketplace`) and should reference this repo's `claude/` subdirectory.

## License

MIT
