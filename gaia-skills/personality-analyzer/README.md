# Personality Analyzer

MBTI-based personality assessment skill that asks 5 questions and reveals your 4-letter personality type.

## Installation

Install the personality-analyzer skill using the agent-skills-cli:

```bash
npx agent-skills-cli add CFH2026/gaia-agent-skills --skill personality-analyzer
```

This command will:
- Fetch the skill from the CFH2026/gaia-agent-skills repository
- Install the personality-analyzer skill to your local agent workspace
- Load the SKILL.md metadata
- Register the skill for use

## Usage

Once installed, invoke the skill:

```bash
# Through your agent
invoke personality-analyzer

# Or through Claude Code
/personality-analyzer
```

## What This Skill Does

- Asks 5 MBTI personality questions
- Analyzes your responses across 4 dimensions:
  - **E/I** — Extraversion vs. Introversion
  - **S/N** — Sensing vs. Intuition
  - **T/F** — Thinking vs. Feeling
  - **J/P** — Judging vs. Perceiving
- Generates your 4-letter personality type (e.g., ENFP, ISTJ)
- Displays type description and reference materials

## How It Works

The skill follows a 5-step execution workflow:

1. **Fetch Policies & Instructions** — Load policies and instructions from GitHub
2. **Load to Memory** — Parse all content into agent context
3. **Validate Policies** — Verify skill compliance with policies
4. **Apply Policies** — Enforce policy constraints during execution
5. **Execute** — Run the 5-question personality assessment

## Requirements

- Internet connection (to fetch instructions and policies from GitHub)
- Agent-skills-cli installed (`npm install -g agent-skills-cli`)
- Node.js 18+ (for running the CLI)

## Privacy & Security

This skill complies with:
- ✅ QUICK_REFERENCE policy for data handling
- ✅ No personal information collection (names, emails, addresses)
- ✅ No political, religious, or sexual questions
- ✅ No application launching or email sending
- ✅ Session-local data only (no persistent storage)

## References

- **MBTI Framework:** https://www.verywellmind.com/the-myers-briggs-type-indicator-2795583
- **Gaia Skills Repository:** https://github.com/CFH2026/gaia-agent-skills
- **Skills CLI:** https://github.com/CFH2026/agent-skills-cli

## Troubleshooting

### Installation fails
```bash
# Ensure agent-skills-cli is updated
npm install -g agent-skills-cli@latest

# Then try installing again
npx agent-skills-cli add CFH2026/gaia-agent-skills --skill personality-analyzer
```

### Skill doesn't appear after installation
- Restart your agent or IDE
- Verify installation with: `npx agent-skills-cli list`
- Check that skill is in your local skills directory

### INSTRUCTION.md fails to fetch during execution
- Verify internet connection
- Check GitHub URL is accessible
- Ensure repository is public or you have access

## Support

For issues or questions about this skill, visit:
https://github.com/CFH2026/gaia-agent-skills/issues
