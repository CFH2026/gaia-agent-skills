# Repository Instructions

## Source Of Truth

- Read `.codex/config.json` before taking action.
- Use that file as the canonical runtime config for this repo.
- Current settings:
  - `model`: `gpt-5`
  - `approval_mode`: `suggest`

## Operating Rules

- Keep user-facing content in English.
- Do not ask for personal or identifying information unless a repo policy requires it.
- Do not launch applications automatically.
- Preserve unrelated user changes.
- Prefer small, targeted edits.

## Repo References

- `README.md` for project overview
- `_skills/<skill-name>/SKILL.md` for skill behavior
- `docs/spec/` for repository and skill specifications
- `gaia-policies/` for language, privacy, and launch constraints
- `gaia-skills/` custom skils to be released


## Skill Authoring

- Put each skill in its own directory under `_skills/`.
- Keep primary instructions in `SKILL.md`.
- Follow the existing markdown and metadata patterns in the repo.
- Keep examples minimal and consistent with repo policies.

## Validation

- Verify edited markdown is well formed.
- Verify JSON remains valid.
- Confirm any skill change still matches the repo policies and docs.

## Git Best Practices


### Git Commits

- Use Conventional Commits: `type(scope): description`
- Allowed types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`
- Do not add AI attribution such as `Co-Authored-By: Claude` or `Generated with Claude Code`
- Keep each commit focused on one logical change

### Branch Strategy

- Use `feature/UP-123-short-description`, `bugfix/UP-456-short-description`, or `hotfix/UP-789-short-description`
- Branch `develop` for feature work and PRs
- Use `master` for stable, production-ready code
- Do not attempt to deploy to UT, UAT, or Production from engineering repos

### Before `git push`

- Verify you are in the repository root
- Run the full test suite and fix failures before pushing
- If push fails due to remote divergence, stop and ask the user before taking further action

### Pull Request & Code Review

Review focus areas:
- Code quality: single responsibility, no duplicates, clear naming
- Architecture: package boundaries, event sourcing patterns
- Security: input validation, authorization checks, no hardcoded secrets
- Performance: no N+1 queries, proper memoization

Severity levels:
- Blocker: must fix before merge
- Major: should fix or defer with justification
- Minor: nice to have; author's discretion
- Nitpick: style preference; optional

### Bug Fixes

- Investigate the full dependency chain before declaring a fix complete
- Run the full affected test suite after each fix
- Do not close a bug until the cascade is fully traced and resolved
