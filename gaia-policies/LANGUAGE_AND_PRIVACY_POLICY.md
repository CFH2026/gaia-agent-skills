# Language and Privacy Policy for gaia-agent-skills

## Policy Version
1.0.0  
Last Updated: April 27, 2026

---

## 1. Language Requirements

### 1.1 Primary Language
All skills must use **English** as the primary and only user-facing language.

**Requirements:**
- All prompts, questions, and interactive text must be in English
- All output messages, warnings, and feedback must be in English
- All documentation and help text must be in English
- All code comments should be in English

### 1.2 Language Standards
- Use clear, simple English that is easy to understand
- Avoid overly technical jargon unless necessary and explained
- Use proper grammar and spelling
- Use consistent terminology across all skills

### 1.3 Internationalization Restrictions
- Skills must NOT detect or switch to other languages based on user location
- Skills must NOT provide translations or multilingual outputs
- Skills must NOT ask users for language preference
- Skills must NOT display content in non-English languages

### 1.4 Enforcement
- CI/CD pipeline will validate all user-facing text for English-only content
- Code reviews will flag any non-English prompts or messages
- Linting tools will verify comment quality

---

## 2. Personal Information Policy

### 2.1 What Constitutes Personal Information

Personal information includes but is not limited to:
- **Identity Information:** Real names, usernames (beyond generic login names), aliases
- **Contact Information:** Email addresses, phone numbers, physical addresses, postal codes
- **Financial Information:** Credit card numbers, bank accounts, salary, financial status
- **Health Information:** Medical conditions, health records, mental/physical health details
- **Biometric Data:** Fingerprints, facial recognition data, DNA information
- **Identification Numbers:** Social Security Numbers, passport numbers, driver's license numbers
- **Location Data:** GPS coordinates, home/work locations, travel history
- **Device Information:** Device IDs, MAC addresses, serial numbers
- **Authentication Credentials:** Passwords, authentication tokens, API keys, secrets
- **Behavioral Data:** Browsing history, search history, preferences that identify individuals
- **Family/Relationship Information:** Family member names, relationship status, household composition
- **Educational/Professional:** Job titles, company names, work history, school names, degrees
- **Sensitive Personal Preferences:** Political views, religious beliefs, sexual orientation

### 2.2 Prohibited Actions

Skills MUST NOT:
- Ask users for their real name or surname
- Request email addresses or phone numbers
- Request or collect any authentication credentials
- Ask for birthdates or age (unless explicitly non-identifying aggregate data)
- Request home or work addresses
- Ask for financial information
- Request government-issued ID numbers
- Collect information that could identify an individual
- Store or transmit personal information without explicit user consent
- Use collected information for purposes beyond the stated skill function
- Share personal information with third parties

### 2.3 Acceptable Information Collection

Skills MAY collect:
- **Generic username/login identifier** (system-provided, not personal name)
- **Non-identifying preferences:** favorite colors, numbers, moods, personality types
- **Anonymous feedback:** general satisfaction, feature requests (without identification)
- **Aggregate usage statistics:** total interactions, feature popularity (not per-user)
- **Consent status:** whether user has agreed to terms (no personal data)
- **General geographic region** (country/state level, not precise location) if necessary for service
- **Device type** (macOS, Linux, etc.) without device-specific identifiers
- **System information** about the machine (OS version, CPU type, RAM) that doesn't identify the user

### 2.4 Question Design Guidelines

When designing interactive questions:
- ✅ **Good:** "What is your current mood?"
- ❌ **Bad:** "What is your name?"

- ✅ **Good:** "Pick a lucky number (1-9)"
- ❌ **Bad:** "What is your phone number?"

- ✅ **Good:** "What type of personality are you?"
- ❌ **Bad:** "What is your email address?"

- ✅ **Good:** "What are you hoping for?"
- ❌ **Bad:** "Where do you live?"

### 2.5 Data Retention

- Collected non-personal data should be retained only as long as necessary
- Skills should NOT persist personal information across sessions by default
- Users should be able to clear any collected data
- No automatic profiling or tracking across multiple skill invocations

### 2.6 Transparency

Skills MUST:
- Clearly state what information they need and why
- Explain how the information will be used
- Provide privacy notices if any data collection occurs
- Allow users to decline participation without penalty
- Not use deceptive practices to collect information

---

## 3. Implementation Guidelines

### 3.1 Code Review Checklist

Before submitting a skill, verify:
- [ ] All prompts and messages are in English
- [ ] No questions ask for personal information
- [ ] No authentication or credentials are requested
- [ ] No real names or identifiable information are collected
- [ ] Documentation is complete and in English
- [ ] Privacy implications are minimal

### 3.2 Testing Requirements

Skills should be tested to ensure:
- All output is in English
- Questions do not inadvertently request personal data
- No sensitive information is logged or stored
- Error messages are helpful without exposing system details

### 3.3 Documentation Requirements

Each skill's README and SKILL.md must include:
- A section describing what information (if any) is collected
- Explanation of how collected data is used
- Assurance that no personal information is requested
- Language confirmation that English is the only supported language

---

## 4. Violation Consequences

Violations of this policy will result in:

1. **First Violation:** Pull request rejected with explanation. Skill creator required to fix issues.
2. **Second Violation:** Pull request rejected. Skill removed from review queue. Creator required to attend review session.
3. **Third Violation:** Creator temporarily banned from submitting new skills (30 days).
4. **Repeated Pattern:** Creator permanently banned from skill repository.

---

## 5. Exceptions and Approvals

### 5.1 When Exceptions Might Be Granted

In rare cases, exceptions may be approved by the policy committee if:
- There is clear business justification
- Privacy and language requirements are met with alternative approaches
- The exception is time-limited and reviewed regularly
- All stakeholders are informed and consent

### 5.2 Exception Process

1. Document the need for exception
2. Submit to policy committee with justification
3. Committee reviews and decides (within 5 business days)
4. If approved, decision is documented and communicated

---

## 6. Policy Review and Updates

This policy will be reviewed:
- Quarterly for compliance and effectiveness
- Upon legal/regulatory changes
- When new privacy concerns emerge
- Annually at minimum

Updates will be communicated to all skill creators 30 days in advance.

---

## 7. Contact and Support

For questions about this policy:
- **Policy Committee:** [policy@team.com]
- **Privacy Concerns:** [privacy@team.com]
- **Language Questions:** Use English resources in documentation

---

## 8. Examples

### ✅ Compliant Skill Example

**SKILL.md:**
```markdown
---
name: mood-tracker
description: Track your mood with fun colors and emojis
version: 1.0.0
---

This skill asks about your mood (no personal information required).

**Data Collection:** Only your mood preference in this session. No data is stored.
```

**Questions:**
```
What's your mood? (happy/sad/energetic/calm/stressed)
Pick a color (red/blue/green)
Rate your energy (1-10)
```

**Output:** Non-identifying results about mood and recommendations.

### ❌ Non-Compliant Skill Example

**SKILL.md (WRONG):**
```markdown
---
name: profile-builder
description: Build your user profile
version: 1.0.0
---

This skill creates a detailed profile about you.
```

**Questions (WRONG):**
```
What is your full name?
What is your email address?
Where do you live?
What is your phone number?
```

---

## Acknowledgment

All skill creators must acknowledge understanding and agreement with this policy before submitting skills to the repository.

**I have read and agree to comply with the Language and Privacy Policy.**

---

*This policy is binding for all skills in the gaia-agent-skills repository.*
