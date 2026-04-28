# Gaia Edge Agent Specification

## Overview

`gaia-edge-agent` is the user-facing documentation and operational model for running Gaia skills and policy-aware skill execution on end-user machines.

It works with:

- `gaia-skills/` for release-oriented skills
- `gaia-policies/` for policy source content
- `mcp/gaia-mcp/` for MCP serving of skills and policies

## Goals

1. **End-user clarity:** Explain how skills and policies are used on local laptops
2. **Policy awareness:** Make policy checks part of the skill execution model
3. **MCP alignment:** Describe the MCP-based serving path for skills and policies
4. **Low friction:** Keep setup guidance simple for end users
5. **Auditability:** Keep the policy and skill sources reviewable in the repository

## Architecture

### Component Model

The edge-agent model is made of three repository areas:

1. **gaia-skills/**
   - Release-oriented skills authored by engineers
   - Skills contain instructions and policy references

2. **gaia-policies/**
   - Policy source files authored by IT/Security or governance owners
   - Policies are served through MCP

3. **mcp/gaia-mcp/**
   - MCP server implementation
   - Serves skill and policy resources to clients

### Execution Flow

```text
1. User invokes a skill
2. MCP resolves the skill from gaia-skills/
3. The skill references one or more policies
4. MCP resolves the policy content from gaia-policies/
5. The assistant evaluates the policy text and validation rules
6. If allowed, the skill runs
7. If blocked, the assistant explains why
```

## Skill and Policy Interaction

Skills should declare the policies they rely on in their metadata so the MCP layer can resolve them deterministically.

Recommended pattern:

```text
gaia-skills/<skill-name>/SKILL.md
  policies:
    - policy://gaia-policies/email-policy
    - policy://gaia-policies/file-policy
```

## End-User Documentation

The edge-agent documentation should explain:

- What skills are available
- How policies affect skill execution
- How the MCP layer resolves skills and policies
- What to do when a skill is blocked by policy

## Non-Goals

- This spec does not define policy authoring
- This spec does not define the MCP implementation details
- This spec does not define release automation
- This spec does not define application-launch behavior
