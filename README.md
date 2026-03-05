# Fieldwork Marketplace

PM-native skills framework for AI coding agents.

## Installation

Add this marketplace to Claude Code:

```bash
/plugin marketplace add jklazinga/fieldwork-marketplace
```

## Available Plugins

### Fieldwork

**Description:** PM-native skills framework for AI coding agents. Discovery, spec, GTM, marketing, launch, and retro.

**Categories:** Product Management, Discovery, Spec, GTM, Launch

**Install:**
```bash
/plugin install fieldwork@fieldwork-marketplace
```

**What you get:**
- Skills for every PM workflow stage: discovery → spec → engineering handoff → GTM → launch → retro
- `/discover`, `/write-spec`, `/write-gtm`, `/close-feature` commands
- SessionStart context injection
- Compatible with superpowers `write-plan` output

**Repository:** https://github.com/jklazinga/fieldwork

---

## Marketplace Structure

```
fieldwork-marketplace/
├── .claude-plugin/
│   └── marketplace.json       # Plugin catalog
└── README.md                  # This file
```

## Support

- **Issues**: https://github.com/jklazinga/fieldwork-marketplace/issues
- **Plugin**: https://github.com/jklazinga/fieldwork

## License

Marketplace metadata: MIT License

Plugin: See https://github.com/jklazinga/fieldwork/blob/main/LICENSE
