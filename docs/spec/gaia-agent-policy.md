# Gaia Policies Repository Specification

## Overview

`gaia-policies` is the policy source tree in this repository. It contains engineer-authored rules that can be referenced by skills and served through `mcp/gaia-mcp/`.

## Goals

1. **Single source of truth:** Keep policy definitions in one place
2. **MCP-ready serving:** Make policies easy to expose through MCP resources
3. **Reviewable content:** Keep policies versioned and easy to audit
4. **Reusable rules:** Allow multiple skills to reference the same policy
5. **Simple structure:** Keep policy authoring lightweight and consistent

## Repository Scope

This tree contains:

- Policy source files under `gaia-policies/<policy-name>/`
- Optional local documentation for each policy
- Content that the MCP server serves to consumers

This tree does not contain:

- MCP implementation code
- Skill instructions
- End-user deployment logic
- Application-launch behavior

## Policy Tree Layout

```text
gaia-policies/
  policy-name/
    POLICY.md
    README.md
```

### File Roles

| File | Required | Purpose |
|------|----------|---------|
| `POLICY.md` | Yes | Policy metadata, rules, and structured validation fields |
| `README.md` | No | Optional supporting notes or examples |

## Policy Format

Policies should use a stable, machine-readable structure that MCP can serve and skills can reference.

Recommended fields:

- `name`
- `description`
- `version`
- `rules`
- `maintainers`

Each rule should include:

- `id`
- `name`
- `description`
- `restriction`
- optional `structured_validation`

## MCP Serving Model

The MCP server under `mcp/gaia-mcp/` reads policy content from `gaia-policies/` and exposes it to consumers.

### Responsibilities

- Serve policy content by stable identifier
- Expose policy metadata for skill-policy mapping
- Keep policy source content in the repository tree

### Non-Goals

- MCP does not author policies
- MCP does not replace policy review and approval
- MCP does not define skill behavior

## Policy Organization

Policies may be grouped by domain if needed, but the initial model should stay simple and easy to scan.

Example domains:

- `email-policy`
- `file-policy`
- `access-policy`
- `data-policy`

## Governance

- Policy updates should be reviewed before merge
- Policy changes should remain backward-compatible where possible
- Breaking policy changes should be versioned explicitly
- Skills that reference policies should update their references when needed

## Documentation Requirements

Each policy should have enough documentation for a reviewer to understand:

- What the policy controls
- Which skills can reference it
- Whether the policy is stable or versioned
- Any structured validation fields used by MCP
