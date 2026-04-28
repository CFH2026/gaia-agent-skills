# gaia-agent-skills

A collection of general-purpose agent skills for any AI coding assistant — Claude Code, Cline, Windsurf, Cursor, Codex, OpenHands, and 15+ others.

## Installation

Install all skills:
```sh
npx skills@latest add CFH2026/gaia-agent-skills -g
```

Install a single skill:
```sh
npx skills@latest add CFH2026/gaia-agent-skills/<skill-name> -g
```

The `npx skills` CLI detects your AI tool and installs to the right directory automatically.

## Skills

- **code-review** — Review code changes for correctness, style, and potential issues
- **grill-me** — Interview relentlessly about a plan or design until reaching shared understanding

## Contributing

Each skill is a directory under `_skills/` containing a single `SKILL.md` file with YAML frontmatter and Markdown instructions.

Example:
```
_skills/
  code-review/
    SKILL.md
```

See any existing skill for the format.

## License

MIT
