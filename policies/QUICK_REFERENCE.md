# Policy Quick Reference Guide

**Last Updated:** April 27, 2026

---

## ⚡ TL;DR - Three Core Rules

### Language Rule
🌐 **All skills must use ENGLISH ONLY**
- All prompts, messages, and output in English
- No language switching, detection, or translation
- No multilingual support

### Privacy Rule  
🔒 **DO NOT ask for personal information**
- No real names, emails, phone numbers, addresses
- No credentials, financial info, or ID numbers
- No health, location, or identifying data
- OK: Colors, numbers, moods, personality types

### Application Launch Rule
🚫 **DO NOT launch any applications on the user's laptop**
- No automatic app launches
- No subprocess/system calls to execute applications
- No URL schemes or indirect launching
- ✅ OK: Show instructions users can manually follow

---

## ✅ What You CAN Ask For

```
Questions I can ask:
✅ "What's your mood?" → energetic/calm/happy/sad
✅ "Pick a lucky color" → red/blue/green/purple
✅ "What's your personality?" → optimist/realist/dreamer
✅ "Rate this from 1-10" → any numeric preference
✅ "What are you hoping for?" → success/love/peace
✅ "Pick a number (1-9)" → luck/game related
```

---

## ❌ What You CANNOT Ask For

```
Questions I CANNOT ask:
❌ "What is your name?"
❌ "What's your email address?"
❌ "What is your phone number?"
❌ "Where do you live?"
❌ "What is your password?"
❌ "What's your credit card?"
❌ "What is your birthday?"
❌ "What's your location?"
```

---

## Language Examples

### ✅ Good - English Only

```markdown
---
name: mood-tracker
description: Track your daily mood with colors
version: 1.0.0
---

Questions:
1. How are you feeling today?
2. Pick a lucky color.
3. Rate your energy level (1-10).
```

### ❌ Bad - Multiple Languages

```markdown
---
name: language-guesser
description: Guess your language
version: 1.0.0
---

Questions in: English, Spanish, French, Chinese
Multilingual support enabled
```

---

## Privacy Examples

### ✅ Good - No Personal Info

```python
print("What's your mood?")
mood = input("Choose: happy/sad/calm/energetic: ").lower()
# Uses only non-identifying preference
```

### ❌ Bad - Requests Personal Info

```python
print("What's your name?")
name = input("Enter your full name: ").lower()
# VIOLATES POLICY - requests identifying information
```

---

## Application Launch Examples

### ✅ Good - User Manual Control

```python
# Provide information, user decides what to do
print("Visit this link: https://example.com")
print("\nOr run this command in your terminal:")
print("  open https://example.com")
print("\nYou can copy and paste it manually.")
# ✅ User chooses when and how to open the link
```

### ❌ Bad - Automatic Launch

```python
import subprocess
subprocess.run(['open', '-a', 'Chrome'])  # ❌ PROHIBITED
# ❌ Automatically launches app without user permission

import os
os.system('xdg-open https://example.com')  # ❌ PROHIBITED
# ❌ Launches browser automatically
```

---

## Before You Submit Your Skill

### Checklist

1. **Language** - Did I use ONLY English?
   - [ ] All prompts in English
   - [ ] All messages in English
   - [ ] All documentation in English

2. **Privacy** - Did I avoid personal information?
   - [ ] No real names
   - [ ] No email/phone/address
   - [ ] No credentials
   - [ ] No identifying information

3. **Application Launches** - No apps are launched?
   - [ ] No subprocess calls
   - [ ] No os.system() calls
   - [ ] No application launches
   - [ ] No URL schemes that trigger apps
   - [ ] User provides manual instructions instead

4. **Documentation** - Is it complete?
   - [ ] SKILL.md has metadata
   - [ ] README.md explains the skill
   - [ ] Privacy statement included

**If you can't check all boxes → FIX BEFORE SUBMITTING**

---

## Common Questions

**Q: Can I ask for username/login?**
A: Only if it's the system-provided login, NOT a real name.

**Q: Can I ask for age?**
A: Only if you don't need the exact age (e.g., "age group" might be OK with policy committee approval).

**Q: Can I support multiple languages?**
A: No. English only, always.

**Q: What if my skill needs user data?**
A: Ask for non-identifying data only. Use preferences, not personal details.

**Q: Can I collect data across skill invocations?**
A: Generally no. Keep data isolated per session.

**Q: Can my skill launch a browser or open an application?**
A: No. Never automatically launch any application. Show users instructions they can manually follow.

**Q: Can my skill execute system commands?**
A: No. Don't use subprocess, os.system(), or similar. Provide commands users can copy/paste manually.

**Q: Can my skill open a file in the user's default application?**
A: No. Users must manually open files with their preferred application.

---

## If Your PR Gets Rejected

**Reason: "Non-English content found"**
→ Remove all non-English text from prompts/output

**Reason: "Personal information requested"**
→ Replace personal questions with non-identifying preferences

**Reason: "Missing privacy documentation"**
→ Add PRIVACY or DATA COLLECTION section to README.md

**Reason: "Unclear data collection"**
→ Explicitly state what data is collected and why

---

## Need Help?

**Questions about this policy?**
- Read the full policy: `LANGUAGE_AND_PRIVACY_POLICY.md`
- Check compliance checklist: `COMPLIANCE_CHECKLIST.md`
- Review examples in policy file

**Unsure if something violates the policy?**
- Ask: "Would this data identify the user?"
- Ask: "Is this English only?"
- If YES to first or NO to second → Likely violates policy

---

## Key Takeaway

```
Remember:
🌐 English ONLY
🔒 NO personal information
🚫 NO automatic app launches
📋 Document everything
```

---

## Related Policies

- `LANGUAGE_AND_PRIVACY_POLICY.md` - Language and data collection rules
- `APPLICATION_LAUNCH_POLICY.md` - App execution restrictions
- `COMPLIANCE_CHECKLIST.md` - Code review guidelines

---

*Part of the gaia-agent-skills Policy Framework*
