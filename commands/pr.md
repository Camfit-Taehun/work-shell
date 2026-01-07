---
description: Create PR with session-based description
argument-hint: [--title <title>] [--base <branch>]
allowed-tools: [Read, Bash(git:*), Bash(gh:*), AskUserQuestion]
---

# PR - Create Pull Request

Create a GitHub Pull Request with auto-generated description based on session logs.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: Auto-generate title and description
- `--title <title>`: Use specific title
- `--base <branch>`: Target base branch (default: main)

## 1. Gather PR Data

```bash
# Current branch
git branch --show-current

# Commits in this branch (not in base)
git log main..HEAD --oneline

# Changed files
git diff main..HEAD --stat

# Check if remote branch exists
git ls-remote --heads origin $(git branch --show-current)
```

## 2. Generate PR Content

### Title
- From branch name: `feature/user-auth` → "feat: User auth"
- Or from recent commits
- Or from session focus

### Description
Build from:
- Session logs (`.work-shell/sessions/*.md`)
- Daily logs (`.work-shell/logs/{date}.md`)
- Decisions made
- Commits list

Template:
```markdown
## Summary
{Generated from session focus and logs}

## Changes
{List of commits}

## Decisions
{Any decisions recorded during development}

## Test Plan
- [ ] {Suggested test items}

---
🤖 Generated with work-shell
```

## 3. Confirm with User

Use AskUserQuestion to confirm:
- Title
- Description preview
- Base branch
- Draft or ready

## 4. Create PR

```bash
# Push branch if needed
git push -u origin $(git branch --show-current)

# Create PR
gh pr create --title "{title}" --body "{description}" --base {base}
```

## 5. Output

```
## PR 생성됨

**#{pr_number}**: {title}

**URL**: {pr_url}

### 요약
{description_preview}

### 다음 단계
- [ ] 리뷰어 지정
- [ ] CI 통과 확인
- [ ] 머지

---

**Tip**: `/review` 로 변경사항 체크리스트를 생성하세요.
```

User argument: $ARGUMENTS
