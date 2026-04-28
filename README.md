# gaia-agent-skills

This repository contains the Gaia team’s authored skill and policy content, plus the MCP server workspace that serves that content.

## Repository Layers

- `_skills/` for skills used by agents while working in this repository
- `gaia-skills/` for engineer-built skills intended for release to other users and local laptops
- `gaia-policies/` for engineer-authored policies and rules that skills can reference
- `mcp/gaia-mcp/` for the MCP server implementation that serves skills and policies

## What This Repo Is

- Source repository for Gaia team skills
- Canonical place for skill and policy definitions and instructions
- Working area for repo-local agent skills under `_skills/`
- Release-oriented skill area under `gaia-skills/`
- Policy source area under `gaia-policies/`
- MCP implementation workspace under `mcp/gaia-mcp/`

## Skill Structure

Each skill lives in its own directory under one of the skill trees:

```text
_skills/
  skill-name/
    SKILL.md
    README.md

gaia-skills/
  skill-name/
    SKILL.md
    README.md
```

`SKILL.md` is required in both trees. `README.md` is optional and can be used for local guidance or examples.

## Policy Structure

Policies live in their own directories under `gaia-policies/`:

```text
gaia-policies/
  policy-name/
    POLICY.md
    README.md
```

`POLICY.md` is required. `README.md` is optional.

## MCP Structure

The MCP server lives under `mcp/gaia-mcp/`:

```text
mcp/gaia-mcp/
  src/
  config/
  manifests/
  tests/
```

The MCP server serves authored content from `gaia-skills/` and `gaia-policies/`. It does not own the source content.

## Create a New Skill

1. Create a new directory under `_skills/` if the skill is for repo work.
2. Create a new directory under `gaia-skills/` if the skill is intended for release to other users.
3. Add a `SKILL.md` file with YAML frontmatter and Markdown instructions.
4. Keep the instructions focused, English-only, and aligned with repo policies.
5. Add an optional `README.md` if the skill needs extra context or examples.

## Create a New Policy

1. Create a new directory under `gaia-policies/`.
2. Add a `POLICY.md` file with YAML frontmatter or the agreed policy format.
3. Keep policy text clear, English-only, and suitable for MCP serving.
4. Add an optional `README.md` if the policy needs supporting notes or examples.

## Submit a Skill

1. Create your branch from the active development branch used by the team.
2. Add or update the skill files in the correct skill tree.
3. Open a pull request for review.
4. Make sure the skill matches the language, privacy, and policy guidance in this repository.
5. Merge only after review and approval.

## How Content Is Served

- Skills from `gaia-skills/` are released from this repository to individual local laptops.
- Policies from `gaia-policies/` are served through MCP as reference rules for skills.
- Users then invoke the released skills through the Gaia edge agent workflow.
- The exact delivery mechanism is handled by the team’s release process.

## Reference Material

- [Skill repository specification](docs/spec/gaia-agent-skills.md)
- [Policy specification](docs/spec/gaia-agent-policy.md)
- [Edge agent specification](docs/spec/gaia-edge-agent.md)
- [Language and privacy policy](gaia-policies/LANGUAGE_AND_PRIVACY_POLICY.md)
- [Compliance checklist](gaia-policies/COMPLIANCE_CHECKLIST.md)
