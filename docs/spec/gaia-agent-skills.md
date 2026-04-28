# gaia-agent-skills Specification

## Overview

`gaia-agent-skills` is a template repository for teams within the company to create, manage, and distribute shareable AI assistant skills. It enables teams to maintain their own skill repositories while providing a standardized format and distribution mechanism.

## Goals

1. **Team Autonomy:** Each team can clone and manage their own skills repository
2. **Ease of Use:** Both technical and non-technical users can install and use skills
3. **Security:** Users cannot read or edit skills locally, preventing unauthorized modifications
4. **Quality:** CI/CD pipeline ensures skill quality before distribution
5. **Simplicity:** Minimal setup required for teams to get started

## Architecture

### Distribution Model

- **Repository Type:** Decentralized - Each team owns their own GitHub repository
- **Access Control:** Managed via GitHub permissions (private, internal, or public repos)
- **Installation Method:** Command-line via `npx` utility
- **Fetching Strategy:** On-demand from GitHub (no local caching of skill content)

### Installation Model

**Command:**
```bash
npx skills add @team-a/skills --skills code-review,grill-me
```

**What Gets Stored Locally:**
```json
{
  "team": "team-a",
  "repo": "https://github.com/team-a/skills",
  "installedSkills": ["code-review", "grill-me"]
}
```

**Key Constraint:** Only metadata and configuration are stored locally. No skill files are cached.

### Skill Structure

Each skill is self-contained in its own directory:

```
_skills/
  skill-name/
    SKILL.md          (required - metadata + format)
    script.py         (optional - Python implementation)
    tool.sh           (optional - Shell script implementation)
    README.md         (optional - local documentation)
```

### SKILL.md Format

Every skill must have a `SKILL.md` file with YAML frontmatter and Markdown content:

```markdown
---
name: code-review
description: Review code changes for correctness, style, and potential issues
version: 1.0.0
---

[Markdown instructions for the AI assistant...]
```

**Frontmatter Fields:**
- `name` (required): Skill identifier, kebab-case
- `description` (required): One-line description of what the skill does
- `version` (optional): Semantic version
- Additional metadata as needed

### Execution Flow

1. **User invokes skill:** `/code-review`
2. **System looks up configuration:** Finds `team-a/code-review` in installed skills
3. **Fetch from GitHub:** `https://raw.githubusercontent.com/team-a/skills/main/_skills/code-review/SKILL.md`
4. **Execute:** AI assistant reads and executes the instructions

**Security Implication:** Users cannot read or modify skills because they are fetched fresh from GitHub on every invocation. Nothing is cached locally.

## Template Repository Contents

### Essential Files

```
.
├── README.md                      # How to use template, create skills, setup
├── LICENSE                        # MIT or company license
├── CONTRIBUTING.md                # Guidelines for creating skills
├── .github/
│   └── workflows/
│       └── ci.yml               # CI/CD pipeline
└── _skills/
    ├── example-skill-1/
    │   └── SKILL.md
    └── example-skill-2/
        └── SKILL.md
```

### README.md

Should include:
- What this repository is
- How to create a new skill
- How to submit a skill (PR process)
- How users install skills from this repository
- Links to the template specification

### CONTRIBUTING.md

Should document:
- Skill creation guidelines
- SKILL.md format requirements
- Code quality standards
- PR review process
- Testing requirements

### CI/CD Pipeline (.github/workflows/ci.yml)

Runs on every pull request:

1. **Validation**
   - Check SKILL.md files exist in all skill directories
   - Validate YAML frontmatter format
   - Verify required fields (`name`, `description`)

2. **Testing**
   - Run tests for Python/Shell implementation files
   - Execute linting on code files

3. **Linting**
   - Lint Markdown files
   - Check code style for Python/Shell scripts

4. **Documentation**
   - Verify skill descriptions are meaningful
   - Check for required documentation

### Example Skills

The template includes 2-3 example skills demonstrating:
- Markdown-only skill format
- Skill with Python implementation
- Skill with Shell script implementation

## Team Customization

### Lock in Place (Same Across All Teams)

- Folder structure: `_skills/{name}/SKILL.md` format
- CI/CD pipeline: Validation, testing, linting logic
- SKILL.md frontmatter format: `name`, `description` fields
- CONTRIBUTING.md structure

### Customize Per Team

- Team name and description in README
- Example skills (replace with team-specific examples)
- Additional frontmatter fields specific to team
- Team-specific CI/CD checks (additional linters, test frameworks)
- LICENSE file (if using company-specific license)

## Workflow

### For Skill Creators (Engineers)

1. Clone template repository
2. Create new skill: `mkdir -p _skills/my-skill && touch _skills/my-skill/SKILL.md`
3. Write SKILL.md with frontmatter and instructions
4. Optional: Add implementation files (Python, Shell)
5. Create pull request
6. CI/CD validates skill
7. Team review and approve
8. Merge to main branch

### For Skill Installation (Engineer Helping End User)

1. User requests to install skills
2. Engineer runs: `npx skills add @team-a/skills --skills skill-1,skill-2`
3. System registers team repo and skill names locally
4. End user can now invoke installed skills

### For Skill Execution (End User)

1. Invoke skill in Codex/Claude Code: `/skill-name`
2. System fetches latest SKILL.md from GitHub
3. AI assistant executes instructions
4. No local skill files are read or stored

## Technical Specifications

### Supported Skill Types

1. **Markdown-only Skills**
   - Pure instructions for AI assistants
   - No implementation code

2. **Python Skills**
   - SKILL.md for instructions
   - `script.py` or multiple Python files
   - Optional requirements.txt

3. **CLI/Shell Skills**
   - SKILL.md for instructions
   - `.sh` shell scripts or other executables

### Version Management

- Each skill can have its own version in SKILL.md
- Team repository uses Git tags for major releases
- Users always get the latest version (fetched from main branch)

### Naming Conventions

- Skill directories: kebab-case (e.g., `code-review`)
- Skill names in frontmatter: kebab-case
- GitHub repository: kebab-case (e.g., `team-a-skills`)
- npm package: lowercase, hyphens (e.g., `@company/team-a-skills`)

## Security & Access Control

### Preventing Local Reading/Editing

- **No local skill files:** Only configuration stored locally
- **On-demand fetching:** SKILL.md fetched from GitHub on every invocation
- **No caching:** Fresh copy retrieved each time, preventing stale/modified versions
- **GitHub permissions:** Team controls who can view/edit skills via repository access

### Access Levels

- **Read:** User can invoke installed skills (cannot see source)
- **Edit:** Engineers in the team can create/modify skills via PR process
- **Admin:** Team leads manage repository settings and access

## Future Extensibility

This specification is designed to support future enhancements:

- **Versioning:** Add version pinning to installed skills (v1.0.0 vs latest)
- **Skill Registry:** Central catalog of all available skills across teams
- **Compiled Skills:** Option to compile/encrypt skills before distribution via npm
- **Offline Mode:** Optional local caching with periodic sync daemon
- **Dependency Management:** Skills depending on other skills

## Implementation Notes

- npx utility handles GitHub URL parsing and integration
- Codex/Claude Code system responsible for fetching and executing skills
- GitHub Actions provides CI/CD environment
- No external service dependencies required beyond GitHub
