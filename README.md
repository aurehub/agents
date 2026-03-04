# aurehub/agents

Agent configurations, prompts, and templates for AI coding agents.

## Structure

Each agent is a self-contained directory under `agents/`:

```
agents/
└── example-agent/
    ├── README.md           # Agent description and usage
    ├── CLAUDE.md           # Agent configuration / system prompt
    └── ...                 # Additional config files
```

## Available Agents

| Agent | Description |
|-------|-------------|
| [example-agent](agents/example-agent/) | A demo agent showing the standard structure |

## Creating a New Agent

1. Copy the [template](template/) into a new directory under `agents/`:

```bash
cp -r template agents/my-agent
```

2. Customize the configuration files for your use case.

## Contributing

1. Fork this repository
2. Create your agent directory under `agents/`
3. Include a `README.md` with usage instructions
4. Submit a pull request

## License

MIT
