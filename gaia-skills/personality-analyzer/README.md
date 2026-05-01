# Personality Analyzer (Read-Only Distribution)

MBTI-based personality assessment skill with **embedded policy constraints** (policies cannot be bypassed).

## Design Features

### Design Changes ✨
- **Embedded Policies** — All policies are now embedded directly in INSTRUCTION.md (not separate files)
- **No Policy URLs** — There are no separate policy file URLs (prevents URL manipulation)
- **Read-Only Distribution** — SKILL.md cannot be edited to skip policies
- **Single Source of Truth** — Everything is in one INSTRUCTION.md file (fetched fresh each execution)

### Security Improvements 🔒
- ✅ Policies are embedded and cannot be removed via URL editing
- ✅ Users cannot modify policy constraints locally
- ✅ INSTRUCTION.md with embedded policies is always fetched fresh from GitHub
- ✅ No disk persistence (memory-only execution)
- ✅ No way to bypass policy enforcement

### Trade-offs ⚖️
- **Larger INSTRUCTION.md** — Now contains both instructions and policies (was: separate files)
- **Policy Duplication** — Each skill with same policies now has duplicated text (was: shared policy files)
- **Updates** — If policies change, all INSTRUCTION.md files must be updated (was: single policy file update)

---

## Installation

Install the personality-analyzer skill:

```bash
npx agent-skills-cli add CFH2026/gaia-agent-skills --skill personality-analyzer
```

This command will:
- Fetch the skill from the CFH2026/gaia-agent-skills repository
- Install the personality-analyzer skill to your local agent workspace
- Load the SKILL.md metadata (read-only)
- Register the skill for use

## Usage

Once installed, invoke the skill:

```bash
# Through your agent
invoke personality-analyzer

# Or through Claude Code
/personality-analyzer
```

## How It Works (V2 Flow)

```
User: npx agent-skills-cli run personality-analyzer
  ↓
System reads SKILL.md (metadata only, read-only)
  ↓
System fetches INSTRUCTION.md from GitHub
  ↓
INSTRUCTION.md contains:
  - Role definition
  - Execution steps
  - Embedded policies (QUICK_REFERENCE, LANGUAGE_AND_PRIVACY_POLICY, APPLICATION_LAUNCH_POLICY)
  - Constraints & boundaries
  - Error handling
  ↓
System loads ALL into memory
  ↓
System validates policies are enforced:
  ✓ English-only check
  ✓ No personal info check
  ✓ No auto-app-launch check
  ✓ All constraints embedded
  ↓
System executes assessment
  ↓
System discards ALL from memory (no disk persistence)
```

## Testing V2

### Quick Test

```bash
npx agent-skills-cli run personality-analyzer
```

### Verify Policy Enforcement

Test that embedded policies are enforced:

```bash
# The skill should:
✅ Load embedded policies from INSTRUCTION.md
✅ Enforce all policy constraints
✅ Not allow personal information collection
✅ Not send results anywhere
✅ Keep data session-local
```

**Try requesting personal data** during the assessment (name, email, etc.). The skill should politely decline per embedded policy constraints.

### Full Assessment Test

1. Start the skill
2. Answer "yes" when prompted
3. Answer each of the 5 questions with A, B, or C
4. Verify the results show:
   - ✅ Your 4-letter personality type (e.g., ENFP)
   - ✅ Type description
   - ✅ MBTI reference link

### Manual Testing Checklist

- [ ] Skill installs without errors
- [ ] Skill invokes successfully
- [ ] Introduction displays correctly
- [ ] All 5 questions are asked
- [ ] Questions accept A/B/C responses
- [ ] Responses are scored correctly
- [ ] Personality type is calculated
- [ ] Results display with description
- [ ] No personal data is requested
- [ ] No errors during assessment
- [ ] Results can be viewed but not saved/shared
- [ ] **NEW:** Embedded policies are enforced
- [ ] **NEW:** Cannot request personal info (policy blocks it)

### Test Responses Example

To get a specific personality type result:
- **ENFP:** Q1=A, Q2=B, Q3=B, Q4=A, Q5=B
- **ISTJ:** Q1=B, Q2=A, Q3=A, Q4=A, Q5=A
- **INTJ:** Q1=B, Q2=B, Q3=A, Q4=A, Q5=A

---

## Embedded Policies

This skill enforces **three embedded policies** defined directly in INSTRUCTION.md:

### 1. QUICK_REFERENCE (Three Core Rules)
- 🌐 **Language:** English ONLY
- 🔒 **Privacy:** NO personal information
- 🚫 **Applications:** NO automatic app launches

### 2. LANGUAGE_AND_PRIVACY_POLICY
- Detailed rules on what questions are allowed/prohibited
- Privacy constraints on data collection
- Examples of compliant vs. non-compliant code

### 3. APPLICATION_LAUNCH_POLICY
- Prohibits subprocess calls (`subprocess.run()`, `os.system()`)
- Prohibits URL schemes that trigger applications
- Requires user manual control only

All policies are embedded and cannot be disabled, removed, or bypassed.

---

## What This Skill Does

- Asks 5 MBTI personality questions
- Analyzes your responses across 4 dimensions:
  - **E/I** — Extraversion vs. Introversion
  - **S/N** — Sensing vs. Intuition
  - **T/F** — Thinking vs. Feeling
  - **J/P** — Judging vs. Perceiving
- Generates your 4-letter personality type (e.g., ENFP, ISTJ)
- Displays type description and reference materials

## Privacy & Security

This skill complies with:
- ✅ Embedded QUICK_REFERENCE policy for data handling
- ✅ No personal information collection (names, emails, addresses)
- ✅ No political, religious, or sexual questions
- ✅ No application launching or email sending
- ✅ Session-local data only (no persistent storage)
- ✅ **Policies embedded and enforced (V2 improvement)**

## Requirements

- Internet connection (to fetch instructions from GitHub)
- Agent-skills-cli installed (`npm install -g agent-skills-cli`)
- Node.js 18+ (for running the CLI)

## References

- **MBTI Framework:** https://www.verywellmind.com/the-myers-briggs-type-indicator-2795583
- **Gaia Skills Repository:** https://github.com/CFH2026/gaia-agent-skills
- **Skills CLI:** https://github.com/CFH2026/agent-skills-cli

## Troubleshooting

### Installation fails
```bash
npm install -g agent-skills-cli@latest
npx agent-skills-cli add CFH2026/gaia-agent-skills --skill personality-analyzer
```

### Skill doesn't appear after installation
- Restart your agent or IDE
- Verify installation: `npx agent-skills-cli list | grep personality-analyzer`

### INSTRUCTION.md fails to fetch
- Verify internet connection
- Check GitHub URL is accessible
- Ensure repository is public

## Support

For issues about this skill, visit:
https://github.com/CFH2026/gaia-agent-skills/issues

---

## V2 vs V1 Comparison

| Feature | V1 | V2 |
|---------|----|----|
| **Policy Distribution** | Separate files (GitHub URLs) | Embedded in INSTRUCTION.md |
| **Policy URLs** | Yes (can be modified) | No (embedded only) |
| **SKILL.md** | User-editable | Read-only |
| **Policy Bypass Risk** | Medium (URL manipulation) | Low (embedded, memory-only) |
| **File Count** | Multiple (SKILL.md + INSTRUCTION.md + 3 policies) | Two (SKILL.md + INSTRUCTION.md) |
| **Policy Updates** | One file change | Update each INSTRUCTION.md |
| **Discoverability** | Explicit policy references | Policies embedded (less discoverable) |

---

## Future Roadmap

- [ ] Sign/hash INSTRUCTION.md to prevent tampering
- [ ] Hardcode GitHub URLs in npx CLI (prevent local SKILL.md override)
- [ ] Create shared policy library (to reduce duplication)
- [ ] Policy versioning and rollout strategy
