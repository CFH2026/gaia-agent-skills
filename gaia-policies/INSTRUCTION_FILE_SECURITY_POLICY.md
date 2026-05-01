---
name: INSTRUCTION_FILE_SECURITY_POLICY
description: Prohibits saving INSTRUCTION.md and policy files to local storage. Enforces memory-only execution.
type: policy
version: 1.0.0
created: 2026-05-01
---

# Instruction File Security Policy

This policy prohibits persisting INSTRUCTION.md files and policy files to local disk storage. All instruction and policy content must be loaded into memory only and discarded at session end.

---

## What Is Prohibited

### Saving Files to Disk
Do NOT write INSTRUCTION.md or policy files to:
- User's local filesystem
- Temporary directories (/tmp, %TEMP%, etc.)
- Cache directories
- Project directories
- Any persistent storage

### Caching Files
Do NOT cache INSTRUCTION.md or policy files:
- No local file caching
- No database storage
- No Redis/memcached persistence
- No persistent state files

### Retaining Files Between Sessions
Do NOT retain instruction or policy content:
- No session-to-session persistence
- No cross-invocation retention
- No archived copies
- No backup copies

### Indirect Persistence
Do NOT attempt indirect persistence:
- No environment variables storing file content
- No configuration files containing instructions
- No logs containing full instruction text
- No telemetry including instruction data

---

## What Is Allowed

### Memory-Only Operations
ALLOWED:
- Load INSTRUCTION.md into memory for current execution
- Load policy files into memory for current execution
- Hold content in RAM during the session
- Reference content while executing
- Pass content to function calls during execution

### Session-Local Data
ALLOWED:
- Store execution state in memory
- Store assessment results in memory (session-local only)
- Store user responses in memory (session-local only)
- Keep temporary execution variables in memory

---

## Enforcement

### At Session Start
1. Fetch INSTRUCTION.md from GitHub into memory
2. Fetch policy files from GitHub into memory
3. Load all content into RAM only

### During Execution
1. All references to instruction/policy must be from memory
2. No file I/O operations for instruction content
3. No write operations to disk for any fetched files

### At Session End
1. Explicitly clear all instruction content from memory
2. Explicitly clear all policy content from memory
3. Remove all temporary variables holding file references
4. Leave zero artifacts on disk

---

## Why This Matters

**Security:**
- Prevents unauthorized modification of instructions
- Prevents instruction tampering via disk access
- Ensures policies cannot be edited after fetching

**Privacy:**
- Reduces data footprint on user systems
- Prevents accidental data leaks from cached files
- Ensures no persistent records of skill instructions

**Compliance:**
- Guarantees fresh policies on every execution
- Prevents stale/compromised instruction execution
- Ensures no bypass of policy enforcement

**Integrity:**
- Guarantees instructions match GitHub source
- Prevents substitution of modified versions
- Ensures code authenticity

---

## Violation Examples

These actions VIOLATE this policy:

```python
# VIOLATION: Saving INSTRUCTION.md to disk
with open('/home/user/instruction.md', 'w') as f:
    f.write(instruction_content)

# VIOLATION: Caching policy file
with open('/tmp/policy_cache.txt', 'w') as f:
    f.write(policy_content)

# VIOLATION: Storing in environment variable (persists across sessions)
os.environ['SKILL_INSTRUCTION'] = instruction_md

# VIOLATION: Writing to config file
config['cached_instruction'] = instruction_content
save_config(config)

# VIOLATION: Logging full instruction content
logging.info(f"Executing: {instruction_content}")

# VIOLATION: Writing to database
db.policies.insert({'content': policy_content})
```

---

## Compliant Examples

These actions COMPLY with this policy:

```python
# COMPLIANT: Load into memory for this session only
instruction_content = fetch_from_github(url)
execute_instruction(instruction_content)
# At end of function: content is garbage collected

# COMPLIANT: Use in-memory variables only
policy_rules = fetch_policies_from_github()
enforce_policies(policy_rules)
# policy_rules is discarded when function returns

# COMPLIANT: Session-local state only
results = {'assessment': 'ENFP', 'timestamp': now()}
return results  # Returned to user, not saved to disk

# COMPLIANT: Log only metadata, not content
logging.info("Skill executed successfully")  # No instruction content
```

---

## Breach Consequences

If this policy is violated:

1. **Detection** — Violation is detected immediately
2. **Halt** — Execution stops immediately
3. **Report** — Violation is logged with details
4. **Cleanup** — All disk artifacts are removed
5. **Prevention** — Future executions validate compliance

---

## No Exceptions

This is a hard constraint. There are NO exceptions for:
- Development/debugging
- Caching optimization
- Performance improvement
- Testing or CI/CD
- Any other circumstance

If a legitimate use case requires file persistence, the use case itself must be reconsidered.

---

## Summary

INSTRUCTION.md and policy files are **NEVER** saved to local storage. All content is memory-only, loaded fresh each execution, and discarded at session end.

This is non-negotiable.
