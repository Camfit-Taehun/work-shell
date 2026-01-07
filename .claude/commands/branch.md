---
description: Create or switch branches with context update
argument-hint: <branch-name> [--from <base>]
allowed-tools: [Read, Write, Bash(git:*), AskUserQuestion]
---

# Branch - Git Branch Management

Create or switch branches while maintaining work-shell context.

## Parse Arguments

`$ARGUMENTS` can be:
- `<name>`: Switch to or create branch
- `<name> --from <base>`: Create from specific base
- Empty: Show current branch and recent branches

## 1. Check Current State

```bash
git branch --show-current
git branch --list -v
git status --short
```

## 2. Execute

### Show branches (no args)
```
## Git Branches

**현재**: `{current_branch}`

### 최근 브랜치
- `main` (2일 전)
- `feature/auth` (어제)
- `fix/bug-123` (3시간 전)

### 변경사항
{uncommitted changes warning if any}
```

### Switch/Create branch
1. Check for uncommitted changes
2. If changes exist, ask user:
   - Stash changes?
   - Commit first?
   - Discard changes?

3. Switch or create:
   ```bash
   git checkout <branch>  # or
   git checkout -b <branch> [base]
   ```

4. Update context:
   - `.work-shell/state.json`: Update branch field
   - Add log entry about branch switch

## 3. Output

```
## Branch 전환됨

`{old_branch}` → `{new_branch}`

{created new branch / switched to existing}

### 세션 상태
- 현재 Focus: {focus}
- 미커밋 변경: {N}개 파일

---

**Tip**: `/stash` 로 변경사항을 임시 저장할 수 있습니다.
```

User argument: $ARGUMENTS
