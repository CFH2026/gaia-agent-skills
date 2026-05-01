# Proposal: Embedded Policies in INSTRUCTION.md

**Date:** 2026-05-01  
**Proposal:** Move policies from separate files to embedded in INSTRUCTION.md  
**Status:** PoC Testing (see `personality-analyzer`)  
**Goal:** Prevent users from bypassing policies by editing SKILL.md URLs

---

## Executive Summary

Instead of storing policies as separate files with URLs in SKILL.md, embed all policy content directly in INSTRUCTION.md. This prevents users from removing or modifying policy URLs to skip enforcement.

**Result:** Users cannot edit locally to bypass policies. Policies are part of the fetched INSTRUCTION.md and enforced at runtime.

---

## Problem Statement

### Current V1 Architecture (Separate Files)

```
SKILL.md
├── instruction_url: https://github.../INSTRUCTION.md
└── policies[]:
    ├── url: https://github.../QUICK_REFERENCE.md
    ├── url: https://github.../LANGUAGE_AND_PRIVACY_POLICY.md
    └── url: https://github.../APPLICATION_LAUNCH_POLICY.md
```

**Vulnerability:** User could theoretically edit local SKILL.md to remove policy URLs:
```yaml
# User modifies SKILL.md to skip policies
policies: []  # ← Empty, policies not loaded
```

### Proposed V2 Architecture (Embedded)

```
SKILL.md (minimal, read-only metadata)
├── instruction_url: https://github.../INSTRUCTION.md
└── policies_embedded: true  # ← Flag indicating policies are in INSTRUCTION.md

INSTRUCTION.md (contains everything)
├── Role definition
├── Execution steps
├── Embedded Policy 1: QUICK_REFERENCE
├── Embedded Policy 2: LANGUAGE_AND_PRIVACY_POLICY
├── Embedded Policy 3: APPLICATION_LAUNCH_POLICY
├── Constraints & boundaries
├── Error handling
└── Audit & logging
```

**Advantage:** No separate policy files or URLs to remove. Policies are part of the fetched document.

---

## Implementation Comparison

### V1: Separate Policy Files

```
File Structure:
├── gaia-skills/personality-analyzer/SKILL.md (references URLs)
├── gaia-instructions/personality-analyzer/INSTRUCTION.md
├── gaia-policies/QUICK_REFERENCE.md
├── gaia-policies/LANGUAGE_AND_PRIVACY_POLICY.md
├── gaia-policies/APPLICATION_LAUNCH_POLICY.md
└── gaia-policies/COMPLIANCE_CHECKLIST.md

Execution Flow:
1. Load SKILL.md
2. Extract policy URLs from SKILL.md
3. Fetch INSTRUCTION.md from GitHub
4. Fetch each policy from GitHub (3 separate files)
5. Load all into memory
6. Validate policies are loaded
7. Execute with policy constraints
8. Discard all from memory
```

**Pros:**
- ✅ Policy files are reusable (shared across multiple skills)
- ✅ Policies can be updated once (affects all skills)
- ✅ INSTRUCTION.md is smaller
- ✅ Policies are discoverable separately

**Cons:**
- ❌ Multiple network requests (fetch INSTRUCTION + 3 policies)
- ❌ Policy URLs can be removed/modified in SKILL.md
- ❌ Users might not understand policy dependencies
- ❌ Complex dependency chain

---

### V2: Embedded Policies

```
File Structure:
├── gaia-skills/personality-analyzer/SKILL.md (minimal metadata)
├── gaia-instructions/personality-analyzer/INSTRUCTION.md (contains all policies)
└── gaia-policies/* (separate, for reference/documentation only)

Execution Flow:
1. Load SKILL.md (minimal)
2. See: policies_embedded: true
3. Fetch INSTRUCTION.md from GitHub
4. Fetch 1 file only (all policies embedded)
5. Load all into memory
6. Policies are intrinsic to INSTRUCTION.md
7. Execute with embedded policy constraints
8. Discard all from memory
```

**Pros:**
- ✅ Single file fetch (INSTRUCTION.md only)
- ✅ Policies cannot be bypassed via URL removal
- ✅ Policies are always in sync with instructions
- ✅ Simpler mental model (one file = complete skill)
- ✅ No way to skip policies locally

**Cons:**
- ❌ Policy duplication (same policies in multiple skills)
- ❌ INSTRUCTION.md becomes larger (~11KB vs ~5KB)
- ❌ Policy updates require updating all INSTRUCTION.md files
- ❌ Harder to share/reuse policy content
- ❌ Policies are less discoverable

---

## Testing: personality-analyzer

A PoC has been created to test this proposal:

### Files Created

```
gaia-skills/personality-analyzer/
├── SKILL.md (2.0K)
│   - Minimal metadata
│   - instruction_url only
│   - policies_embedded: true flag
│   - Read-only note
│
└── README.md (7.2K)
    - Explains V2 design
    - Shows V1 vs V2 comparison
    - Testing instructions

gaia-instructions/personality-analyzer/
└── INSTRUCTION.md (11K)
    - Complete embedded policies:
      * QUICK_REFERENCE (3 core rules)
      * LANGUAGE_AND_PRIVACY_POLICY (detailed rules)
      * APPLICATION_LAUNCH_POLICY (no auto-launch)
    - Role definition
    - Execution steps
    - Constraints & boundaries
    - Error handling
    - Audit & logging
```

### Key Differences in V2

1. **SKILL.md is smaller** (2.0K vs original structure)
   - No policy URL references
   - Just points to INSTRUCTION.md
   - Marked as "read-only"

2. **INSTRUCTION.md is larger** (11K vs ~5K)
   - Contains all three policies embedded
   - Policies are clearly marked with section headers
   - Cannot be bypassed

3. **Single source of truth**
   - Everything for the skill is in INSTRUCTION.md
   - No separate policy files to fetch

4. **Network efficiency**
   - 1 file fetch (INSTRUCTION.md) instead of 4 files
   - Faster startup, less network traffic

---

## Security Analysis

### V1 Vulnerability Scenario

```bash
# User runs skill
npx agent-skills-cli run personality-analyzer

# User could:
# 1. Find local SKILL.md
# 2. Edit it to remove policy URLs
# 3. Or edit it to point to a fake policy file
# 4. Policies are not enforced

# Result: User bypasses policies
```

### V2 Security Model

```bash
# User runs skill
npx agent-skills-cli run personality-analyzer

# Even if user finds SKILL.md locally and edits it:
# 1. SKILL.md just points to INSTRUCTION.md URL
# 2. INSTRUCTION.md is always fetched from GitHub
# 3. Policies are embedded in the fetched file
# 4. Cannot be edited or removed
# 5. Loaded into memory, never persisted

# Result: Policies are enforced, cannot be bypassed locally
```

### Remaining Risk (Both V1 and V2)

**CRITICAL:** If users can edit the npx command to point to a different GitHub URL or local file, policies can still be bypassed.

**Mitigation needed:**
- [ ] Hardcode GitHub URLs in the npx CLI
- [ ] Sign/hash INSTRUCTION.md (detect tampering)
- [ ] Validate URLs use official CFH2026 GitHub domain
- [ ] Or require authentication/API token to fetch

---

## Recommendations

### Phase 1: Adopt V2 Architecture (Current PoC)

**Decision:** Use embedded policies for new skills going forward.

**Actions:**
1. ✅ Test `personality-analyzer` for functionality
2. Create new skills with embedded policies only
3. Keep old V1 skills as-is (no migration yet)
4. Document V2 as the new standard

**Benefits:**
- Single file per skill (simpler)
- Policies cannot be URL-edited
- Better network efficiency

**Trade-offs:**
- Accept policy duplication
- Larger INSTRUCTION.md files
- More effort to update policies

---

### Phase 2: Secure the Distribution Channel

Even with embedded policies, we need to prevent URL tampering.

**Options:**

**Option A: Hardcode URLs in npx CLI**
```bash
# Current (risky)
npx agent-skills-cli run personality-analyzer
# Uses SKILL.md for instruction_url → easy to spoof

# Proposed (secure)
npx agent-skills-cli run personality-analyzer
# CLI hardcodes: https://raw.githubusercontent.com/CFH2026/...
# Cannot be overridden locally
```

**Option B: Sign INSTRUCTION.md**
```yaml
# SKILL.md includes signature
instruction_url: https://raw.githubusercontent.com/.../INSTRUCTION.md
instruction_signature: sha256:abc123...

# At runtime:
# 1. Fetch INSTRUCTION.md
# 2. Compute sha256
# 3. Compare against SKILL.md signature
# 4. Reject if mismatch
```

**Option C: Require Authentication**
```bash
# Fetch requires GitHub token
# Prevents access to non-official copies
# Adds friction (requires login)
```

**Recommendation:** Combine Option A (hardcode URLs in CLI) + Option B (signature verification).

---

### Phase 3: Policy Management Strategy

With embedded policies, we need a strategy for policy updates.

**Current Challenge:**
```
Update to LANGUAGE_AND_PRIVACY_POLICY
  ↓
Must update all 20+ INSTRUCTION.md files
  ↓
PR review complexity increases
  ↓
More error-prone
```

**Solution Options:**

**Option 1: Create a "policy library" template**
```markdown
# personality-analyzer/INSTRUCTION.md

[Include embedded policies via templating]

# Policies
<!-- INCLUDE: ../../gaia-policies/QUICK_REFERENCE.md -->
<!-- INCLUDE: ../../gaia-policies/LANGUAGE_AND_PRIVACY_POLICY.md -->
```

Build step automatically expands `<!-- INCLUDE -->` directives before publishing to GitHub.

**Option 2: Accept duplication, document it**
```
✅ Policies are embedded for security
⚠️ Policy updates require updating multiple INSTRUCTION.md files
📋 Checklist: Update these N files when policies change:
   - personality-analyzer/INSTRUCTION.md
   - modelhub-query/INSTRUCTION.md
   - etc.
```

**Option 3: Future: Separate "Policy Versions"**
```
Not now, but later:
- Assign version number to policy set (e.g., policies-v1.0)
- INSTRUCTION.md references: policies_version: v1.0
- System fetches matching policy definitions at runtime
- Hybrid: embedded + versioned
```

**Recommendation:** Start with Option 2 (duplication + checklist), move to Option 1 (templating) if policy updates become frequent.

---

## Decision Matrix

| Factor | V1 (Separate) | V2 (Embedded) | Winner |
|--------|---------------|---------------|--------|
| **Security** | Medium (URLs can be removed) | High (embedded, cannot remove) | **V2** |
| **Simplicity** | Medium (multi-file) | High (single file) | **V2** |
| **Network Efficiency** | Low (4+ requests) | High (1 request) | **V2** |
| **Policy Reusability** | High (shared files) | Low (duplication) | **V1** |
| **Update Burden** | Low (update 1 policy file) | High (update N files) | **V1** |
| **Discoverability** | High (explicit policies) | Low (embedded, hidden) | **V1** |
| **User Understanding** | Medium | High (everything in one file) | **V2** |

**Overall Winner:** V2 (more security, simpler, better network efficiency)

**Trade-off:** Accept policy duplication and higher update burden

---

## Conclusion

### ✅ V2 (Embedded Policies) is RECOMMENDED for:

- **New skills** going forward
- **Preventing policy bypass** via URL editing
- **Simpler distribution** (single file per skill)
- **Network efficiency** (fewer HTTP requests)

### ⚠️ Phase 2 is REQUIRED for complete security:

- Hardcode GitHub URLs in npx CLI
- Add signature verification
- Prevent URL tampering at the CLI level

### 📋 Policy Management must be addressed:

- Document duplication trade-off
- Create update checklist when policies change
- Consider templating solution for future phases

---

## Testing Instructions

### Test personality-analyzer

```bash
# 1. Run the skill
npx agent-skills-cli run personality-analyzer

# 2. Try requesting personal info (name, email, etc.)
# → Should be blocked by embedded policy

# 3. Try asking political/religious questions
# → Should be blocked by embedded policy

# 4. Complete the assessment
# → Should succeed and show personality type

# 5. Verify no files persisted to disk
# → No INSTRUCTION.md cache found locally
```

### Compare V1 vs V2

```bash
# V1: Multiple files
du -sh gaia-instructions/personality-analyzer/INSTRUCTION.md
du -sh gaia-policies/QUICK_REFERENCE.md
du -sh gaia-policies/LANGUAGE_AND_PRIVACY_POLICY.md
du -sh gaia-policies/APPLICATION_LAUNCH_POLICY.md

# V2: Single file
du -sh gaia-instructions/personality-analyzer/INSTRUCTION.md

# V2 INSTRUCTION.md contains all policies
wc -l gaia-instructions/personality-analyzer/INSTRUCTION.md
# ~400+ lines (includes all embedded policies)
```

---

## Next Steps

1. ✅ **PoC Complete** — personality-analyzer created
2. **Test** — Verify functionality with embedded policies
3. **Security Review** — Confirm policies cannot be bypassed
4. **Decision** — Adopt V2 for new skills or require Phase 2 first?
5. **Rollout** — Update CLAUDE.md with new standard
6. **Phase 2** — Implement URL hardcoding + signature verification
7. **Phase 3** — Create policy templating solution

---

**Prepared by:** Claude Code  
**Status:** Ready for Review & Testing
