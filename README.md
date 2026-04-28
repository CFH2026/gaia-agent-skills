# gaia-agent-skills

This repository contains the Gaia team’s authored skill and policy content, plus the MCP server workspace that serves that content.

## Repository Layers

- `gaia-skills/` for engineer-built skills intended for release to other users and local laptops
- `gaia-instructions/` for AI agent execution instructions that accompany skills
- `gaia-policies/` for engineer-authored policies and rules that skills can reference

## What This Repo Is

- Source repository for Gaia team skills
- Canonical place for skill and policy definitions and instructions
- Release-oriented skill area under `gaia-skills/`
- AI execution instructions area under `gaia-instructions/` (fetched by agents during skill execution)
- Policy source area under `gaia-policies/`

## Getting Started

### Installation

**Step 1: Install the skill from GitHub**
```bash
npx agent-skills-cli add CFH2026/gaia-agent-skills --skill personality-analyzer
```

This command:
- Downloads the SKILL.md from `gaia-skills/personality-analyzer/`
- Prepares the skill for installation in your workspace

**Step 2: Select your LLM workspace**

Choose whether you want to install to Claude Code or Codex:
```bash
# Register skill in Claude Code workspace
# ✅ Installs to ~/.claude/skills/<skill-name>/

# Register skill in Codex workspace  
# ✅ Installs to ~/.codex/skills/<skill-name>/
```

The installation registers the skill and makes it available in your chosen workspace.

### Running a Skill

Once installed, invoke the skill using your agent's syntax:

**Claude Code:**
```bash
/personality-analyzer
```

**Codex:**
```bash
invoke personality-analyzer
```

### What Happens When You Run a Skill

The skill workflow:
1. Fetches the INSTRUCTION.md from GitHub (requires internet access)
2. Loads instructions and policies into agent memory
3. Validates policy compliance
4. Executes the skill with your agent

