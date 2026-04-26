# gaia-agent-policy Specification

## Overview

`gaia-agent-policy` is a dedicated repository where IT/Security teams define and manage organizational policies that govern what skills can do on end-user machines. Policies are versioned, auditable, and enforced at runtime when skills are executed in AI assistants.

## Goals

1. **Centralized Policy Management:** Single source of truth for all organizational rules
2. **IT/Security Authority:** Enable IT/Security teams to enforce compliance requirements
3. **Transparent Enforcement:** Policies visible to end users before execution
4. **Version Control:** All policy changes tracked and auditable via Git
5. **Simple Format:** Easy for IT/Security to create and update policies
6. **Universal Application:** Rules apply across all AI assistants and skills

## Repository Purpose

The gaia-agent-policy repository serves as:
- **Policy database** — Stores all organizational policies in YAML format
- **Compliance source** — Auditable record of all rules and changes
- **Integration point** — Referenced by skills in gaia-agent-skills
- **Governance tool** — Enables IT/Security to manage organizational rules

## Policy Format

### Hybrid Format: Natural Language + Structured

Each policy combines:
- **Natural Language:** For AI assistants to understand intent and context
- **Structured Fields:** For programmatic validation and enforcement

### Example: Complete Policy File

```yaml
name: Email Policy
description: Rules for email sending from skills
version: 1.0.0
created: 2026-04-26
lastUpdated: 2026-04-26
maintainers:
  - security-team@company.com
  - it-compliance@company.com

rules:
  - id: no-company-wide-send
    name: "No company-wide emails"
    description: "Prevents mass emails to entire company"
    
    restriction: |
      Do not send emails with more than 100 recipients.
      
      Do not send to distribution lists that include the entire company
      such as company-all, all-employees, or similar.
      
      Rationale: Protects against accidental spam and information leaks.
      
      Exceptions: Require IT/Security approval. Contact security-team@company.com
    
    severity: high
    
    structured_validation:
      type: email
      field: recipients
      maxCount: 100
      blockedRecipients:
        - "company-all@example.com"
        - "all-employees@example.com"
        - "everyone@example.com"
  
  - id: no-sensitive-data-email
    name: "No sensitive data via email"
    description: "Prevents sending confidential information via email"
    
    restriction: |
      Do not include sensitive information in emails:
      
      - Social Security Numbers (SSN)
      - Credit card numbers
      - Bank account numbers
      - API keys, tokens, or passwords
      - Private encryption keys
      - Confidential financial data (salaries, contracts, pricing)
      - Personal health information (PHI)
      - Client/customer confidential information
      - Source code with credentials
      
      Rationale: Email is not encrypted end-to-end and can be intercepted.
      Sensitive data should only be transmitted through secure channels.
      
      Exceptions: Use company-approved secure file transfer. Contact IT.
    
    severity: critical
    
    structured_validation:
      type: content-filter
      blockedPatterns:
        - id: ssn
          pattern: "\b\d{3}-\d{2}-\d{4}\b"
          name: "Social Security Number pattern"
        
        - id: credit-card
          pattern: "\b\d{4}[\\s-]?\d{4}[\\s-]?\d{4}[\\s-]?\d{4}\b"
          name: "Credit card pattern"
        
        - id: api-key-keyword
          pattern: "(?i)(password|api[_-]?key|secret|token|credential)\\s*[:=]"
          name: "API key/password keywords"
      
      blockedKeywords:
        - "confidential"
        - "secret"
        - "proprietary"
        - "not-for-distribution"

  - id: size-limit
    name: "Email size limit"
    description: "Prevents sending large attachments via email"
    
    restriction: |
      Do not send emails with attachments larger than 25MB total.
      
      Rationale: Large attachments can cause email system issues and slow down communication.
      
      Alternative: Use company file sharing service (OneDrive, SharePoint).
    
    severity: medium
    
    structured_validation:
      type: attachment-size
      field: totalAttachmentSize
      maxSizeBytes: 26843545  # 25MB in bytes
```

### Policy File Structure

**Top-level metadata fields:**
- `name` (required): Display name for policy
- `description` (required): Brief one-line description
- `version` (required): Semantic version (e.g., 1.0.0)
- `created` (required): Creation date (YYYY-MM-DD)
- `lastUpdated` (required): Last modification date
- `maintainers` (required): List of email addresses responsible for policy
- `rules` (required): Array of individual rules

**Rule fields:**
- `id` (required): Unique identifier (kebab-case, e.g., `no-company-wide-send`)
- `name` (required): Human-readable rule name
- `description` (required): What this rule prevents
- `restriction` (required): Natural language explanation for AI assistants
- `severity` (optional): high, medium, low, critical
- `structured_validation` (optional): Machine-readable constraints

**Structured validation fields (type-specific):**

*Email type:*
- `field`: Field to validate (recipients, subject, body, attachment)
- `maxCount`: Maximum count allowed
- `blockedRecipients`: Specific blocked email addresses
- `blockedDomains`: Blocked domain patterns

*Content-filter type:*
- `blockedPatterns`: Array of regex patterns with id/name
- `blockedKeywords`: Keywords to detect and block

*Attachment-size type:*
- `field`: Field name
- `maxSizeBytes`: Maximum file size in bytes

*File-type type:*
- `blockedExtensions`: File extensions to block (exe, bat, dll, etc.)
- `blockedMimeTypes`: MIME types to block

*Access type:*
- `blockedDirectories`: Directory paths to block
- `allowedDirectories`: Whitelist of allowed directories (if restrictive)

## Repository Structure

### MVP Structure (Flat)

```
gaia-agent-policy/
├── README.md                 # Overview and getting started
├── CONTRIBUTING.md           # How to create/modify policies
├── LICENSE                   # MIT or company license
├── policies/
│   ├── email-policy.yaml
│   ├── file-policy.yaml
│   ├── access-policy.yaml
│   ├── data-policy.yaml
│   └── system-policy.yaml
├── examples/
│   ├── policy-template.yaml  # Template for new policies
│   └── sample-policies/
│       ├── email-example.yaml
│       └── file-example.yaml
└── docs/
    ├── policy-format.md      # Detailed policy format guide
    ├── validation-rules.md   # Structured validation reference
    └── governance.md         # Policy governance process
```

### Files

**README.md:**
- What gaia-agent-policy is
- How it integrates with gaia-agent-skills
- Quick start for IT/Security
- Link to contribution guide

**CONTRIBUTING.md:**
- Process for adding/modifying policies
- Template for new policies
- Review checklist
- How to test policies
- Naming conventions

**examples/policy-template.yaml:**
- Blank template IT/Security can copy
- All fields documented
- Example rule already filled in

**docs/policy-format.md:**
- Detailed explanation of each field
- Types of structured validation
- Best practices for writing restrictions
- Common patterns and examples

**docs/validation-rules.md:**
- Reference for all structured_validation types
- Regex pattern examples
- Field definitions
- Severity levels explained

**docs/governance.md:**
- Policy approval process
- Version numbering scheme
- Breaking vs non-breaking changes
- How policies are deployed
- Rollback procedures

## Policy Categories

### MVP Categories (Flat Structure)

**email-policy.yaml**
- Email recipient restrictions
- Sensitive data in emails
- Distribution list rules
- Email size limits

**file-policy.yaml**
- File download restrictions
- File type restrictions (blocked extensions)
- File size limits
- File publication restrictions

**access-policy.yaml**
- Directory access restrictions
- API endpoint access restrictions
- Resource access control
- Sensitive folder protection

**data-policy.yaml**
- Data classification rules
- Personally Identifiable Information (PII) handling
- Confidential data protection
- Data retention rules

**system-policy.yaml**
- System command restrictions
- Process execution restrictions
- Environment variable access
- System resource limits

### Future Organization (Post-MVP)

```
policies/
  email/
    recipients.yaml
    attachments.yaml
    sensitive-data.yaml
  files/
    types.yaml
    sizes.yaml
    locations.yaml
  access/
    directories.yaml
    endpoints.yaml
    resources.yaml
  data/
    classification.yaml
    pii-protection.yaml
    retention.yaml
  system/
    commands.yaml
    processes.yaml
```

Can be reorganized once policies grow beyond MVP scope.

## Versioning and Governance

### Semantic Versioning

Policies follow semantic versioning:
- **MAJOR:** Breaking change (e.g., new blocked action, stricter limit)
- **MINOR:** Non-breaking addition (e.g., new blocked keyword)
- **PATCH:** Documentation or clarification only

Example: `1.2.3` means major version 1, minor version 2, patch 3

### Change Process

1. **Create Pull Request**
   - Branch: `policy/description` (e.g., `policy/add-email-encryption-requirement`)
   - Update policy file(s)
   - Increment version number
   - Document change in commit message

2. **Review**
   - At least 2 IT/Security team members must review
   - Compliance team reviews for legal/regulatory impact
   - Check for conflicts with existing policies

3. **Test**
   - Verify structured validation syntax
   - Check regex patterns (if used)
   - Validate YAML formatting

4. **Merge**
   - Squash and merge to main
   - Create Git tag: `policy-{name}-{version}` (e.g., `policy-email-1.2.0`)

5. **Deploy**
   - Policies immediately available to all skills
   - No deployment step needed (fetched on demand from GitHub)

### Breaking Changes

Major version changes (breaking) should:
- Include migration guide for skills
- Provide at least 2 weeks notice
- Document in CHANGELOG.md
- Consider providing both old and new policy versions temporarily

### Non-Breaking Changes

Minor/patch changes:
- Can be merged immediately
- No notice period required
- Automatically enforced on next skill invocation

## Integration with Skills

### How Skills Reference Policies

Skills in gaia-agent-skills reference policies by URL in SKILL.md:

```markdown
---
name: send-notification
policies:
  - https://raw.githubusercontent.com/company/gaia-agent-policy/main/policies/email-policy.yaml
---
```

### Workflow for Skill Developer

1. Create new skill in gaia-agent-skills
2. Identify what policies apply
3. Add `policies:` section with URLs
4. Write skill instructions that respect policies
5. Document any policy implications
6. Submit PR (can reference policy URLs)

### Workflow for Policy Creator

1. Identify policies needed for new skill categories
2. Create/update policy in gaia-agent-policy
3. Test policy format and validation rules
4. Notify skill developers of new policies
5. Monitor adoption

## Enforcement

### How Policies Are Enforced

1. **AI Assistant Fetches:** When skill is invoked, AI fetches policy files from URLs
2. **Natural Language Understanding:** AI reads `restriction` field and understands intent
3. **Structured Validation:** AI evaluates `structured_validation` rules
4. **Decision:** AI allows or blocks skill execution
5. **Feedback:** If blocked, AI explains why to user

### Policy Priority

If a skill references multiple policies and one blocks execution:
- **Blocking rule applies:** Any policy can block execution
- **Most restrictive wins:** If multiple rules apply, most restrictive is enforced

### What Happens When Policy Blocks

AI assistant should:
1. Refuse execution clearly: "I cannot do this due to policy X"
2. Explain the reason: Show the `restriction` field
3. Suggest alternative: "Try using secure file transfer instead"
4. Provide contact: "Contact IT for exceptions: security-team@company.com"

## Documentation Requirements

### For Each Policy

Every policy should document:
- **What it prevents:** Clear description
- **Why it exists:** Business/compliance reason
- **What to do instead:** Acceptable alternatives
- **How to get exceptions:** Contact and process
- **When it was created:** Audit trail

Example:
```yaml
restriction: |
  Do not send emails with more than 100 recipients.
  
  WHY: Prevents accidental spam and information leaks to large groups.
  
  INSTEAD: Use secure email distribution or company communication tool.
  
  EXCEPTIONS: Request approval from security-team@company.com.
  Explain business need for mass email.
```

## Examples

### Example 1: Email Recipient Restriction

```yaml
name: Email Policy
rules:
  - id: no-company-wide-send
    name: "No company-wide emails"
    description: "Cannot send to entire company at once"
    
    restriction: |
      Do not send emails with more than 100 recipients.
      Do not send to company-all, all-employees, or similar lists.
    
    severity: high
    
    structured_validation:
      type: email
      field: recipients
      maxCount: 100
      blockedRecipients:
        - "company-all@example.com"
```

### Example 2: Sensitive Data Protection

```yaml
- id: no-ssn-in-files
  name: "No SSN in downloaded files"
  description: "Cannot download files containing SSNs"
  
  restriction: |
    Do not download files that contain Social Security Numbers.
    Use HR secure system instead.
  
  severity: critical
  
  structured_validation:
    type: content-filter
    blockedPatterns:
      - id: ssn-pattern
        pattern: "\b\d{3}-\d{2}-\d{4}\b"
        name: "SSN format"
```

### Example 3: File Type Restriction

```yaml
- id: no-executable-download
  name: "No executable file download"
  description: "Cannot download .exe or similar executable files"
  
  restriction: |
    Do not download executable files (.exe, .bat, .dll, .msi, .cmd).
    These can contain malware.
  
  severity: critical
  
  structured_validation:
    type: file-type
    blockedExtensions:
      - exe
      - bat
      - dll
      - msi
      - cmd
      - com
      - scr
      - vbs
```

## Best Practices

### For Policy Writers

1. **Be Specific:** "Do not send SSN" is better than "Do not send sensitive data"
2. **Provide Alternatives:** Always suggest what to do instead
3. **Explain Why:** Help users understand the business reason
4. **Test Patterns:** Verify regex patterns work as intended
5. **Document Exceptions:** Make clear how to request exceptions
6. **Version Carefully:** Increment versions appropriately

### For Structured Validation

1. **Be Conservative:** Err on side of blocking (false positive > false negative)
2. **Test Thoroughly:** Try patterns against real data
3. **Document Patterns:** Explain what each regex matches
4. **Use Severity:** Mark critical vs advisory rules
5. **Provide Feedback:** Clear error messages when blocked

### For Integration

1. **Communicate Changes:** Notify skills when new policies added
2. **Give Time:** Allow time for skill adaptation
3. **Monitor Blocks:** Track how often policies block execution
4. **Iterate:** Update policies based on real-world usage

## Future Enhancements

### Policy Validation Service

- MCP endpoint for validating policies
- Pre-execution policy checks
- Audit logging of policy evaluations
- Policy conflict detection

### Policy Templates

- Pre-built policies for common use cases
- Policy templates for different industries
- Policy inheritance (policies build on others)

### Role-Based Policies

- Different rules for different user groups
- Admin policies vs regular user policies
- Department-specific policies
- Temporary exceptions with auto-expiration

### Compliance Reporting

- Generate compliance reports
- Track policy enforcement
- Identify frequently blocked actions
- Audit trail of policy changes

## Migration Guide

### For Existing Deployments

If migrating from manual policy enforcement:

1. **Document Current Rules:** List all current restrictions
2. **Create Policy Files:** Convert to gaia-agent-policy format
3. **Test:** Verify policies work correctly
4. **Notify Users:** Announce policy system
5. **Gradual Rollout:** Enable policies in stages
6. **Monitor:** Track adoption and issues
7. **Refine:** Update based on feedback

## Support and Contact

**For Policy Questions:**
- Contact: security-team@company.com
- Documentation: See docs/ folder
- Exceptions: Open ticket with security team

**For Integration Issues:**
- Slack: #security-policies
- Email: security-policies@company.com
- GitHub Issues: gaia-agent-policy repo
