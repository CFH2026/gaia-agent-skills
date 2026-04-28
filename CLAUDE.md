# Claude Code Instructions


## Operating Rules

- Keep user-facing content in English.
- Do not ask for personal or identifying information unless a repo policy requires it.
- Do not launch applications automatically.
- Preserve unrelated user changes.
- Prefer small, targeted edits.

## Repo References

- `README.md` for project overview
- `_skills/<skill-name>/SKILL.md` for skills used while working in this repo
- `gaia-skills/<skill-name>/SKILL.md` for engineer-built skills intended for release
- `gaia-policies/<policy-name>/POLICY.md` for engineer-authored policies served through MCP
- `mcp/gaia-mcp/` for the MCP implementation workspace
- `docs/spec/` for repository and skill specifications

## Skill Authoring

- Put repo-workflow skills in `_skills/<skill-name>/`
- Put release-oriented skills in `gaia-skills/<skill-name>/`
- Put policies in `gaia-policies/<policy-name>/`
- Put MCP implementation code in `mcp/gaia-mcp/`
- Keep primary instructions in `SKILL.md`
- Follow existing markdown and metadata patterns
- Keep examples minimal and consistent with repo policies

## Validation

- Verify edited markdown is well formed
- Verify JSON remains valid
- Confirm any skill change still matches repo policies and docs

## Git Best Practices

### Commits

- Use Conventional Commits: `type(scope): description`
- Allowed types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`
- Do not add AI attribution (no `Co-Authored-By`, no `Generated with Claude`)
- Keep each commit focused on one logical change

### Branch Strategy

- Use `feature/UP-123-short-description`, `bugfix/UP-456-short-description`, or `hotfix/UP-789-short-description`
- Branch `develop` for feature work and PRs
- Use `master` for stable, production-ready code
- Do not attempt to deploy from engineering repos

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
