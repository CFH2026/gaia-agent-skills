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

## Instruction Structure

Instructions are stored in `gaia-instructions/` and define how AI agents execute skills:

```text
gaia-instructions/
  skill-name/
    INSTRUCTION.md
```

`INSTRUCTION.md` contains:
- **Your Role** — Agent perspective and responsibilities
- **Execution Steps** — Step-by-step workflow logic
- **Constraints & Boundaries** — Data access rules and limits
- **Error Handling** — How to handle failure scenarios
- **Audit & Logging** — What to record and track

### How Instructions Work

1. SKILL.md (installed locally) contains the `instruction_url`
2. When skill is invoked, the agent fetches INSTRUCTION.md from GitHub
3. Instructions are loaded into agent memory
4. Agent executes the skill following the instructions
5. Policies are enforced throughout execution

This design ensures:
- ✅ Instructions are always up-to-date from source
- ✅ Agents follow consistent execution patterns
- ✅ Policies are enforced at runtime
- ✅ No personal data is stored locally

