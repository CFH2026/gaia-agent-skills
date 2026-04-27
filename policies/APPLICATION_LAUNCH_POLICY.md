---
name: Application Launch Policy
description: Prohibits skills from launching or executing applications on the user's laptop
type: policy
version: 1.0.0
---

# Application Launch Policy for gaia-agent-skills

## Policy Version
1.0.0  
Last Updated: April 27, 2026

---

## 1. Executive Summary

Skills in the gaia-agent-skills repository are **PROHIBITED** from launching, executing, or invoking any applications on the user's laptop. This policy ensures user control, system stability, and security.

---

## 2. Core Policy Statement

### 2.1 Absolute Prohibition

**NO skill may launch or execute ANY application on the user's laptop.**

This includes:
- ❌ Desktop applications
- ❌ Command-line tools
- ❌ System utilities
- ❌ Web browsers
- ❌ Text editors
- ❌ Media players
- ❌ Any executable files

### 2.2 Scope

This policy applies to:
- All skills in the gaia-agent-skills repository
- All implementation methods (Markdown, Python, Shell, etc.)
- All OS platforms (macOS, Linux, Windows, etc.)
- Direct and indirect application launches

---

## 3. Prohibited Actions

### 3.1 Direct Application Launches

Skills MUST NOT:
- Call `open()` (macOS)
- Call `xdg-open()` (Linux)
- Call `start()` (Windows)
- Execute shell commands that launch applications
- Use subprocess/system calls to invoke executables
- Trigger system file associations

### 3.2 Examples of Prohibited Code

**Python (❌ NOT ALLOWED):**
```python
import subprocess
subprocess.run(['open', '/Applications/Chrome.app'])  # ❌ PROHIBITED

import os
os.system('open ~/Applications/TextEdit.app')  # ❌ PROHIBITED
```

**Shell Script (❌ NOT ALLOWED):**
```bash
open -a "Google Chrome"  # ❌ PROHIBITED (macOS)
xdg-open http://example.com  # ❌ PROHIBITED (Linux)
start notepad.exe  # ❌ PROHIBITED (Windows)
```

**Markdown Instructions (❌ NOT ALLOWED):**
```markdown
Then tell the user to click here: [Open Browser](open:chrome)  # ❌ PROHIBITED
Execute this command: `open -a Safari`  # ❌ PROHIBITED
```

### 3.3 Indirect Application Launches

Skills MUST NOT:
- Create files that automatically open applications (e.g., `.app` files)
- Modify system settings to launch applications
- Use URL schemes to trigger application launches
- Create shortcuts or aliases that execute applications
- Use AppleScript or other automation frameworks
- Modify desktop shortcuts or launch configurations

**Examples (❌ NOT ALLOWED):**
```python
# ❌ Creating a file that auto-opens in an application
open_file = open('document.rtf', 'w')  # Creates file that opens in TextEdit
open_file.write('content')
open_file.close()

# ❌ Using AppleScript to launch applications
os.system("osascript -e 'tell app \"Safari\" to activate'")
```

---

## 4. What Skills CAN Do

### 4.1 Allowed Actions

Skills MAY:
- ✅ Generate text content that users can copy/paste
- ✅ Provide instructions for users to manually take action
- ✅ Output URLs that users can click on manually
- ✅ Create files in designated directories
- ✅ Display information and guidance in text form
- ✅ Generate code snippets for users to run manually
- ✅ Provide shell commands for users to execute manually
- ✅ Output configuration data users can apply manually

### 4.2 Examples of Allowed Alternatives

**Instead of launching an application:**

```markdown
# ✅ CORRECT APPROACH
Instead of opening a web browser automatically:

Here's a link you can click: https://example.com

Or copy and paste this into your terminal:
open https://example.com
```

**Instead of executing a command:**

```markdown
# ✅ CORRECT APPROACH
Here's the command to run:

\`\`\`bash
npm install package-name
\`\`\`

Copy and paste this into your terminal when ready.
```

**Instead of opening a file:**

```markdown
# ✅ CORRECT APPROACH
I've generated a file: my-config.json

You can open it with your preferred editor:
\`\`\`bash
nano my-config.json
# or
vim my-config.json
# or
open my-config.json
\`\`\`
```

---

## 5. Rationale

### 5.1 Why This Policy Exists

1. **User Control:** Users should always have control over what applications run on their system
2. **Security:** Prevents malicious code from launching unwanted applications
3. **System Stability:** Prevents unintended system changes or resource consumption
4. **Transparency:** Users can see exactly what actions a skill performs
5. **Consent:** Users can deliberately choose to run commands, not have them executed automatically
6. **Accountability:** Clear audit trail when users manually execute actions

### 5.2 The "Manual Execution" Principle

Skills should be **informative and instructive**, not **executable and autonomous**. Users make the final decision about what runs on their system.

---

## 6. Enforcement

### 6.1 Code Review Checklist

Reviewers MUST verify:
- [ ] No `subprocess` or `os.system()` calls that execute applications
- [ ] No `open()`, `xdg-open()`, or `start()` commands
- [ ] No AppleScript or system automation frameworks
- [ ] No file creation with auto-execution triggers
- [ ] No URL schemes or launch handlers
- [ ] No indirect application launching mechanisms

**Search for suspicious terms:**
```bash
grep -r "subprocess\|os.system\|open -a\|xdg-open\|start " skills/skill-name/
grep -r "AppleScript\|osascript\|powershell" skills/skill-name/
```

### 6.2 Automated CI/CD Checks

The CI/CD pipeline should flag:
```bash
# Python files
grep -E "subprocess|os\.system|Popen|call|run\(" *.py

# Shell scripts
grep -E "^open |^xdg-open|^start " *.sh

# Markdown files
grep -E "\[.*\]\(open:|execute:" *.md
```

### 6.3 Testing Requirements

Before approval, reviewers should:
- [ ] Run the skill and verify NO applications launch
- [ ] Check that all output is text-based
- [ ] Confirm users can manually choose to execute commands
- [ ] Verify no background processes are spawned

---

## 7. Violations and Consequences

### 7.1 Violation Severity Levels

**🔴 Critical Violation:**
- Launches applications automatically
- Executes shell commands without user consent
- Triggers system-level changes
- **Consequence:** Immediate PR rejection, skill removal from repository

**🟠 High Violation:**
- Creates files designed to auto-launch applications
- Uses automation frameworks to execute code
- Indirect application launching
- **Consequence:** PR rejected, author required to fix before resubmission

**🟡 Medium Violation:**
- Mentions launching applications in instructions
- Provides unsafe command examples
- **Consequence:** Requested changes, author must revise documentation

### 7.2 Escalation Path

1. **First Violation:** PR rejected with explanation and policy reference
2. **Second Violation:** PR rejected, author must attend policy review
3. **Third Violation:** Author temporarily banned (30 days)
4. **Repeated Pattern:** Author permanently banned from repository

---

## 8. Exceptions and Special Cases

### 8.1 When Exceptions Might Be Considered

Exceptions are **extremely rare** and require:
- Clear business justification
- Explicit user consent mechanism (opt-in, not opt-out)
- Security audit approval
- Legal review
- Time-limited scope

### 8.2 Exception Process

1. Document detailed justification
2. Propose explicit user consent mechanism
3. Submit to security and policy committees
4. 14-day review period
5. Written approval required from all committees
6. Decision publicly documented

---

## 9. Examples

### ✅ Compliant Skill: Code Generator

```python
# SKILL.md
name: code-generator
description: Generate boilerplate code

# Implementation
def generate_code(template):
    code = f"""
    def hello_world():
        print('Hello, World!')
    """
    print("Here's your generated code:")
    print(code)
    print("\nCopy and paste this into your editor.")
    # ✅ Generates output, user must copy/paste manually
```

### ❌ Non-Compliant Skill: Auto-Launcher

```python
# ❌ PROHIBITED
import subprocess

def launch_browser():
    subprocess.run(['open', '-a', 'Chrome', 'https://example.com'])
    # ❌ Automatically launches browser without user permission

# ❌ PROHIBITED
def open_editor():
    os.system('nano config.txt')
    # ❌ Automatically opens text editor
```

---

## 10. FAQ

**Q: Can a skill open a file in the user's default application?**
A: No. Users should manually open files using their preferred application.

**Q: Can a skill suggest commands that launch applications?**
A: Yes, but the user must manually copy and execute the command themselves.

**Q: What if the skill needs to display a URL?**
A: Output the URL as text. Users can copy/paste it into their browser manually.

**Q: Can a skill create a script file that users can run?**
A: Yes, but the user must manually execute the script. Never auto-execute.

**Q: Is printing instructions to launch applications allowed?**
A: Yes, as long as the user must manually type or copy/paste the command.

**Q: Can a skill use environment variables to launch applications?**
A: No. Avoid any mechanism that could trigger automatic application execution.

---

## 11. Compliance Statement

**"I understand and agree that my skill will not launch or execute ANY applications on the user's laptop. All actions will be informative and require explicit user action to execute."**

All skill creators must acknowledge this before submitting.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-27 | Initial policy release |

---

## Related Policies

- Language and Privacy Policy
- Compliance Checklist
- Quick Reference Guide

---

*This policy is binding for all skills in the gaia-agent-skills repository.*
