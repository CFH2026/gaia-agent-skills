# Phase 2 Security Implementation Details

**Goal:** Prevent users from bypassing policies by pointing to malicious INSTRUCTION.md files

**Problem:** Even with embedded policies, a user could edit SKILL.md to point to a fake INSTRUCTION.md:

```yaml
# Attacker edits SKILL.md locally
instruction_url: https://attacker.com/malicious-INSTRUCTION.md
```

**Solution:** Two complementary approaches to solve this.

---

## Approach 1: Hardcode GitHub URLs in npx CLI

### The Idea

Instead of reading `instruction_url` from SKILL.md, hardcode it in the npx CLI itself. Users cannot override hardcoded values.

### Current Flow (Vulnerable)

```
User runs: npx @gaia/skills personality-analyzer
  ↓
CLI reads: gaia-skills/personality-analyzer/SKILL.md (local or cached)
  ↓
CLI extracts: instruction_url from SKILL.md front matter
  ↓
CLI fetches: https://raw.githubusercontent.com/.../INSTRUCTION.md
  ↓
Problem: If SKILL.md is edited locally, instruction_url can be overridden!
```

### Proposed Flow (Secure)

```
User runs: npx @gaia/skills personality-analyzer
  ↓
CLI has hardcoded mapping:
  personality-analyzer → 
    https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/personality-analyzer/INSTRUCTION.md
  ↓
CLI fetches: Uses HARDCODED URL (cannot be overridden)
  ↓
User's local SKILL.md is ignored for URL
  ↓
✅ Impossible to point to malicious INSTRUCTION.md
```

### Implementation Example

**Current CLI code (vulnerable):**

```javascript
// agent-skills-cli/src/run-skill.js (VULNERABLE)

async function runSkill(skillName) {
  // Read local SKILL.md
  const skillPath = `./gaia-skills/${skillName}/SKILL.md`;
  const skillContent = fs.readFileSync(skillPath, 'utf-8');
  
  // Parse front matter
  const frontMatter = parseFrontMatter(skillContent);
  
  // ⚠️ DANGEROUS: Using instruction_url from user's local file
  const instructionUrl = frontMatter.metadata.instruction_url;
  
  // Fetch from wherever user specified
  const instruction = await fetch(instructionUrl);
  
  // Execute...
}
```

**Hardcoded version (secure):**

```javascript
// agent-skills-cli/src/run-skill.js (SECURE)

// 1. Define hardcoded URL mapping
const SKILL_URLS = {
  'personality-analyzer': {
    instruction: 'https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/personality-analyzer/INSTRUCTION.md',
    version: '2.0.0',
    owner: 'gaia-team',
  },
  'modelhub-query-v2': {
    instruction: 'https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/modelhub-query-v2/INSTRUCTION.md',
    version: '2.0.0',
    owner: 'gaia-team',
  },
  // ... more skills
};

async function runSkill(skillName) {
  // 2. Check if skill is registered in hardcoded mapping
  const skillConfig = SKILL_URLS[skillName];
  if (!skillConfig) {
    throw new Error(`Skill "${skillName}" is not registered or not available in v2 format`);
  }
  
  // 3. Use ONLY the hardcoded URL
  const instructionUrl = skillConfig.instruction;
  
  // 4. Fetch from official GitHub only
  const instruction = await fetch(instructionUrl);
  
  // 5. Verify it came from GitHub (not a redirect/proxy)
  if (!instruction.url.includes('raw.githubusercontent.com')) {
    throw new Error('Instruction fetch was redirected! Rejecting for security.');
  }
  
  // Execute...
}
```

### Benefits ✅

- ✅ Users CANNOT override instruction_url
- ✅ All skills always fetch from official GitHub
- ✅ No way to redirect to malicious servers
- ✅ CLI updates control which URLs are allowed

### Drawbacks ⚠️

- ❌ CLI must be updated when adding new skills
- ❌ No dynamic skill discovery (predefined list)
- ❌ Requires CLI release/version management
- ❌ Less flexible (skills must be pre-approved)

### Configuration Locations

**Option A: Hardcoded in CLI source**
```javascript
// agent-skills-cli/src/skills-registry.js
export const OFFICIAL_SKILLS = {
  'personality-analyzer': '...',
  'modelhub-query-v2': '...',
};
```
- Simple
- Single source of truth
- Must update CLI to add skills

**Option B: Signed configuration file in repo**
```yaml
# gaia-agent-skills/cli-config.yaml (signed with GPG)
skills:
  personality-analyzer:
    instruction: https://raw.githubusercontent.com/.../INSTRUCTION.md
    sha256: abc123...
    owner: gaia-team
    approved_date: 2026-05-01
```
- More flexible
- Can update without CLI release
- Still cryptographically signed

---

## Approach 2: Signature Verification

### The Idea

Sign INSTRUCTION.md with a private key. At runtime, verify the signature matches the public key. Any tampering breaks the signature.

### How Signatures Work

```
1. At publish time:
   SHA256(INSTRUCTION.md) → hash
   Sign(hash, private_key) → signature
   
2. Store:
   - INSTRUCTION.md (content)
   - signature.txt (cryptographic signature)
   - public_key.pem (for verification)
   
3. At runtime:
   SHA256(INSTRUCTION.md) → hash'
   Verify(signature, hash', public_key) → ✅ or ❌
   
   If hash' != original hash → ❌ Signature fails (tampered!)
```

### Implementation Example

**At Publish Time (GitHub Actions):**

```bash
#!/bin/bash
# .github/workflows/sign-skills.yml

# Install signing tools
sudo apt-get install openssl

# For each skill's INSTRUCTION.md:
for skill in gaia-instructions/*/INSTRUCTION.md; do
  # Generate SHA256 hash
  sha256sum "$skill" > "$skill.sha256"
  
  # Sign the hash with private key
  openssl dgst -sha256 -sign private_key.pem "$skill.sha256" > "$skill.sig"
  
  echo "Signed: $skill"
done

# Commit signature files
git add gaia-instructions/*/*.sig gaia-instructions/*/*.sha256
git commit -m "docs: sign INSTRUCTION.md files"
```

**At Runtime (CLI):**

```javascript
// agent-skills-cli/src/verify-signature.js

import crypto from 'crypto';
import fs from 'fs';

// Public key (stored in repo, safe to share)
const PUBLIC_KEY = fs.readFileSync('./public_key.pem', 'utf-8');

async function verifyInstruction(skillName, instructionContent) {
  try {
    // 1. Fetch signature file from GitHub
    const sigUrl = `https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/${skillName}/INSTRUCTION.md.sig`;
    const sigResponse = await fetch(sigUrl);
    const signature = await sigResponse.buffer();
    
    // 2. Fetch hash file from GitHub
    const hashUrl = `https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/${skillName}/INSTRUCTION.md.sha256`;
    const hashResponse = await fetch(hashUrl);
    const expectedHash = await hashResponse.text();
    
    // 3. Calculate hash of received INSTRUCTION.md
    const actualHash = crypto
      .createHash('sha256')
      .update(instructionContent)
      .digest('hex');
    
    // 4. Compare hashes
    if (!actualHash.startsWith(expectedHash)) {
      throw new Error('Hash mismatch! INSTRUCTION.md was modified.');
    }
    
    // 5. Verify signature
    const verifier = crypto.createVerify('RSA-SHA256');
    verifier.update(instructionContent);
    const isValid = verifier.verify(PUBLIC_KEY, signature);
    
    if (!isValid) {
      throw new Error('Signature verification failed! INSTRUCTION.md is tampered.');
    }
    
    return { valid: true, hash: actualHash };
  } catch (error) {
    throw new Error(`Signature verification failed: ${error.message}`);
  }
}

// Usage in runSkill():
async function runSkill(skillName) {
  const instruction = await fetch(instructionUrl);
  const instructionContent = await instruction.text();
  
  // Verify before executing
  const verification = await verifyInstruction(skillName, instructionContent);
  
  if (!verification.valid) {
    throw new Error(`Skill "${skillName}" failed integrity check!`);
  }
  
  console.log(`✅ Signature verified for ${skillName}`);
  // Safe to execute...
}
```

### Benefits ✅

- ✅ Detects ANY tampering (accidental or malicious)
- ✅ Works with dynamic skill discovery
- ✅ No need to update CLI for new skills
- ✅ Cryptographically secure
- ✅ Industry standard approach

### Drawbacks ⚠️

- ❌ More complex to implement
- ❌ Key management required (private key security)
- ❌ Extra network requests (fetch signature + hash files)
- ❌ Signature verification adds latency
- ❌ Need to update signatures when INSTRUCTION.md changes

### Key Management

**Private Key Security (CRITICAL):**

```yaml
# Where to store private key:

✅ GOOD:
- GitHub Secrets (encrypted)
- CI/CD system secrets
- Hardware security module (HSM)
- KMS (AWS, Google, Azure)

❌ BAD:
- In git repository (even if "secret")
- Environment variables in logs
- Hardcoded in code
- Developer laptops
```

**Setup Example:**

```bash
# 1. Generate key pair (one time)
openssl genrsa -out private_key.pem 4096
openssl rsa -in private_key.pem -pubout -out public_key.pem

# 2. Store private_key.pem in GitHub Secrets
# Settings > Secrets > New Repository Secret
# SECRET_NAME: GAIA_PRIVATE_KEY
# VALUE: (paste contents of private_key.pem)

# 3. Commit public_key.pem to repo
git add public_key.pem
git commit -m "chore: add public key for signature verification"

# 4. CI/CD uses secret to sign
# In GitHub Actions:
env:
  PRIVATE_KEY: ${{ secrets.GAIA_PRIVATE_KEY }}
```

---

## Comparison: Approach 1 vs Approach 2

| Factor | Hardcoded URLs | Signatures |
|--------|----------------|-----------|
| **Security** | Very High | Very High |
| **Implementation Complexity** | Low | Medium-High |
| **Key Management** | None | Critical |
| **Setup Time** | ~1 day | ~3-5 days |
| **Maintenance** | Medium (update CLI per skill) | Low (auto-sign in CI/CD) |
| **Scalability** | Low (must hardcode) | High (works with any skill) |
| **Dynamic Skills** | ❌ No | ✅ Yes |
| **Performance Impact** | None | 2+ extra HTTP requests |
| **Industry Standard** | No (custom) | ✅ Yes (GPG, npm, Docker) |

---

## Recommended: Hybrid Approach

### Best of Both Worlds

**Phase 2A: Implement Hardcoded URLs** (immediate, quick)
```javascript
// Prevent known attack vector
// Works for all current v2 skills
// Simple to implement
```

**Phase 2B: Add Signature Verification** (next iteration)
```javascript
// Defense in depth
// Support future dynamic discovery
// Industry standard practice
```

### Phased Implementation Timeline

```
Week 1: Hardcoded URLs
├── Create SKILL_URLS registry
├── Update CLI to check registry
└── Test with personality-analyzer

Week 2: Signature Verification
├── Generate key pair
├── Setup GitHub Secrets
├── Add signing to CI/CD
└── Test signature verification in CLI

Week 3: Integration & Testing
├── Test both approaches together
├── Document key management
├── Security audit
└── Release as v2.1.0
```

---

## Implementation Checklist

### Approach 1: Hardcoded URLs

- [ ] Create `SKILL_URLS` registry in CLI
- [ ] Update `runSkill()` to use registry only
- [ ] Add registry check: `if (!SKILL_URLS[skillName]) throw Error`
- [ ] Add URL validation: reject non-github.com URLs
- [ ] Test: try to override URL locally (should fail)
- [ ] Test: try to run non-registered skill (should fail)
- [ ] Add skill to registry for each new v2 skill
- [ ] Document: How to add skills to registry
- [ ] Release: v2.1.0 with hardcoded URLs

### Approach 2: Signature Verification

- [ ] Generate RSA key pair (4096-bit)
- [ ] Store private key in GitHub Secrets
- [ ] Commit public key to repo
- [ ] Create signing GitHub Action workflow
- [ ] Test: modify INSTRUCTION.md, verify signature fails
- [ ] Test: restore INSTRUCTION.md, verify signature passes
- [ ] Add verification to CLI `runSkill()`
- [ ] Fetch and verify signature before execution
- [ ] Document: Key rotation procedures
- [ ] Document: How to troubleshoot signature failures
- [ ] Release: v2.2.0 with signature verification

---

## User Experience Impact

### V1 (Current - Vulnerable)
```bash
$ npx @gaia/skills personality-analyzer
✅ Executes (even if SKILL.md was edited to point to malicious URL)
⚠️ User has no way to know if policies are enforced
```

### V2A (Hardcoded URLs)
```bash
$ npx @gaia/skills personality-analyzer
✅ Executes
✅ User cannot override URL
✅ Policies are enforced
? Less discoverable (hardcoded list only)
```

### V2B (Signatures Added)
```bash
$ npx @gaia/skills personality-analyzer
✅ Executing personality-analyzer...
✅ Fetching INSTRUCTION.md from GitHub...
✅ Verifying signature... OK
✅ Policies are enforced
✅ User has proof of authenticity
```

---

## Security Threat Model

### Threats Mitigated by Approach 1 (Hardcoded URLs)

| Threat | V1 | V2A |
|--------|----|----|
| User edits SKILL.md to point to attacker's INSTRUCTION.md | ✗ | ✅ |
| Man-in-the-middle (MITM) attack | ✗ (HTTPS helps) | ✅ (+ hardcoding) |
| Malicious fork of repo has different URLs | ✗ | ✅ |
| Skill developer updates URL maliciously | ✗ | ⚠️ (CLI update needed) |

### Threats Mitigated by Approach 2 (Signatures)

| Threat | V1 | V2B |
|--------|----|----|
| INSTRUCTION.md is modified during transport | ✗ | ✅ |
| INSTRUCTION.md is modified in repository | ✗ | ✅ |
| Private key compromised | N/A | ❌ (key rotation needed) |
| Public key is compromised | N/A | ⚠️ (must rotate) |

### Combined V2A + V2B

| Threat | Status |
|--------|--------|
| User edits SKILL.md | ✅ Blocked (hardcoding) |
| MITM attack | ✅ Blocked (hardcoding + signatures) |
| INSTRUCTION.md tampering | ✅ Detected (signatures) |
| Malicious repo fork | ✅ Blocked (hardcoding) |
| Skill developer attack | ⚠️ Requires key compromise |

---

## Cost-Benefit Analysis

### Hardcoded URLs (Approach 1)

**Cost:**
- 1-2 days implementation
- Ongoing: +1 day per new skill (update CLI)
- Medium cognitive overhead

**Benefit:**
- Prevents main attack vector
- Very simple and maintainable
- No key management complexity
- Production-ready immediately

**ROI:** High (quick win)

### Signatures (Approach 2)

**Cost:**
- 3-5 days implementation
- Ongoing: automated in CI/CD (~1 minute per skill)
- Higher cognitive overhead
- Key management procedures

**Benefit:**
- Industry standard security practice
- Supports dynamic discovery
- Detects any tampering
- Crypto-verified authenticity
- Scales to unlimited skills

**ROI:** High (long-term investment)

---

## Recommendation for Your Project

### If You Need Security Now:
✅ **Implement Approach 1 (Hardcoded URLs)** first
- Quick to implement
- Solves the main risk immediately
- No key management
- Sufficient for MVP/PoC

### If You Plan to Scale:
✅ **Plan for Approach 2 (Signatures)** in roadmap
- More scalable
- Industry standard
- Better long-term story
- Required for production at scale

### Best Practice:
✅ **Implement Both (Hybrid Approach)**
- Defense in depth
- Cover all attack vectors
- Demonstrate security maturity
- Give users confidence

---

## Next Steps

1. **Choose approach:**
   - Option A: Hardcoded URLs only (quick)
   - Option B: Both approaches (comprehensive)

2. **If Option A:**
   - Start: Create SKILL_URLS registry
   - Test: Verify URL override fails
   - Release: v2.1.0

3. **If Option B:**
   - Start: Implement Approach 1 first (1 week)
   - Then: Add Approach 2 (2 weeks)
   - Release: v2.1.0 (URLs) → v2.2.0 (Signatures)

4. **Documentation:**
   - Create security architecture diagram
   - Document key management procedures
   - Create threat model document
   - Add troubleshooting guide

---

**Prepared for:** personality-analyzer deployment  
**Status:** Ready for decision on which approach to implement
