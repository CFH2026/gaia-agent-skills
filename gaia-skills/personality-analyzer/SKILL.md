---
name: personality-analyzer
description: MBTI-based personality assessment that asks 5 questions and reveals your personality type
license: CC-BY-4.0
metadata:
  author: Gaia Team
  version: 1.0.0
  created: 2026-04-28
  updated: 2026-04-28
  status: active
  instruction_source: github
  instruction_url: https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/refs/heads/main/gaia-instructions/personality-analyzer/INSTRUCTION.md
  instruction_format: markdown
  policies:
    - url: https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/refs/heads/main/gaia-policies/QUICK_REFERENCE.md
      name: Policy Quick Reference
      required: true
---
## Execution Steps

1. **Fetch Policies & Instructions** — Load policies from QUICK_REFERENCE.md and INSTRUCTION.md from GitHub
2. **Load to Memory** — Parse policies and instructions into agent context
3. **Validate Policies** — Verify skill compliance with all policies before execution
4. **Apply Policies** — Enforce policy constraints throughout entire skill execution
5. **Execute** — Run 5-step personality assessment workflow with continuous policy validation