---
description: Show work statistics
argument-hint: [today|week|month|all]
allowed-tools: [Read, Bash(git:*), Glob]
---

# Stats - Work Statistics

Show statistics about your work patterns.

## Parse Arguments

`$ARGUMENTS`:
- Empty or `today` - Today's stats
- `week` - This week
- `month` - This month
- `all` - All time

## 1. Gather Data

From git:
```bash
git log --since="{period}" --author="$(git config user.name)" --oneline
git log --since="{period}" --author="$(git config user.name)" --shortstat
```

From work-shell:
- Session logs (`.work-shell/sessions/`)
- Daily logs (`.work-shell/logs/`)
- State history

## 2. Calculate Stats

- Total commits
- Lines added/removed
- Files changed
- Session count
- Average session duration
- Most productive time
- Most changed files
- Streak days

## 3. Output

```
## 작업 통계 ({period})

### 요약
| 항목 | 값 |
|------|-----|
| 커밋 | {commits} |
| 추가된 줄 | +{additions} |
| 삭제된 줄 | -{deletions} |
| 변경 파일 | {files} |
| 세션 수 | {sessions} |
| 총 작업 시간 | {hours}h {minutes}m |

### 생산성 패턴

**가장 생산적인 시간대**
```
06-09: ██░░░░░░░░ 10%
09-12: ████████░░ 40%
12-15: ██████░░░░ 30%
15-18: ████░░░░░░ 20%
18-21: ██░░░░░░░░ 10%
```

**요일별 커밋**
| 월 | 화 | 수 | 목 | 금 | 토 | 일 |
|----|----|----|----|----|----|----|
| 5 | 8 | 12 | 7 | 10 | 2 | 0 |

### 자주 수정한 파일 (Top 5)
1. `src/main.ts` - 15회
2. `src/utils.ts` - 12회
3. `README.md` - 8회

### 연속 작업일
**현재 스트릭**: {streak_days}일 🔥

---

**Tip**: `/retro` 로 회고를 작성하세요.
```

User argument: $ARGUMENTS
