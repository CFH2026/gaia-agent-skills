---
name: code-review
version: 1.0.0
description: |
  Review code changes for correctness, style, potential bugs, and improvements.
  Useful when you want an independent assessment of your diff before landing it.
triggers:
  - review this code
  - what do you think about this change
  - is this code correct
---

# Code Review

Review code changes for potential issues, style improvements, and architectural concerns.

## When to use

- Before landing a pull request
- When you're unsure about a design decision
- To catch edge cases or security issues
- To ensure consistency with the codebase style

## Process

1. **Get the diff** — Ask for the files or code to review, or analyze recent changes
2. **Static analysis** — Look for:
   - Logic errors and edge cases
   - Type safety issues
   - Security vulnerabilities (injection, XSS, SQL, etc.)
   - Performance concerns
   - Missing error handling
3. **Style and architecture** — Check for:
   - Consistency with the rest of the codebase
   - Naming clarity
   - Unnecessary abstractions or duplication
   - Test coverage
4. **Report findings** — Categorize by severity and provide specific fixes

## Tips

- If you have access to the repository, run the type checker and tests first — they often catch issues before review
- Point to specific line numbers and provide context
- Suggest concrete improvements, not just problems
- Consider the trade-offs between perfect code and shipped code
