---
description: Smart commit with auto-generated message
argument-hint: [-m message] [files...]
allowed-tools: [Read, Bash(git:*), AskUserQuestion]
---

# Commit - Smart Git Commit

Analyze changes and generate appropriate commit message.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: analyze all changes, generate message
- `-m "message"`: use provided message
- `file1 file2`: commit specific files only

## 1. Gather Changes

```bash
# Staged changes
git diff --cached --stat
git diff --cached --name-only

# Unstaged changes (if no staged)
git diff --stat
git diff --name-only

# Untracked files
git ls-files --others --exclude-standard
```

## 2. Analyze Changes

For each changed file, determine:
- Type of change (new, modified, deleted, renamed)
- Category (feat, fix, refactor, docs, test, chore, style)
- Scope (component/module affected)

Read file diffs to understand what changed:
```bash
git diff --cached -p  # or git diff -p for unstaged
```

## 3. Generate Commit Message

Follow conventional commits format:
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types:
- feat: new feature
- fix: bug fix
- refactor: code change without feature/fix
- docs: documentation only
- test: adding/fixing tests
- chore: maintenance tasks
- style: formatting, no code change

## 4. Confirm with User

Use AskUserQuestion to confirm:
- Show generated message
- Option to edit
- Option to select files to stage

## 5. Execute Commit

```bash
# Stage files if needed
git add <files>

# Commit with message
git commit -m "<message>"
```

## 6. Update Session Stats

Update `.work-shell/state.json`:
- Increment `stats.commits`
- Update `stats.files_changed`

## 7. Output Result

```
## 커밋 완료

**{commit_hash}** `{type}({scope}): {description}`

### 변경 사항
- {file1}: +{additions} -{deletions}
- {file2}: +{additions} -{deletions}

### 세션 통계
- 이번 세션 커밋: {N}개
- 변경 파일 누적: {N}개
```

User argument: $ARGUMENTS
