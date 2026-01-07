---
description: Generate work summary report (today/week/session)
argument-hint: [today|week|session]
allowed-tools: [Read, Bash(git:*), Bash(date:*), Glob]
---

# Summary - Work Report

Generate a summary of work done. Default: today's summary.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty or `today`: today's work summary
- `week`: this week's summary
- `session`: current session summary

## 1. Gather Data

### For Today
```bash
# Today's commits
git log --since="today 00:00" --oneline --author="$(git config user.name)"

# Today's changed files
git log --since="today 00:00" --name-only --pretty=format: --author="$(git config user.name)" | sort -u

# Today's stats
git log --since="today 00:00" --shortstat --author="$(git config user.name)"
```

### For Week
```bash
# This week's commits
git log --since="last monday" --oneline --author="$(git config user.name)"
```

### For Session
Read from `.work-shell/state.json` current_session stats.

## 2. Read Logs

- `.work-shell/logs/{date}.md` - checkpoint logs
- `.work-shell/sessions/*.md` - session logs

## 3. Generate Report

### Today's Summary
```
## 오늘의 작업 요약

**{날짜}** | 작업 시간: {총 시간}

---

### 커밋 ({N}개)
- `{hash}` {message}
- `{hash}` {message}

### 변경 파일 ({N}개)
- {file1}
- {file2}

### 기록된 메모
- {time}: {note1}
- {time}: {note2}

### 통계
| 항목 | 값 |
|------|-----|
| 커밋 | {N}개 |
| 추가된 줄 | +{N} |
| 삭제된 줄 | -{N} |
| 파일 변경 | {N}개 |

### 미완료 작업
- [ ] {todo1}
- [ ] {todo2}
```

### Week's Summary
```
## 이번 주 작업 요약

**{시작일} ~ {종료일}**

---

### 일별 커밋
| 요일 | 커밋 수 |
|------|---------|
| 월 | {N} |
| 화 | {N} |
...

### 주요 작업
- {major_work_1}
- {major_work_2}

### 총 통계
- 커밋: {N}개
- 추가: +{N}줄
- 삭제: -{N}줄
```

User argument: $ARGUMENTS
