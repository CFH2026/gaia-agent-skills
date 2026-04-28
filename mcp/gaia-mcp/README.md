# gaia-mcp

MCP server workspace for serving Gaia skills and Gaia policies.

## Purpose

- Serve release-oriented skills from `gaia-skills/`
- Serve policy content from `gaia-policies/`
- Provide manifest and resource handling for MCP clients

## Proposed Layout

```text
mcp/gaia-mcp/
  README.md
  src/
    README.md
  config/
    README.md
  manifests/
    README.md
  tests/
    README.md
```

## Folder Roles

- `src/` holds MCP server implementation code
- `config/` holds server configuration and runtime settings
- `manifests/` holds derived indexes and mapping files
- `tests/` holds MCP server tests and fixtures

## Notes

- This directory is a scaffold for the MCP implementation.
- Keep the content source of truth in the repository trees, not in duplicated copies here.
