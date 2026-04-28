# Personality Analyzer Skill

MBTI-based personality assessment that asks 5 questions and reveals your 4-letter personality type.

## Quick Start

### Installation

The skill is installed through the Gaia agent release process. On your local laptop, the SKILL.md is available and will automatically fetch the latest INSTRUCTION.md from GitHub when invoked.

### Invoke the Skill

Through the Gaia agent:
```
invoke personality-analyzer
```

Or through Claude Code:
```
/personality-analyzer
```

## Development & Testing

### Prerequisites
- Node.js 18+ (for running tests)
- Internet connection (to fetch INSTRUCTION.md from GitHub)
- Gaia agent framework installed

### Test in Your Codex Workspace

1. **Clone the repository:**
```bash
git clone https://github.com/CFH2026/gaia-agent-skills.git
cd gaia-agent-skills
```

2. **Navigate to the skill:**
```bash
cd gaia-skills/personality-analyzer
```

3. **Run the skill test:**
```bash
npx gaia-skill-tester personality-analyzer
```

This will:
- Load the SKILL.md metadata
- Fetch INSTRUCTION.md from GitHub
- Execute the skill locally
- Walk you through the 5-question assessment
- Display results

### Manual Testing

If you don't have the test runner installed:

```bash
# View the SKILL.md
cat SKILL.md

# Fetch and view the INSTRUCTION.md
curl https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/refs/heads/main/gaia-instructions/personality-analyzer/INSTRUCTION.md

# Or test directly in Claude Code by invoking the skill
```

### Test Checklist

- [ ] SKILL.md loads without errors
- [ ] INSTRUCTION.md fetches from GitHub
- [ ] All 5 questions display correctly
- [ ] Questions accept A/B/C responses
- [ ] Scoring calculates personality type correctly
- [ ] Results display 4-letter type (e.g., ENFP)
- [ ] Reference link to MBTI framework works
- [ ] No personal data is collected or stored
- [ ] No policy violations occur

## File Structure

```
personality-analyzer/
├── SKILL.md           # Skill metadata & 3-step workflow
└── README.md          # This file
```

Related files in the repository:
```
gaia-instructions/
└── personality-analyzer/
    └── INSTRUCTION.md # Detailed execution instructions
```

## Validation

Ensure the skill complies with:
- ✅ LANGUAGE_AND_PRIVACY_POLICY (English-only, no personal data)
- ✅ APPLICATION_LAUNCH_POLICY (no app launching)
- ✅ No political/sexual/religious questions
- ✅ No email or result forwarding
- ✅ Session-local data only

## Troubleshooting

### INSTRUCTION.md fails to fetch
- Check internet connection
- Verify GitHub URL in SKILL.md is correct
- Try downloading manually:
```bash
curl https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/refs/heads/main/gaia-instructions/personality-analyzer/INSTRUCTION.md
```

### Skill doesn't respond to invocation
- Ensure skill is registered in `.claude/skills/`
- Verify SKILL.md metadata is valid YAML
- Check that `instruction_url` points to valid GitHub location

### Questions not displaying correctly
- Verify INSTRUCTION.md loaded successfully
- Check that markdown parsing works in your agent
- Ensure all 5 questions are present in INSTRUCTION.md

## References

- **MBTI Framework:** https://www.verywellmind.com/the-myers-briggs-type-indicator-2795583
- **Gaia Skills Repository:** https://github.com/CFH2026/gaia-agent-skills
- **Skills Documentation:** `/docs/spec/gaia-agent-skills.md`
