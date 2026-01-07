---
description: Show current session status dashboard
allowed-tools: [Read, Bash(git:*), Bash(date:*), Glob]
---

# Status - Session Dashboard

Display a comprehensive status dashboard of the current work session.

## 1. Gather Data

```bash
# Git status
git status --short
git branch --show-current
git log --oneline -3

# Time
date "+%Y-%m-%d %H:%M"

# Changed files count
git diff --stat --shortstat
```

## 2. Read State

- `.work-shell/state.json` - current session info
- `.work-shell/config.yaml` - settings
- `work-shell.md` - current focus

## 3. Calculate Metrics

From current session:
- Session duration (now - started)
- Commands run count
- Commits made
- Files changed

## 4. Output Dashboard

Format as:

```
## Status Dashboard

**세션**: {session_id} | **시작**: {start_time} | **경과**: {duration}

---

### Git
| 항목 | 값 |
|------|-----|
| Branch | `{branch}` |
| 변경 파일 | {N}개 |
| 스테이지 | {N}개 |
| 커밋 (세션) | {N}개 |

### 최근 커밋
```
{git log --oneline -3}
```

### 현재 Focus
> {focus or "설정되지 않음"}

### 미완료 TODO
- [ ] {todo1}
- [ ] {todo2}

### 활성 루틴
- {routine1} (다음 실행: {next_run})
- {routine2}

---

**Tip**: `/focus` 로 집중 작업을 설정하세요.
```
