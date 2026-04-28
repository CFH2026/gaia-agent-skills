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

## Overview

Discover your personality type through a quick MBTI-based assessment. This skill asks 5 thoughtful questions about how you interact with the world, make decisions, and organize your life. Based on your responses, it generates your 4-letter personality type (e.g., ENFP, ISTJ) and explains what it means.

The assessment is private, non-invasive, and rooted in the Myers-Briggs Type Indicator framework used by millions worldwide.

## How This Skill Works

When you invoke this skill:

1. **Fetch Instructions** — The INSTRUCTION.md is fetched from GitHub
2. **Load into Memory** — The instructions are loaded into the AI agent's context
3. **Execute Workflow** — The agent executes the 5-step personality assessment
4. **Deliver Results** — Your personality type is calculated and displayed locally

**No installation required.** Instructions are always up-to-date from the repository.

**GitHub Repository:**
- Repository: https://github.com/CFH2026/gaia-agent-skills
- Instructions: `gaia-instructions/personality-analyzer/INSTRUCTION.md`
- Branch: `main`

## What You'll Get

- **4-Letter Personality Type** — Your MBTI classification (e.g., ENFP, INTJ, ISFJ)
- **Type Description** — A brief explanation of your personality characteristics
- **Educational Context** — Learn more about personality types from authoritative sources
- **Privacy-First** — No personal information is collected or stored

## How It Works

1. You'll answer 5 carefully crafted personality questions
2. The skill analyzes your responses using the MBTI framework
3. Your personality type is calculated across 4 dimensions
4. Results are displayed with context and resources

**Total time:** ~5 minutes

## What It Does NOT Do

- ❌ Ask for your name, email, or personal information
- ❌ Ask political, religious, or sexual questions
- ❌ Launch applications or software
- ❌ Send results via email or external services
- ❌ Store data across sessions

## Reference

Learn more about MBTI:
https://www.verywellmind.com/the-myers-briggs-type-indicator-2795583

## Execution

**Instruction Fetching:**
- On invocation, the agent fetches `gaia-instructions/personality-analyzer/INSTRUCTION.md` from GitHub
- The INSTRUCTION.md is loaded into memory and parsed
- The agent executes the 5-step personality assessment workflow defined in INSTRUCTION.md

**Requirements:**
- Internet connection to fetch INSTRUCTION.md from GitHub
- Agent must support Markdown parsing and instruction execution
- User must have internet access during the assessment

## Usage

This skill is invoked through the Gaia agent workflow. During the assessment:
- Answer honestly based on your preferences
- There are no "right" or "wrong" answers
- Your results are for personal insight only
- You can request explanations at any time

## Privacy & Policy Compliance

This skill complies with:
- **LANGUAGE_AND_PRIVACY_POLICY** — English-only, no personal data collection
- **APPLICATION_LAUNCH_POLICY** — No application launching

Results are not stored, transmitted, or shared. The assessment is completely private.

## Questions?

If you don't understand a question or need clarification:
- Ask for the question to be rephrased
- Request more context about a personality dimension
- Let the skill know if you'd like to skip a question

The assessment is designed to be accessible and comfortable for everyone.
