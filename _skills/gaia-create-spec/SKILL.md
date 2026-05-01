---
name: gaia-create-spec
description: Creates a Technical Specification document for a platform, solution, or infrastructure component. Can be created from an existing PRD or standalone. Guides the writer through structured conversation covering architecture, detailed design, infrastructure, and key considerations. Triggers on: "create a spec", "write a spec", "create technical spec", "write technical specification", "spec for", "I need a spec", "/gaia-create-spec". Do NOT use for PRDs (use gaia-create-prd), incident reports (use gaia-create-incident-report), or general documentation tasks.
license: CC-BY-4.0
metadata:
  author: Carlson
  version: 1.1.0
---

# Create Technical Specification

Guides a technical writer, engineer, or TPM through creating a Technical Specification document. The Spec defines **how** to implement something — with concrete architecture, API design, infrastructure details, and implementation considerations — complementing the PRD which defines **what** to build and why.

**Primary audience:** Technical Manager, Product Owner, Engineers from other relevant teams.

> `<project-root>` refers to the root directory of the repository this skill is installed in (i.e., the directory containing `.claude/`).

---

## Instructions

### Phase 0: Study Project Context via ADO API

Before asking any questions, fetch live project context directly from ADO. Follow **`_tools/ado-code-repo.md`** for authentication, endpoint format, and error handling.

Fetch the file tree and key files for both repos:
- `lambda-aws-gaia-api-logic`
- `terraform-aws-gaia-api-infra`

Priority files to fetch: `/README.md`, `/serverless-prod.yml`, `/main.tf`, and key handlers under `src/`.

**Use this context to:**
- Pre-fill or suggest technical details grounded in the actual codebase
- Ask more informed follow-up questions about architecture and infrastructure
- Ensure the Spec reflects the real system, not generic assumptions

---

### Phase 1: Check for Existing PRD

Ask the writer:

> 「這份 Spec 是否有關聯的 PRD？
> - **有** — 請提供 PRD 檔案路徑或 Epic ID，我會自動讀取並提取相關內容
> - **沒有** — 我會直接引導你填寫背景與目標」

**If PRD exists:**
- Read the PRD file
- Extract: feature name, Epic ID, goals, non-goals, user stories, NFRs, constraints, open questions
- Pre-fill relevant Spec sections using PRD content
- Tell the writer what was extracted and what still needs to be filled
- **Build a PRD Alignment Tracking Map** (used throughout Phase 5 and Phase 5.5):

  | PRD Item | Type | Mapped Spec Section | Status |
  |----------|------|---------------------|--------|
  | [User Story / NFR / Constraint] | User Story / NFR / Constraint / Goal / Non-Goal | [Section name] | Pending |

  Create one row per user story, NFR, constraint, and explicit non-goal. Mark status as **Pending** initially; update to **Covered**, **Out of Scope (PRD Non-Goal)**, or **⚠️ Unaddressed** as the Spec is drafted.

**If no PRD:**
- Proceed to Phase 2 directly
- Note in the Spec that no PRD exists; the writer is responsible for defining scope boundaries manually

---

### Phase 2: Gather Core Information

Show the writer the full list of questions upfront:

---
Here are the questions I'll ask — one at a time:

1. What is the component / feature name for this Spec?
2. What is the Spec ID or related Epic / Story ID? (leave blank if unknown)
3. What is the technical problem this Spec solves? (if not from PRD)
4. What is the chosen technical approach / direction?
5. What AWS services or components are involved?
6. Who is the Tech Lead reviewing this Spec?
7. What is the target delivery timeline?

Let's start with question 1.

---

Ask each question **one at a time**, waiting for the response before moving on. Skip questions already answered by the PRD.

Do NOT start drafting until items 1, 4, and 5 are confirmed.

---

### Phase 3: Clarify Depth

Ask the writer:

> 「請選擇草稿深度：
> - **Quick draft** — 填入已知內容，其餘標記 `[TBD]`，適合早期設計討論
> - **Full draft** — 逐節互動填寫，適合準備送審的完整 Spec
>
> 若未指定，預設為 **Quick draft**。」

---

### Phase 4: Handle Considerations

#### Step 1 — Mandatory items (always required)

Automatically include all 4 mandatory consideration sections:
1. **Scalability（可擴展性）**
2. **Reliability / Availability（可靠性）**
3. **Security（資安）**
4. **Observability（可觀測性）**

For **Full draft**: ask the writer to provide content for each one by one.
For **Quick draft**: pre-fill with `[TBD]` placeholders and note they must be completed before the Spec is approved.

#### Step 2 — Optional items (ask the writer)

Present the following list and ask which are relevant:

> 「以下項目為選填。請告訴我哪些與本 Spec 相關，不適用的請說明原因（將標記為 N/A）：
>
> 5. Disaster Recovery（災難復原）
> 6. Cost（成本）
> 7. Testability（可測試性）
> 8. Maintainability（可維護性）
> 9. Compliance / Governance（合規）
> 10. Migration（遷移）
>
> 請輸入相關的項目編號（例如：5, 7, 9），或輸入「全部跳過」。」

For selected items: include full section in Spec.
For skipped items: include section header with `**N/A — 原因：** [writer's reason]`.

---

### Phase 5: Draft the Spec

Using the template at `spec-template.md` (read it now), populate each section with gathered information.

**Language rule:** All section headings and content must be in **Traditional Chinese**. Technical terms (e.g., Lambda, DynamoDB, Terraform, IAM, API Gateway) remain in English. The document title (H1) must be in Traditional Chinese.

**Mermaid diagram is mandatory.** If the writer has not provided architecture details sufficient to draw a diagram:
- Ask: 「請描述系統元件之間的主要資料流或呼叫關係，我會幫你繪製架構圖。」
- Generate a best-effort Mermaid diagram based on the information gathered, and note it should be reviewed by the Tech Lead.
- **Color rule:** Do NOT apply any colors to nodes, edges, or other diagram elements. Use default styling only.

**Scope guard — apply continuously while drafting:**
- For every design decision, component, API, or data field introduced, ask: **"Does this map to a requirement, user story, or NFR in the PRD?"**
  - If yes → update the PRD Alignment Tracking Map row to **Covered**
  - If no PRD exists → note the design decision's justification in the relevant section
  - If it maps to a PRD **Non-Goal** → flag it immediately with: `> ⚠️ **範圍警告：** 此設計對應 PRD 非目標「[non-goal text]」，請確認是否需要更新 PRD 或移除此設計。`
  - If there is no PRD mapping and no clear justification → flag it with: `> ⚠️ **範圍警告：** 此設計項目無對應 PRD 需求，可能超出本次交付範圍。請確認是否需要補充至 PRD 或移除。`

**Mandatory sections — never leave fully blank:**
- Executive Summary
- 系統架構（含 Mermaid 圖）
- 詳細設計（至少元件設計）
- 基礎設施與部署（至少 AWS 資源清單）
- 全部 4 個必填 Consideration 項目（Quick draft 可 TBD，Full draft 須完整）

**Sections that may be `[TBD]` for quick drafts:**
- API / Interface 規格
- 資料模型
- 測試策略細節
- 開放問題

**Appendix:**
- Always include Section A（業界最佳實踐參考）with all 13 standard links from the template — do NOT omit or modify these links
- For Section B（本 Spec 專屬參考資料）: ask the writer if they have specific references to add, or leave the placeholder row

Set document metadata:
- **狀態:** 草稿（Draft）
- **建立日期:** today's date
- **更新日期:** today's date
- **Spec ID:** `SPEC-[YYYYMMDD]-[3-digit sequence]` (e.g., `SPEC-20260331-001`)

---

### Phase 5.5: PRD Alignment Review (mandatory when PRD exists)

**Run this review after the full draft is complete, before saving.**

This is a non-negotiable gate. Do not skip it even for quick drafts.

#### Step 1 — Coverage check

Review the PRD Alignment Tracking Map built in Phase 1. For each row still marked **Pending** or **⚠️ Unaddressed**:

> 「PRD 中有以下需求尚未在 Spec 中明確處理：
>
> | PRD Item | Type | 狀態 |
> |----------|------|------|
> | [item] | [type] | ⚠️ 未處理 |
>
> 請問這些項目是：
> A. 確實需要補充至 Spec（請告訴我放在哪一節）
> B. 刻意延後到後續 Spec（請說明原因，我會記錄為開放問題）
> C. 已在 Spec 其他位置涵蓋（請告訴我在哪裡）」

Do not proceed to Phase 6 until every PRD item is either **Covered**, assigned to an open question, or explicitly deferred with justification.

#### Step 2 — Scope creep check

Scan every section of the drafted Spec for any design, component, API endpoint, data field, or feature that has no corresponding PRD requirement, user story, or NFR.

For each item found, present to the writer:

> 「以下設計項目在 PRD 中找不到對應需求，可能屬於超出範圍的設計：
>
> | 項目 | 所在章節 | 建議處理方式 |
> |------|----------|-------------|
> | [item] | [section] | 移除 / 補充至 PRD / 保留並記錄原因 |
>
> 請確認每項的處理方式。」

#### Step 3 — Alignment summary section

After resolving all items, append a **PRD 對齊摘要** section to the Spec (before the 開放問題 section):

```markdown
## PRD 對齊摘要

> 本節記錄此 Spec 與關聯 PRD 的對齊驗證結果。

**關聯 PRD：** [PRD 標題 + 路徑]
**驗證日期：** [YYYY-MM-DD]

### 需求覆蓋狀態

| PRD 需求 | 類型 | Spec 對應章節 | 狀態 |
|----------|------|--------------|------|
| [item] | User Story / NFR / Constraint | [section] | ✅ 已覆蓋 / ⏳ 延後 / ❌ 超出範圍 |

### 範圍差異說明

[列出任何有意的範圍差異，例如刻意延後的需求、因技術限制排除的項目，及其原因]
```

---

### Phase 6: Save the Spec

> Only proceed here after Phase 5.5 PRD Alignment Review is complete (or after confirming no PRD exists).

Save the Spec to `<project-root>/docs/spec/<spec-id>-<feature-slug>-spec.md` automatically — do NOT ask the user for a path.

**Naming convention:**
- `<spec-id>` — derived from metadata (e.g., `SPEC-20260331-001`)
- `<feature-slug>` — kebab-case from feature name (e.g., `modelhub-openai-integration`)
- Full example: `docs/spec/SPEC-20260331-001-modelhub-openai-integration-spec.md`

After saving, tell the user the full file path.

---

### Phase 7: Publish to ADO Wiki (Optional)

Ask the user:

> 「Spec 已儲存完成。是否要將這份 Spec 發布至 **ADO Wiki**？（是 / 否）」

**If yes:**
Follow **`_tools/ado-wiki.md`** for authentication and page creation.
- Parent page: `GAIA Team / Technical Specs`
- Page title: `[Spec ID] [Feature Name] — 技術規格`
- Follow the external write confirmation rule before executing.

**If no:**
Proceed without publishing. Remind the user they can publish later by running `/gaia-create-spec` and referencing the saved file.

---

## File Path Reference

| Variable | Resolution |
|----------|------------|
| `<spec-id>` | `SPEC-[YYYYMMDD]-[001]` |
| `<feature-slug>` | kebab-case from feature name |
| Spec path | `<project-root>/docs/spec/<spec-id>-<feature-slug>-spec.md` |
| Spec template | `<project-root>/.claude/skills/gaia-create-spec/spec-template.md` |

---

## Examples

### Example 1: Spec from existing PRD

User says: "Create a spec for PRD 118068"

Actions:
1. Read `docs/prd/118068-gaia-modelhub-openai-integration-prd-zh.md`
2. Extract feature name, goals, NFRs, constraints; build PRD Alignment Tracking Map
3. Ask remaining questions (Tech Lead, technical approach)
4. Ask about optional considerations
5. Draft Spec with Mermaid diagram pre-populated from PRD architecture; apply scope guard per-section
6. Run Phase 5.5 PRD Alignment Review — confirm all user stories covered, no out-of-scope designs
7. Append PRD 對齊摘要 section to Spec
8. Save to `docs/spec/SPEC-20260331-001-modelhub-openai-integration-spec.md`

### Example 2: Spec without PRD

User says: "I need a spec for our new Terraform module for VPC setup"

Actions:
1. No PRD — gather all info from scratch
2. Ask 7 core questions one at a time
3. Present optional considerations, ask writer to select
4. Generate Mermaid diagram based on described components
5. Save to `docs/spec/SPEC-20260331-001-vpc-terraform-module-spec.md`
