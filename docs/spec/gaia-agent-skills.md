# Gaia Agent Skills Repository Initial Design Specification

## Overview

`gaia-agent-skills` is the Gaia team repository for authoring, reviewing, and releasing shareable AI assistant skills. The repository also holds policy source content and the MCP server workspace that serves skills and policies to consumers. Approved skills are distributed to individual local laptops for use with the Gaia edge agent workflow.

## Design Goals

1. **Single source of truth:** Keep all skill source files and repository guidance in one place
2. **Consistent structure:** Use a predictable directory layout and README pattern across skills and policies
3. **Local-laptop release:** Make approved skills available on individual laptops through the Gaia release process
4. **Policy compliance:** Ensure skills stay aligned with language, privacy, and security rules
5. **Simple authoring:** Make it easy for engineers to create and review skills without extra framework overhead

## Repository Scope

This repository contains:

- Repo-workflow skill source files under `_skills/<skill-name>/`
- Release-oriented skill source files under `gaia-skills/<skill-name>/`
- Policy source files under `gaia-policies/<policy-name>/`
- MCP server workspace under `mcp/gaia-mcp/`
- Repository documentation, including this spec and the README
- Policy and compliance guidance for skills and policies
- Optional local documentation for individual skills and policies

This repository does not define:

- A public marketplace or external install catalog
- A generic skill registry service
- The transport mechanism used to release skills to laptops
- Any application-launch behavior or operating-system automation

## Repository Model

### Skill Trees

This repository uses two skill trees with different purposes:

| Tree | Purpose |
|------|---------|
| `_skills/` | Skills used by agents while working in this repository |
| `gaia-skills/` | Engineer-built skills intended for release to other users |

Each skill is self-contained in its own directory:

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

### File Responsibilities

| File | Required | Purpose |
|------|----------|---------|
| `SKILL.md` | Yes | Skill metadata and instructions for the assistant |
| `README.md` | No | Optional local context, examples, or usage notes |

### Naming Rules

- Skill directories use kebab-case
- Skill names in `SKILL.md` use kebab-case
- README content must be English-only
- Skill content must follow repository privacy and language policies

## README Standard Pattern

The repository README should follow a short, stable structure:

1. Title
2. Short repository purpose statement
3. What this repo is
4. Skill structure
5. Create a new skill
6. Submit a skill
7. How skills reach end users
8. Reference material

The README should stay focused on repository purpose and authoring guidance. It should not include public installation commands or a long skills catalog unless the team explicitly decides to add one.

## Policy Model

Policies live under `gaia-policies/` and are served through MCP.

### Policy Trees

| Tree | Purpose |
|------|---------|
| `gaia-policies/` | Engineer-authored policies and rules that skills can reference |
| `mcp/gaia-mcp/` | MCP server code and derived manifests that expose policies |

### Policy File Responsibility

| File | Required | Purpose |
|------|----------|---------|
| `POLICY.md` | Yes | Policy metadata and rules for MCP serving |
| `README.md` | No | Optional local context, examples, or usage notes |

## Skill Authoring Model

### Skill Creation

To create a new skill:

1. Create a new directory under `_skills/`
2. Or create a new directory under `gaia-skills/` if the skill is intended for release
3. Add a `SKILL.md` file with YAML frontmatter
4. Write the assistant instructions in Markdown
5. Add an optional `README.md` if the skill needs supporting notes or examples

### Skill Validation

Before release, each skill must be checked for:

- Valid Markdown formatting
- Required `SKILL.md` frontmatter fields
- English-only user-facing text
- Privacy compliance
- Alignment with the repo’s policy documents

### Skill Lifecycle

1. Author adds or updates the skill in the correct tree
2. Reviewers check the skill and related documentation
3. Approved changes are merged
4. The release process publishes `gaia-skills/` content to local laptops
5. End users invoke the released skill through the Gaia edge agent workflow

## Release Model

Approved skills are released from this repository to individual local laptops. The repository is the source of the skill definition, while the release process is responsible for making the skill available to end users.

Only skills in `gaia-skills/` are considered release-oriented. Skills in `_skills/` are for repository-local agent work and do not imply end-user release.

## MCP Model

The MCP server in `mcp/gaia-mcp/` serves authored content from `gaia-skills/` and `gaia-policies/`.

### MCP Responsibilities

- Resolve skill content from `gaia-skills/`
- Resolve policy content from `gaia-policies/`
- Serve derived manifests for skill-policy mappings
- Keep implementation code separate from source content

### MCP Non-Goals

- MCP does not own skill or policy source files
- MCP does not replace the review process for authored content
- MCP does not define end-user release transport

### Release Principles

- Skills should be released only after review and approval
- The repo should not expose a public install flow in the README
- The exact delivery mechanism may evolve without changing the repository contract
- End-user guidance belongs in the edge-agent documentation, not in the skill source repository

## Policy and Compliance

All skills in this repository must comply with the repository’s policy documents, including:

- English-only user-facing content
- No requests for personal or identifying information
- No automatic application launching
- Any additional repo policy or launch constraint

Skill authors and reviewers should treat the policy documents as part of the definition of “done.”

## Documentation Requirements

The repository should keep these documents current:

- `README.md` for the high-level repo overview
- `docs/spec/gaia-agent-skills.md` for the repository design contract
- `docs/spec/gaia-agent-policy.md` for policy content structure and governance
- `policies/` for language, privacy, and launch constraints
- Individual skill `README.md` files only when they add value for that skill

## Non-Goals

This repository initial design does not attempt to:

- Define a runtime policy engine
- Define a public skill store
- Define the detailed release transport to laptops
- Define user-specific configuration storage

## Open Questions

- What exact release mechanism will publish skills to local laptops?
- Which team owns the release pipeline and operational support?
- Should the repository eventually maintain a generated skill index, or keep the README minimal?
