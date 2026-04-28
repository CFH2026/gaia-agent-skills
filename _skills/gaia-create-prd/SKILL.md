---
name: gaia-create-prd
description: Creates a Product Requirements Document (PRD) for a feature or initiative by gathering requirements through structured conversation, then populating the standard PRD template. Use when anyone wants to write a PRD, draft product requirements, document a new feature, or capture requirements for a project initiative. Triggers on: "create a PRD", "write a PRD", "draft requirements", "product requirements for", "I need a PRD", "help me document this feature". Do NOT use for solution architecture documents (use create-solution-architect), technical design specs (use architect-spec), or general documentation tasks.
license: CC-BY-4.0
metadata:
  author: Carlson
  version: 1.5.0
---

# Create PRD

Guides anyone — product managers, engineers, designers, TPMs, or business analysts — through creating a Product Requirements Document, from gathering requirements via structured conversation to producing a complete, saved PRD based on the standard template.

> `<project-root>` refers to the root directory of the repository this skill is installed in (i.e., the directory containing `.claude/`).

## Instructions

### Phase 0: Study Project Context via ADO API

Before asking any questions, fetch live project context directly from ADO. Follow **`_tools/ado-code-repo.md`** for authentication, endpoint format, and error handling.

Fetch the file tree and key files for both repos:
- `lambda-aws-gaia-api-logic`
- `terraform-aws-gaia-api-infra`

Priority files to fetch: `/README.md`, `/serverless-prod.yml`, `/main.tf`, and key handlers under `src/`.

**Use this context to:**
- Pre-fill or suggest answers where the source code already provides relevant information
- Ask more informed and specific follow-up questions
- Ensure the PRD is grounded in the actual system architecture, not generic assumptions

---

### Phase 1: Gather Core Information

Before drafting anything, start by showing the user the full list of questions you will be asking, so they know what to expect:

---
Here are the questions I'll ask you — one at a time:

1. What is the feature name?
2. What is the Epic ID? (e.g. `A001` — leave blank if unknown)
3. What problem does this solve, for whom, and why now?
4. What is the primary goal — the single most important outcome this must achieve?
5. What is explicitly out of scope (anti-goals)?
6. Who are the key stakeholders? (Product Owner, Tech Lead, business sponsor, etc.)
7. What is the target timeline or launch milestone?

Let's start with question 1.

---

Then ask each question **one at a time**, waiting for the user's response before moving to the next. Do not ask multiple questions in the same message.

If the user provides a description upfront (e.g., "Create a PRD for X which does Y"), extract as much as possible, show the remaining unanswered questions, and proceed one at a time from there.

Do NOT start drafting until you have at least items 1–4 confirmed.

---

### Phase 2: Clarify Depth

Ask the user how much detail they want to provide now vs. leave as placeholders:

- **Quick draft** — fill in what we know, mark everything else `[TBD]`, good for early-stage ideation
- **Full draft** — work through each section interactively, good for features nearing development

If they don't specify, default to **Quick draft** and offer to expand any section.

---

### Phase 3: Draft the PRD

Using the template at `prd-template.md` (read it now), populate each section with the gathered information.

**Language rule:** The PRD title (H1 heading) and all section headings **must be in Traditional Chinese**. Use the template headings as-is — they are already in Chinese. Technical terms (e.g., API, S3, Databricks, IAM) remain in English.

**Mandatory sections to populate (never leave fully blank):**
- 問題陳述 (問題描述、影響對象、時程驅動因素)
- 目標 (主要目標 + 至少一個非目標)
- 使用者故事 (至少 US-001)
- 範疇 → 涵蓋範疇（MVP）at least one item

**Sections that may be `[TBD]` for quick drafts:**
- 成功指標 (targets)
- 待確認事項
- 核准紀錄

Set document metadata:
- **狀態:** 草稿
- **建立日期:** today's date
- **更新日期:** today's date

---

### Phase 4: Save the PRD

Save the PRD to `<project-root>/docs/prd/<feature-slug>-prd.md` automatically — do NOT ask the user for a path.

After saving, tell the user the full file path.

> **Note:** This is a temporary filename. After the ADO Epic is created in Phase 5, the file will be renamed to `<epic-id>-<feature-slug>-prd.md`.

---

### Phase 5: Publish to ADO Epic (Optional)

Ask the user:

> 「PRD 已儲存完成。是否要將這份 PRD 發布至 ADO，建立一個新的 **Epic** 工作項目？（是 / 否）」

**If yes:**

**Step 1 — Check for existing Epics (optional link)**

Ask the user:
> 「是否要連結至現有的 Epic？若有請提供 Epic ID，若要建立全新 Epic 請輸入「新建」。」

**Step 2 — Prepare Epic content**

Map PRD fields to ADO Epic fields:

| ADO Epic Field | 來源 |
|----------------|------|
| `System.Title` | PRD Feature Name |
| `System.Description` | HTML 格式的 PRD 摘要 |
| `System.Tags` | `PRD; {Epic ID}` |
| `Microsoft.VSTS.Common.Priority` | 根據 PRD 的 P1/P2/P3 目標對應 1/2/3 |

**Step 3 — Create or update the Epic via ADO API**

Follow **`_tools/ado-work-items.md`** for authentication, endpoint format, HTML description template, and priority mapping.

**Step 4 — Confirm result and update PRD**

If API returns `200` or `201`:

1. Extract the Epic ID from the response body (`id` field).

2. **Rename the PRD file** — rename from `<feature-slug>-prd.md` to `<epic-id>-<feature-slug>-prd.md`:
   ```
   docs/prd/<feature-slug>-prd.md  →  docs/prd/<epic-id>-<feature-slug>-prd.md
   ```

3. **Update the saved PRD file** — add the Epic ID and URL to the PRD metadata header:

   Find the metadata block at the top of the PRD and add / update:
   ```
   **Epic ID:** {epicId}
   **ADO Epic:** https://dev.azure.com/{ADO_ORG}/{ADO_PROJECT_ID}/_workitems/edit/{epicId}
   ```

4. Confirm to the user:

   > 「✅ Epic 已成功建立，PRD 文件已同步更新並重新命名！
   > 🔗 Epic：https://dev.azure.com/{ADO_ORG}/{ADO_PROJECT_ID}/_workitems/edit/{epicId}
   > 📄 PRD 已更新：`docs/prd/{epic-id}-{feature-slug}-prd.md`」

If API returns an error, show the message and suggest checking `ADO_MCP_AUTH_TOKEN` permissions (requires **Work Items → Read & Write**). Do NOT update the PRD if the Epic creation failed.

**If no:**

Proceed without publishing. Remind the user they can manually create an Epic in ADO and reference the PRD file path.

---

## Examples

### Example 1: Quick PRD from a brief description

User says: "Create a PRD for a user authentication feature"

Actions:
1. Ask: feature name → "user-authentication", confirm problem/goal
2. User provides: "Users need to log in securely with email and password"
3. Default to quick draft; extract personas (end users, admins), goal (secure login), anti-goals (SSO — out of scope for now)
4. Populate template sections, mark unknowns as `[TBD]`
5. Save to `<project-root>/docs/prd/user-authentication-prd.md`

### Example 2: Interactive full PRD

User says: "I need a PRD for an onboarding flow"

Actions:
1. Ask for feature name, Feature ID
2. Walk through problem → goals → personas → user stories one section at a time
3. Ask about success metrics, timeline, risks iteratively
4. Save to `<project-root>/docs/prd/onboarding-flow-prd.md`

---

## File Path Reference

| Variable | Resolution |
|----------|------------|
| `<feature-slug>` | Derived from feature name; kebab-case (e.g., `user-authentication`) |
| PRD initial path | `<project-root>/docs/prd/<feature-slug>-prd.md` (before Epic creation) |
| PRD final path | `<project-root>/docs/prd/<epic-id>-<feature-slug>-prd.md` (after Epic created) |
| PRD template | `<project-root>/_skills/gaia-create-prd/prd-template.md` |
