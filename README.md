# gaia-agent-skills

This repository contains the Gaia team’s authored skill and policy content, plus the MCP server workspace that serves that content.

## Repository Layers

- `gaia-skills/` for engineer-built skills intended for release to other users and local laptops
- `gaia-instructions/` for AI agent execution instructions that accompany skills
- `gaia-policies/` for engineer-authored policies and rules that skills can reference
- `mcp/gaia-mcp/` for the MCP server implementation that serves skills and policies

## What This Repo Is

- Source repository for Gaia team skills
- Canonical place for skill and policy definitions and instructions
- Release-oriented skill area under `gaia-skills/`
- AI execution instructions area under `gaia-instructions/` (fetched by agents during skill execution)
- Policy source area under `gaia-policies/`
- MCP implementation workspace under `mcp/gaia-mcp/`

## Getting Started

### Installation

Install a skill

```bash
npx agent-skills-cli add CFH2026/gaia-agent-skills --skill personality-analyzer
```

This will:
- Download the SKILL.md from `gaia-skills/personality-analyzer/`
- Register the skill in `.claude/skills/<skill-name>/`
- Make the skill available in your agent workspace

### Supported Agents

Currently supported:
- ✅ **Claude Code** — Use `/personality-analyzer` to invoke
- ⏳ **Codex** — Support coming soon

### Running a Skill

Once installed, invoke the skill through Claude Code:

```bash
/personality-analyzer
```

The skill will:
1. Fetch the INSTRUCTION.md from GitHub
2. Load instructions and policies into memory
3. Validate policy compliance
4. Execute the skill workflow