---
name: gaia-agent-dev
description: Create, validate, and test edge agent skills
license: CC-BY-4.0
metadata:
  author: Platform Team
  version: 1.0
---

## Description

Interactive skill generator that asks business questions and creates complete edge agent skills. Generates:
- `gaia-skills/<skill-name>/SKILL.md` — Skill metadata and instruction URL
- `gaia-instructions/<skill-name>/INSTRUCTION.md` — AI system prompt with step-by-step execution logic

Ensures all generated skills comply with gaia-agent-skills policies (language, privacy, data boundaries).

## Usage

```
/gaia-agent-dev generate
```

## Questions Asked (MVP - Simple)

1. **Skill Name** — What skill are you creating? (lowercase, hyphenated, e.g., approval-workflow)
2. **Description** — What does this skill do? (one sentence)
3. **Steps** — What are the main steps? (2-3 lines)
4. **Read Paths** — What directories can it read? (e.g., /requests, /config)
5. **Write Paths** — What directories can it write? (e.g., /approvals, /archive)
6. **Required Policies** — Which policies apply? (read-files, write-approvals, notify, etc.)

## Output

Creates two files:

**1. Skill Metadata:**
```
gaia-skills/<skill-name>/SKILL.md
├─ Metadata (name, version, policies, timeout)
├─ Overview & description
├─ Reference (instruction URL, dependencies)
└─ Input/output schema
```

**2. AI Instructions:**
```
gaia-instructions/<skill-name>/INSTRUCTION.md
├─ Your Role (agent perspective)
├─ Execution Steps (step-by-step logic)
├─ Constraints & Boundaries (data access, rules)
├─ Error Handling (failure scenarios)
└─ Audit & Logging (what to record)
```

Example output:
```
gaia-skills/approval-workflow/SKILL.md
gaia-instructions/approval-workflow/INSTRUCTION.md
```

## Naming Convention

**Skill names MUST be:**
- Lowercase only
- Hyphenated for multiple words
- Alphanumeric + hyphens only

**Examples:**
- `approval-workflow` (correct)
- `compliance-review` (correct)
- `data-processor` (correct)
- `ApprovalWorkflow` (not allowed - CamelCase)
- `Approval_Workflow` (not allowed - snake_case)
- `approval workflow` (not allowed - spaces)
