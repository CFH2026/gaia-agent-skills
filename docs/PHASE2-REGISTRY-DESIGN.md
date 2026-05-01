# Phase 2: Skills Registry Design — Meeting Your Requirements

**Created:** 2026-05-01  
**Status:** Updated Phase 2 Spec to support versioning + canary + deployment traceability

---

## Your Requirements → Registry Solution

You stated four critical requirements for Phase 2:
1. **Deployment traceability** — Track which versions are deployed where
2. **Flexible skill deployment** — Update skills without redeploying MCP
3. **Canary rollout** — Test with subset of users before full release
4. **User version selection** — Let users choose which version to use

**Problem with original Phase 2 spec:** MCP fetches from GitHub directly. All users get same version. Skill updates require MCP redeployment.

**Solution:** Add **Skills Registry** layer between MCP and GitHub.

---

## Architecture: Before → After

### Before (Original Phase 2)
```
User → MCP Server → GitHub
         (fetches latest)
         
Problem: All users get same version
         Skill updates require MCP redeploy
         No version selection
         No canary support
```

### After (Phase 2 with Registry)
```
User → MCP Server → Skills Registry → GitHub (source)
        (authenticates)  (versioned)    (publishes)
                      ↓
                      S3 + DynamoDB
                      (immutable versions)
                      
Benefit: Independent skill versioning
         Users can select versions
         Canary rollout support
         Deployment traceability
```

---

## How Each Requirement is Solved

### 1. Deployment Traceability ✅

**Registry maintains full audit trail for each version:**

```json
GET /skills/personality-analyzer/versions?limit=10

Response: [
  {
    "version": "2.1.0",
    "published_at": "2026-05-01T08:00:00Z",
    "deployed_by": "github-actions[bot]",
    "commit_sha": "a7b3f9e2c1d8",
    "commit_message": "fix: improve MBTI accuracy",
    "changeset_url": "https://github.com/.../commit/a7b3f9e2c1d8"
  },
  {
    "version": "2.0.0",
    "published_at": "2026-04-28T14:30:00Z",
    "deployed_by": "github-actions[bot]",
    "commit_sha": "xyz789def",
    "commit_message": "feat: initial skill release",
    ...
  }
]
```

**Query:** "Who has what version deployed?"
- Registry API returns all versions with publish timestamp
- CloudWatch logs show which users accessed which versions
- DynamoDB tracks canary rules history

---

### 2. Flexible Skill Deployment ✅

**Skills update independently from MCP.**

**Scenario:** Bug fix in personality-analyzer

1. Engineer commits fix to `gaia-instructions/personality-analyzer/INSTRUCTION.md`
2. CI/CD publishes new version to Registry: `v2.1.1`
3. Registry stores as: `s3://gaia-skills-registry/personality-analyzer/v2.1.1/INSTRUCTION.md`
4. MCP server does NOT need restart or redeploy
5. Users with `"personality-analyzer": "latest"` automatically get v2.1.1 next request
6. Users with `"personality-analyzer": "2.1.0"` continue using v2.1.0 (no breaking change)

**Result:** Deploy 10 skills without touching MCP code.

---

### 3. Canary Rollout ✅

**Admin configures who gets which version:**

```json
{
  "skill_name": "personality-analyzer",
  "canary_enabled": true,
  "rules": [
    {
      "version": "2.2.0-canary",
      "user_ids": ["user_001", "user_002"],  // 2 testers
      "percentage": 0
    },
    {
      "version": "2.2.0-beta",
      "percentage": 25  // 25% of other users
    },
    {
      "version": "2.1.0",
      "percentage": 75  // 75% stable
    }
  ]
}
```

**How it works:**
1. `user_001` requests personality-analyzer
2. MCP queries: `GET /skills/personality-analyzer/canary?user_id=user_001`
3. Registry checks rules, returns v2.2.0-canary
4. MCP serves v2.2.0-canary to user_001
5. Meanwhile, user_456 gets v2.2.0-beta (25% route)
6. And user_789 gets v2.1.0 (75% stable)

**All simultaneously.** No redeployment needed. Just update canary rules.

---

### 4. User Version Selection ✅

**Users specify which versions to use in their local config:**

**Claude Code:** `~/.claude/settings.json`
```json
{
  "mcp_servers": {
    "gaia-skills": {
      "url": "https://mcp-gaia-skills.example.com",
      "env": {
        "GAIA_API_KEY": "sk_gaia_xxxxxxxxxxxxx",
        "GAIA_SKILL_VERSIONS": {
          "personality-analyzer": "2.1.0",      // Pin to 2.1.0
          "modelhub-query-v2": "latest",            // Always latest
          "experimental-skill": "canary"            // Opt into canary testing
        }
      }
    }
  }
}
```

**Behavior:**
- `"2.1.0"` — Always uses exactly v2.1.0 (never auto-upgrades)
- `"latest"` — Always fetches latest stable release (auto-upgrades)
- `"canary"` — Uses canary version if available (for testing)
- `"2.2.0-beta"` — Specific pre-release version

**Result:** Each user controls their own version strategy.

---

## Why Registry Solves All Four

| Requirement | Registry Support | Mechanism |
|-------------|-----------------|-----------|
| **Deployment Traceability** | ✅ Full audit trail | DynamoDB stores publish metadata, CloudWatch logs access patterns |
| **Flexible Deployment** | ✅ Independent versioning | Skills published to S3 independently, MCP just queries registry |
| **Canary Rollout** | ✅ Version routing | Admin rules route users to different versions, no MCP changes |
| **User Version Selection** | ✅ Version in settings | Users configure `GAIA_SKILL_VERSIONS` in MCP config, versioned forever |

---

## Trade-offs: What You Gain vs. Cost

### What You Gain ✅
- **Flexible deployment:** Deploy skills without MCP server updates
- **Version control:** Know exactly which version each user has
- **Canary safety:** Test new versions with small user groups first
- **User control:** Different users can use different versions
- **Rollback:** Serve older version if new one has issues
- **No coupling:** MCP version independent of skill versions

### What You Cost ❌
- **One more service:** Registry API + S3 + DynamoDB
- **One more network call:** MCP → Registry (small latency)
- **Operational complexity:** Monitor registry, handle S3 permissions
- **Skill bloat:** S3 holds multiple versions (storage cost ~negligible for text files)

### Cost Estimate
- **Development:** 2-3 weeks (includes Registry API, S3 setup, canary logic)
- **AWS costs:** ~$5-20/month (S3 storage, DynamoDB, Lambda)
- **Operational burden:** Medium (monitor registry uptime, handle S3 access)

---

## Phase 2 Rollout (Updated)

### Phase 2a: Registry + Basic Versioning (1 week)
- [ ] Deploy Skills Registry API (S3 + DynamoDB)
- [ ] Deploy MCP server (with version support)
- [ ] Publish personality-analyzer (v2.0.0, v2.1.0)
- [ ] Test version selection

### Phase 2b: Auth + Canary (1 week)
- [ ] Add API key authentication
- [ ] Implement canary rules in registry
- [ ] Test canary rollout with users
- [ ] Document in settings

### Phase 2c: Production Ready (1 week)
- [ ] Rate limiting per API key
- [ ] Monitoring + alerting
- [ ] Full test coverage
- [ ] Migrate all V1 skills with versions

**Total:** 3 weeks (same as original, but now with full flexibility)

---

## What Changed in SPEC-20260501-002

**Updated sections:**
1. ✅ Architecture diagram — added Registry between MPC and GitHub
2. ✅ Components table — added Skills Registry API
3. ✅ MCP tool signatures — added `version` parameter
4. ✅ Tool behavior — version selection with `latest`, `canary`, pinned versions
5. ✅ **NEW:** Version Management & Canary Rollout section
6. ✅ **NEW:** Deployment Traceability details
7. ✅ Infrastructure — added S3 + DynamoDB architecture
8. ✅ CI/CD workflow — publish to registry instead of just signing
9. ✅ Rollout plan — includes registry deployment phases
10. ✅ Open questions — registry backend, version numbering, canary rules

**NOT removed:**
- ✅ Embedded policies (still there)
- ✅ API key authentication (still there)
- ✅ Server-side policy enforcement (still there)
- ✅ Optional signature verification (registry can verify before storing)

---

## Next Steps

### For You (Decision):
1. Review updated SPEC-20260501-002
2. Confirm registry backend choice (AWS S3+DynamoDB recommended)
3. Decide on version numbering (SemVer vs Git SHA)
4. Approve rolling out Phase 2a

### For Implementation:
1. Design Registry API (POST /publish, GET /versions, etc.)
2. Setup S3 bucket + DynamoDB table
3. Update CI/CD to publish to Registry
4. Update MCP to query Registry with version parameter
5. Test end-to-end versioning

---

## Summary

**Before:** "Can we use MCP?" → "Yes, but all users get same version always."  
**After:** "Can we support versioning + canary + user selection?" → "Yes, with Skills Registry."

This is the **Pattern 2 (MCP + Registry)** from your comparison document, fully specified and ready to implement.

**Status:** Updated Phase 2 spec is complete. Ready for team review.

