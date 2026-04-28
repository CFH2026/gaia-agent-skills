# Language and Privacy Policy - Compliance Checklist

Use this checklist when reviewing skills for compliance with the Language and Privacy Policy.

---

## Pre-Submission Checklist (For Skill Creators)

Before submitting a pull request, verify:

### Language Compliance
- [ ] All user-facing prompts are in English
- [ ] All error messages are in English
- [ ] All help text and documentation are in English
- [ ] All code comments are in English (or code is self-documenting)
- [ ] No language detection or multilingual features
- [ ] No language preference questions
- [ ] No translations or alternate language outputs

### Personal Information Compliance
- [ ] No questions ask for real names
- [ ] No questions request email addresses
- [ ] No questions request phone numbers
- [ ] No questions request physical addresses
- [ ] No questions ask for birthdates (unless non-identifying)
- [ ] No questions request financial information
- [ ] No questions ask for authentication credentials
- [ ] No questions request identification numbers
- [ ] No location/GPS data collection
- [ ] No device-specific identifiers collected
- [ ] No family/relationship information requested
- [ ] No sensitive personal preferences requested
- [ ] No behavioral tracking implemented
- [ ] No health information collected

### Data Handling
- [ ] No personal data is persisted across sessions
- [ ] No personal data is logged to files
- [ ] No personal data is sent to external services
- [ ] No profiling based on user responses
- [ ] Data collection (if any) is clearly explained
- [ ] Users can decline participation
- [ ] Non-personal data is only retained as needed

### Documentation
- [ ] SKILL.md includes data collection statement
- [ ] README.md explains privacy approach
- [ ] Documentation is clear about what data (if any) is collected
- [ ] Purpose of any data collection is explained
- [ ] No reference to multi-language support

---

## Code Review Checklist (For Reviewers)

When reviewing a skill pull request:

### Step 1: Language Check
- [ ] Search code for non-English strings in prompts
- [ ] Check all print/output statements are English
- [ ] Review all UI/interactive text is English
- [ ] Verify no language switching logic exists
- [ ] Check documentation for English-only content

**Command to assist:**
```bash
grep -r "[^a-zA-Z0-9\s\.\,\!\?\-\(\)\:\/\\\"\'\&]" _skills/skill-name/ | grep -v ".git"
```

### Step 2: Personal Information Check
- [ ] Read all questions asked by the skill
- [ ] Check all input validation and prompts
- [ ] Search for terms like: "name", "email", "phone", "address", "ssn", "password"
- [ ] Review what data is stored or logged
- [ ] Check for third-party data sharing
- [ ] Verify consent flows (if any)

**Prohibited terms to search for:**
```bash
grep -i -E "name|email|phone|address|ssn|password|credit|bank|health|medical|location" _skills/skill-name/
```

### Step 3: Documentation Review
- [ ] SKILL.md exists and has frontmatter
- [ ] README.md explains the skill clearly
- [ ] Privacy statement is present
- [ ] Language policy acknowledgment is included

### Step 4: Test the Skill
- [ ] Run the skill and verify all output is English
- [ ] Check that questions don't inadvertently collect personal info
- [ ] Verify error messages make sense
- [ ] Test edge cases for information leakage

### Step 5: Decision

**APPROVE if:**
- ✅ All language checks pass
- ✅ No personal information is requested
- ✅ Documentation is complete
- ✅ Code quality is acceptable
- ✅ Comments in the PR acknowledge policy compliance

**REQUEST CHANGES if:**
- ❌ Any non-English content found
- ❌ Personal information questions exist
- ❌ Missing privacy documentation
- ❌ Data collection is unclear
- ❌ Policy acknowledgment missing

**REJECT if:**
- 🚫 Multiple policy violations
- 🚫 Deceptive practices to collect data
- 🚫 This is the creator's repeated violation
- 🚫 Sensitive data handling present

---

## Automated Checks (CI/CD Pipeline)

The following should be implemented in GitHub Actions:

### Language Detection
```bash
# Check for common non-English patterns
grep -E "[^\x00-\x7F]" _skills/*/SKILL.md _skills/*/README.md
```

### Personal Information Keywords
```bash
# Flag suspicious keywords
grep -i -E "ssn|password|credit_card|bank_account|phone_number" _skills/*/*.py _skills/*/*.sh
```

### SKILL.md Validation
```bash
# Ensure all SKILL.md files have required fields
- Check for `name` field
- Check for `description` field
- Check for valid YAML frontmatter
```

### Documentation Check
```bash
# Ensure README.md and SKILL.md exist for each skill
for skill in _skills/*/; do
  [ ! -f "$skill/SKILL.md" ] && echo "Missing SKILL.md in $skill"
  [ ! -f "$skill/README.md" ] && echo "Missing README.md in $skill"
done
```

---

## Escalation Path

If a skill repeatedly violates the policy:

1. **First Review Rejection:** Reviewer adds comment with policy reference and specific issues
2. **Second Rejection:** CC team lead and document in PR comments
3. **Third Rejection:** Escalate to policy committee with timeline
4. **Action:** Author suspended from submitting for 30 days

---

## Examples for Reference

### Example 1: Compliant Horoscope Skill ✅

```python
# QUESTIONS (Compliant)
"What is your current mood?" → mood-based, not identifying
"What's your lucky color?" → preference-based, not identifying
"Pick a lucky number (1-9)" → entertainment, not identifying
```

**Status:** PASS - No personal information requested

---

### Example 2: Non-Compliant User Profile Skill ❌

```python
# QUESTIONS (Non-Compliant)
"What is your full name?" → PERSONAL
"What is your email?" → PERSONAL
"Where do you live?" → PERSONAL
```

**Status:** FAIL - Violates personal information policy

---

## Questions and Clarifications

If you're unsure whether something violates the policy:

**Ask yourself:**
- Could this information identify the user?
- Would the user be uncomfortable sharing this?
- Is this information necessary for the skill to function?
- Is there a privacy-preserving alternative?

If the answer is YES to questions 1-2, or NO to question 3, it likely violates the policy.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-27 | Initial policy release |

---

*Last Updated: April 27, 2026*
