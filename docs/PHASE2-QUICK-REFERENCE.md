# Phase 2 Security: Quick Reference

## TL;DR

| Approach | What It Does | Effort | Timeline | Best For |
|----------|-------------|--------|----------|----------|
| **1: Hardcoded URLs** | CLI has official URLs built in, ignores SKILL.md URLs | Low | 1-2 days | Quick MVP security |
| **2: Signatures** | INSTRUCTION.md is cryptographically signed & verified | Medium | 2-3 weeks | Production security |
| **Both** | Defense in depth - both protections active | Medium | 3-4 weeks | Maximum security |

---

## Approach 1: Hardcoded URLs

### The Problem It Solves

```
❌ User edits SKILL.md
❌ Changes instruction_url to attacker.com
❌ CLI fetches from attacker
❌ No policies enforced

✅ With hardcoding:
✅ CLI ignores SKILL.md
✅ Uses hardcoded official URL
✅ Attack blocked
```

### How It Works

```javascript
// CLI has this:
const URLS = {
  'personality-analyzer': 'https://github.com/CFH2026/...INSTRUCTION.md'
};

// User can't change this
// Even if SKILL.md is edited
```

### Implementation

```
1. Create SKILL_URLS mapping in CLI code
2. Update runSkill() to check registry
3. Reject if skill not in registry
4. Fetch from hardcoded URL only

That's it!
```

### Timeline

```
Day 1:  Code (2-3 hours)
Day 1:  Test (2 hours)
Day 2:  Release (30 min)
```

### Limitations

```
❌ Must update CLI for each new skill
❌ Requires new CLI release per skill
❌ Not flexible for dynamic discovery
❌ Doesn't detect tampering (just prevents override)
```

### Security Coverage

```
✅ Blocks: User edits SKILL.md
✅ Blocks: Malicious repo forks
⚠️ Helps: MITM attacks (HTTPS already helps)
❌ Doesn't detect: INSTRUCTION.md tampering
```

---

## Approach 2: Signature Verification

### The Problem It Solves

```
❌ What if INSTRUCTION.md is modified?
❌ What if MITM attack changes the file?
❌ How does user know file is authentic?

✅ With signatures:
✅ INSTRUCTION.md is cryptographically signed
✅ Any modification breaks signature
✅ User gets proof of authenticity
```

### How It Works

```
Publish Time:
  1. Hash INSTRUCTION.md
  2. Sign hash with private key
  3. Upload signature to GitHub

Runtime:
  1. Fetch INSTRUCTION.md
  2. Fetch signature
  3. Verify signature with public key
  4. If OK → execute
  5. If broken → reject
```

### Implementation

```
1. Generate RSA key pair
2. Store private key in GitHub Secrets
3. Add signing step to CI/CD
4. Add verification to CLI
5. Test signature workflow
```

### Timeline

```
Week 1 Day 1: Setup keys (2 hours)
Week 1 Day 1: CI/CD signing (3 hours)
Week 1 Day 2: CLI verification (4 hours)
Week 2 Day 1: Testing (4 hours)
Week 2 Day 2: Documentation (3 hours)
```

### Limitations

```
⚠️ More complex to implement
⚠️ Key management required (protect private key!)
⚠️ Extra network requests (fetch signature file)
⚠️ Performance overhead (~100ms per execution)
❌ Doesn't prevent URL override (need Approach 1 for that)
```

### Security Coverage

```
✅ Detects: INSTRUCTION.md tampering
✅ Detects: MITM modifications
✅ Prevents: Signature forgery (without private key)
✅ Works with: Any number of skills
❌ Doesn't prevent: URL override
```

---

## Side-by-Side Comparison

### Threat: User Edits SKILL.md

```
Approach 1: ✅ Blocked (hardcoded URL)
Approach 2: ❌ Still vulnerable (doesn't prevent this)
```

### Threat: INSTRUCTION.md Modified

```
Approach 1: ❌ Not detected (just verifies URL)
Approach 2: ✅ Detected (signature fails)
```

### Threat: MITM Attack

```
Approach 1: ✅ Mitigated (hardcoding + HTTPS)
Approach 2: ✅ Mitigated (signatures)
```

### Threat: Malicious Repo Fork

```
Approach 1: ✅ Blocked (hardcoded official URL)
Approach 2: ⚠️ Partially (fork's INSTRUCTION.md won't verify)
```

### Threat: Skill Developer Goes Rogue

```
Approach 1: ❌ Not prevented (CLI fetches malicious file)
Approach 2: ✅ Prevented (can't sign without private key)
```

---

## Implementation Complexity

### Approach 1: Simple

```javascript
// Just this:
const SKILL_URLS = {
  'personality-analyzer': 'https://...'
};

// Check:
if (!SKILL_URLS[skillName]) throw Error;

// Fetch:
const url = SKILL_URLS[skillName];
const result = await fetch(url);
```

### Approach 2: Complex

```javascript
// Need:
1. Generate keys (openssl commands)
2. Store keys securely (GitHub Secrets)
3. CI/CD workflow (sign each file)
4. CLI verification logic (RSA crypto)
5. Error handling (signature failures)
6. Key rotation procedures
7. Troubleshooting guide
```

---

## What Each Approach Actually Prevents

### Hardcoded URLs Prevents

✅ User locally modifying SKILL.md to point to attacker  
✅ Attacker creating fork with different URLs  
✅ Most common attack scenario

### Signatures Prevent

✅ Man-in-the-middle modifying INSTRUCTION.md  
✅ Attacker uploading fake INSTRUCTION.md to GitHub  
✅ Insider threat (rogue developer)  
✅ Detection of any file tampering

---

## My Honest Assessment

### Approach 1 is:
- ✅ Good enough for MVP
- ✅ Solves 80% of real threats
- ✅ Quick to implement
- ✅ Easy to maintain
- ❌ Not scalable long-term
- ❌ Doesn't detect tampering

### Approach 2 is:
- ✅ Industry standard (npm, Docker, GPG all use this)
- ✅ Scalable to unlimited skills
- ✅ Detects tampering
- ✅ Professional grade
- ❌ More complex
- ❌ Requires key management
- ❌ Slower to implement

### Hybrid (Both) is:
- ✅ Defense in depth
- ✅ Handles all threat scenarios
- ✅ Professional + simple
- ✅ Shows security maturity
- ❌ Takes longest to implement

---

## Decision Tree

```
Q1: Do you need security in the next 1 week?
├─ YES → Approach 1 (hardcoded URLs)
└─ NO → Continue to Q2

Q2: Do you plan to have >50 skills eventually?
├─ YES → Approach 2 (or both)
└─ NO → Continue to Q3

Q3: What's your security requirement level?
├─ MVP/PoC → Approach 1
├─ Production → Approach 2
└─ Enterprise → Both
```

---

## Recommended Timeline

### Sprint 1 (This Week):
```
Choose: Do you want Approach 1 only or plan for both?

If Approach 1:
  Day 1-2: Implement hardcoded URLs
  Day 2: Test & release
  → v2.1.0 shipped with hardcoding
```

### Sprint 2+ (Later):
```
If planning signatures later:
  Week 1: Setup key management
  Week 1-2: Implement signatures
  → v2.2.0 shipped with both approaches
```

---

## Which Should You Choose?

### Choose Approach 1 If:
✅ Need to ship security quickly  
✅ Have <20 skills  
✅ Don't expect many more skills  
✅ Users are trusted environment (internal)  
✅ MVP phase is priority

### Choose Approach 2 If:
✅ Planning enterprise deployment  
✅ Expect to scale to many skills  
✅ High security requirement  
✅ Need industry-standard practices  
✅ Public/external users

### Choose Both If:
✅ Want maximum security  
✅ Have resources for 3-4 week effort  
✅ Planning production deployment  
✅ Want to showcase security maturity  
✅ Enterprise or security-sensitive org

---

## One More Thing: The Real Risk

### What's Most Likely to Happen?

```
Scenario 1: User edits SKILL.md
  Probability: Medium (if documented)
  Impact: High (policies bypassed)
  Solution: Approach 1 (hardcoding)

Scenario 2: INSTRUCTION.md tampering
  Probability: Low (GitHub has good security)
  Impact: Very High (undetected)
  Solution: Approach 2 (signatures)

Scenario 3: Insider threat
  Probability: Low (small team)
  Impact: Very High (hard to detect)
  Solution: Approach 2 (keys only with CI/CD)
```

**Bottom line:** Approach 1 prevents the most likely attack. Approach 2 prevents the most damaging attacks.

---

## Summary

| Feature | Approach 1 | Approach 2 | Both |
|---------|-----------|-----------|------|
| Time to implement | 1-2 days | 2-3 weeks | 3-4 weeks |
| Complexity | Simple | Complex | Medium |
| Prevents URL override | ✅ Yes | ❌ No | ✅ Yes |
| Detects tampering | ❌ No | ✅ Yes | ✅ Yes |
| Scalable | ❌ No | ✅ Yes | ✅ Yes |
| Industry standard | ❌ Custom | ✅ Yes | ✅ Yes |
| Best for MVP | ✅ Yes | ❌ No | ❌ Overkill |
| Best for production | ⚠️ Maybe | ✅ Yes | ✅ Yes |

---

## Next Step: Decision

**What would you like to do?**

A) **Implement Approach 1 only** (quick MVP security)  
   - Timeline: 1-2 days  
   - Result: personality-analyzer v2.1.0

B) **Plan for both approaches** (comprehensive security)  
   - Timeline: 3-4 weeks  
   - Result: personality-analyzer v2.1.0 + v2.2.0

C) **Just Approach 2** (skip the quick win)  
   - Timeline: 2-3 weeks  
   - Result: personality-analyzer v2.2.0 with signatures

D) **Defer Phase 2 entirely** (use V1 model for now)  
   - Timeline: N/A  
   - Risk: Policies can be bypassed

---

**Which option interests you most?**
