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
│   ├── agents/
│   └── template/
├── scripts/                    # Build/export helpers
└── README.md
```

## Platform Outputs

- Claude Code: [`claude/`](claude/) is the installable plugin payload.
- OpenClaw: [`openclaw/`](openclaw/) contains workspace-oriented agent template files.

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

## OpenClaw Deployment

Register agents with OpenClaw CLI and sync workspace files:

```bash
./scripts/deploy-openclaw-agents.sh --check
./scripts/deploy-openclaw-agents.sh
```

If agents are already registered, only sync files:

```bash
./scripts/deploy-openclaw-agents.sh --skip-register
```

For custom destinations:

```bash
./scripts/deploy-openclaw-agents.sh --target-dir /path/to/.openclaw
```

## Marketplace Note

Marketplace index is maintained in a separate repository (`aurehub-claude-marketplace`) and should reference this repo's `claude/` subdirectory.

## License

MIT
