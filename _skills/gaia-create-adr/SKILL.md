---
name: Create ADR (Architecture Decision Record)
description: Create a new ADR file under Entity/Project/adr/
license: CC-BY-4.0
metadata:
  author: Claude Code
  version: 1.0
---

# Create ADR

## Description

Creates a new **ADR-NNN-<title>.md** file under `<Entity>/<Project>/adr/`. ADRs document architectural decisions: the context that required a choice, what was decided, why alternatives were rejected, and what the consequences are.

## Usage

```
/create-adr
```

## Questions Asked

1. **Entity** — Which entity? (GAIA | CDP | LKHS | 產險 | ARK)
2. **Project Slug** — Project identifier (e.g., "modelhub-openai")
3. **ADR Number** — Sequential number for this project (e.g., "001", "002")
4. **Decision Title** — Short title (e.g., "use-api-gateway-for-routing")
5. **Date** — Date of the decision (YYYY-MM-DD)
6. **Decision Maker** — Person who approved/made the decision
7. **Context** — What situation required a decision?
8. **Decision** — What was decided?
9. **Alternatives** — Other options considered (list)
10. **Consequences** — Trade-offs and impacts

## Output

Creates file at: `<Entity>/<Project>/adr/ADR-NNN-<title>.md`

Example: `GAIA/modelhub-openai/adr/ADR-001-use-api-gateway-for-routing.md`

## ADR Numbering

- Numbers are sequential per project (001, 002, 003, ...)
- They reset for each project (each Entity/Project has its own 001, 002, etc.)
- Deprecated/superseded ADRs keep their number but mark status as "Deprecated" or "Superseded by ADR-NNN"

## Template Sections

- Metadata (Date, Status, Decision Maker)
- Context
- Decision
- Alternatives Considered (table: Option | Pros | Cons)
- Consequences
- Related ADRs (if any)
