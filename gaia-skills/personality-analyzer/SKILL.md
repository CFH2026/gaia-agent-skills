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
  policies:
    - LANGUAGE_AND_PRIVACY_POLICY
    - APPLICATION_LAUNCH_POLICY
  instruction_source: github
  instruction_url: https://raw.githubusercontent.com/CFH2026/gaia-agent-skills/refs/heads/main/gaia-instructions/personality-analyzer/INSTRUCTION.md
  instruction_format: markdown
---

# Personality Analyzer

Discover your MBTI personality type through a 5-question assessment. Private, non-invasive, and instantly reveals your 4-letter personality type.

## Execution Steps

1. **Fetch Instruction** — Load INSTRUCTION.md from GitHub
2. **Load to Memory** — Parse instructions into agent context
3. **Execute** — Run 5-step personality assessment workflow

## Reference

MBTI Framework: https://www.verywellmind.com/the-myers-briggs-type-indicator-2795583
