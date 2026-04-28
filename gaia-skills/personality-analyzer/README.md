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

## Testing

### Quick Test

After installation, test the skill immediately:

```bash
# Invoke the skill
npx agent-skills-cli run personality-analyzer

# Or through your agent
invoke personality-analyzer
```

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

### Test Responses Example

To get a specific personality type result:
- **ENFP:** Q1=A, Q2=B, Q3=B, Q4=A, Q5=B
- **ISTJ:** Q1=B, Q2=A, Q3=A, Q4=A, Q5=A
- **INTJ:** Q1=B, Q2=B, Q3=A, Q4=A, Q5=A

### Verify Policy Compliance

Test that policies are enforced:

```bash
# The skill should:
✅ Fetch policies from GitHub
✅ Load policies before execution
✅ Enforce all policy constraints
✅ Not collect personal information
✅ Not send results anywhere
✅ Keep data session-local
```

Try requesting personal data (name, email, etc.) during the assessment. The skill should politely decline and redirect to the personality questions.

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
