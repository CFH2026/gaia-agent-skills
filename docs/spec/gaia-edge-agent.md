# gaia-edge-agent Specification

## Overview

`gaia-edge-agent` is a policy management and enforcement framework that enables IT/Security teams to define and enforce ground rules on end-user machines. It works in conjunction with `gaia-agent-skills` to ensure that skills executed in AI assistants (Codex, Claude Code, etc.) comply with organizational policies.

## Goals

1. **IT/Security Control:** Define what users can and cannot do across all applications
2. **Decentralized Policies:** Policies managed in a dedicated repository, versioned and auditable
3. **Transparent Enforcement:** Policies visible to end users before execution
4. **Zero Local Storage:** Users cannot read or edit policies on their machines
5. **Simplicity:** Start with MVP, evolve as needed

## Architecture

### Three-Repository System

The system consists of three independent repositories:

1. **gaia-agent-skills**
   - Engineers create and manage skills
   - Skills reference policies they need to check

2. **gaia-agent-policy** (NEW)
   - IT/Security creates and manages policies
   - Policies stored remotely (GitHub)
   - Single source of truth for compliance rules

3. **gaia-edge-agent** (NEW)
   - Documentation and setup guides for end users
   - Optional CLI utility for checking policies
   - Explains how skills and policies work together

### Policy Enforcement Flow

```
1. User invokes skill in Codex/Claude Code
   ↓
2. AI loads SKILL.md file
   ↓
3. AI finds policy URLs in SKILL.md
   ↓
4. AI fetches policy files from gaia-agent-policy (GitHub)
   ↓
5. AI reads natural language restrictions (understands intent)
   ↓
6. AI evaluates structured validation fields
   ↓
7. If allowed → execute skill
   If blocked → refuse with reason
```

**Key Security Property:** Policies are always fetched fresh from GitHub, never cached locally. Users cannot read or modify policies.

## Integration with Skills

### SKILL.md Policy References

Each skill can reference one or more policy files:

```markdown
---
name: code-review
description: Review code changes for correctness and style
version: 1.0.0
policies:
  - https://raw.githubusercontent.com/company/gaia-agent-policy/main/policies/email-policy.yaml
  - https://raw.githubusercontent.com/company/gaia-agent-policy/main/policies/file-policy.yaml
---

Before executing this skill, AI assistants will check the referenced policies.

[Skill instructions...]
```

**Policy URL Format:**
- Must be raw GitHub URLs (can be fetched directly)
- Point to files in gaia-agent-policy repository
- Can reference multiple policies

### Policy Enforcement Responsibility

The AI assistant (Codex, Claude Code, etc.) is responsible for:
1. Fetching policy files from URLs
2. Reading natural language restrictions
3. Evaluating structured validation rules
4. Enforcing policies before skill execution
5. Refusing execution if policy blocks it

## Policy File Format

Policies are defined in the gaia-agent-policy repository using a hybrid format: natural language for AI understanding + structured fields for programmatic validation.

**See: [gaia-agent-policy.md](./gaia-agent-policy.md) for complete policy format specification.**

Quick overview:
- **Natural Language:** `restriction` field explains the rule in plain English for AI assistants
- **Structured Validation:** `structured_validation` section defines machine-readable constraints
- **Metadata:** Policy name, version, severity, maintainers

Example restriction:
```
Do not send emails with more than 100 recipients.
Do not send to distribution lists that include the entire company.
```

Example structured validation:
```yaml
type: email
field: recipients
maxCount: 100
blockedRecipients:
  - "company-all@example.com"
```

## gaia-agent-policy Repository

The gaia-agent-policy repository is a dedicated repository where IT/Security teams create and manage all organizational policies.

**See: [gaia-agent-policy.md](./gaia-agent-policy.md) for complete specification.**

Quick overview:
- IT/Security manages policies in YAML format
- Policies stored in flat structure for MVP (can reorganize later)
- Policy changes tracked via Git with semantic versioning
- No deployment needed—policies fetched on demand from GitHub
- Each policy includes natural language restrictions + structured validation rules

## gaia-edge-agent Repository

### Purpose

Provides documentation, setup guides, and optional utilities for end users to understand and use the policy system.

### Contents

```
gaia-edge-agent/
├── README.md                          # Overview and setup
├── CONTRIBUTING.md                    # How to contribute
├── docs/
│   ├── getting-started.md            # Step-by-step setup
│   ├── understanding-policies.md      # Policy concepts
│   ├── troubleshooting.md            # Common issues
│   └── faq.md                        # Frequently asked questions
├── examples/
│   ├── skill-with-policies.md        # Example SKILL.md
│   ├── sample-email-policy.yaml      # Example policy
│   └── setup-instructions.md         # Setup guide
└── cli/                              # Optional CLI utility
    └── check-policy.js               # Check applicable policies
```

### Documentation Files

**README.md:**
- What gaia-edge-agent is
- How it works with gaia-agent-skills and gaia-agent-policy
- Quick start guide
- Links to three-repo system

**getting-started.md:**
- Prerequisites (Codex/Claude Code installation)
- How to enable policy checking
- Verification steps

**understanding-policies.md:**
- What policies are
- How they apply to skills
- How to read policy files
- How enforcement works

**troubleshooting.md:**
- Common issues and solutions
- How to report policy violations
- When to contact IT/Security

### Optional CLI Utility

Simple command-line tool for end users to check applicable policies:

```bash
npx gaia-edge-agent check-policy --skill code-review
# Output: Lists policies that apply to code-review skill
```

Functionality:
- Fetch policy URLs from SKILL.md
- Download and display applicable policies
- Show natural language restrictions
- Highlight structured validation rules

## Workflow

### For IT/Security (Policy Creation)

1. Define new policy in gaia-agent-policy repo
2. Use provided template: `policies/sample-policy.yaml`
3. Write natural language `restriction` field
4. Define `structured_validation` fields
5. Create pull request
6. Review and merge to main
7. Policy immediately available to all skills referencing it

### For Engineers (Skill Creation)

1. Create skill in gaia-agent-skills
2. Write SKILL.md with skill instructions
3. Identify what policies apply to this skill
4. Add `policies:` section with URLs to gaia-agent-policy
5. Create pull request
6. Merge to main
7. Skill is now policy-aware

### For End Users

1. Install Codex/Claude Code normally
2. Read gaia-edge-agent documentation
3. Understand that skills check policies
4. When invoking skill:
   - Codex fetches and evaluates policies
   - If allowed → skill executes
   - If blocked → see reason why
5. Optional: Use CLI to check policies before executing

## Policy Categories (MVP Flat Structure)

**email-policy.yaml**
- Email recipient restrictions
- Sensitive data in emails
- Distribution list rules

**file-policy.yaml**
- File download restrictions
- File type restrictions
- Publication restrictions

**access-policy.yaml**
- Directory access restrictions
- API endpoint restrictions
- Resource access control

**data-policy.yaml**
- Data classification rules
- Personally Identifiable Information (PII) handling
- Confidential data protection

**Future:** Can reorganize into domain folders if needed.

## Security Properties

### What is Protected

✅ **Policies cannot be read locally** — Always fetched fresh from GitHub  
✅ **Policies cannot be edited by users** — No local copies  
✅ **Policies are auditable** — Enforced by AI with natural language reasoning  
✅ **Policies are versioned** — All changes tracked in Git  
✅ **Policies are distributed** — No centralized service needed  

### What is NOT Protected

❌ Users can see policy text when policies are fetched (required for enforcement)  
❌ Users can refuse to execute skills (choice to comply)  
❌ Determined users can inspect network traffic (policy URLs are visible)  

**Design Assumption:** Policies are compliance rules, not security secrets. Transparency is important for user understanding.

## Integration Points

### With gaia-agent-skills

- Skills list policy URLs in SKILL.md
- No other integration needed
- Skills don't need to know about gaia-edge-agent

### With Codex/Claude Code

- AI tools read `policies:` field in SKILL.md
- Fetch policy files from URLs
- Understand natural language restrictions
- Evaluate structured validation rules
- Enforce policies before execution

### With Company Infrastructure

- Policies stored in company GitHub
- IT/Security manages gaia-agent-policy repo
- Access control via GitHub permissions
- No external dependencies

## Implementation Notes

### MVP Scope

- Flat policy structure (no domains yet)
- Simple YAML format
- AI-based enforcement (no centralized service)
- Documentation + optional CLI only

### Future Enhancements

- Policy validation service (MCP)
- Policy audit logging
- Policy templates and inheritance
- Role-based policies (different rules for different user groups)
- Automated policy compliance reports
- Policy conflict detection

## Examples

### Example: Skill with Email Policy

**SKILL.md:**
```markdown
---
name: send-notification
description: Send notification to users
version: 1.0.0
policies:
  - https://raw.githubusercontent.com/company/gaia-agent-policy/main/policies/email-policy.yaml
---

This skill sends email notifications. Check email policy before sending.
```

**Execution:**
1. User invokes `/send-notification`
2. Codex fetches email-policy.yaml
3. Codex reads: "maxRecipients: 100"
4. User requests 500 recipients
5. Codex refuses: "Email policy restricts to 100 recipients"

### Example: Multiple Policies

```markdown
---
name: export-data
description: Export data to file
version: 1.0.0
policies:
  - https://raw.githubusercontent.com/company/gaia-agent-policy/main/policies/file-policy.yaml
  - https://raw.githubusercontent.com/company/gaia-agent-policy/main/policies/data-policy.yaml
---
```

This skill checks both file restrictions and data classification policies.

## FAQ

**Q: Can end users bypass policies?**  
A: No. Policies are enforced by the AI assistant itself, and users cannot modify policies.

**Q: How are policies updated?**  
A: Push new version to gaia-agent-policy repo. Policies are fetched fresh on next skill invocation.

**Q: What if a skill doesn't reference any policies?**  
A: It executes without policy checks (IT/Security responsibility to add policies).

**Q: Do policies apply to all AI tools?**  
A: Only to tools that read the `policies:` field in SKILL.md. Universal support depends on tool implementation.

**Q: What happens if policy URL is unreachable?**  
A: Codex should fail safely and refuse execution (can't verify compliance).
