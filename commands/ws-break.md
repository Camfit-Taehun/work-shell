---
description: Take a break, pause session
argument-hint: [minutes]
allowed-tools: [Read, Write, Bash(date:*)]
---

# Break - Session Pause

Take a break while preserving session context.

## Parse Arguments

`$ARGUMENTS`:
- Empty - Start break (suggested duration based on work time)
- `<minutes>` - Break for specific duration

## 1. Calculate Suggested Break

Based on continuous work time:
- < 30 min work → 5 min break
- 30-60 min work → 10 min break
- 60-90 min work → 15 min break
- > 90 min work → 20 min break (+ stretch suggestion)

## 2. Save Session State

Update `.work-shell/state.json`:
```json
{
  "current_session": {
    "status": "paused",
    "paused_at": "{timestamp}",
    "break_duration": {minutes},
    "stats_at_pause": { /* current stats */ }
  }
}
```

## 3. Output

```
## 휴식 시작

**작업 시간**: {work_duration}
**휴식 시간**: {break_minutes}분
**복귀 예정**: {return_time}

---

### 휴식 추천
- 🧘 스트레칭 하기
- 👀 먼 곳 바라보기 (눈 휴식)
- 🚶 잠깐 걷기
- 💧 물 마시기

---

휴식이 끝나면 `/hello` 로 돌아오세요.
세션 상태가 보존되어 있습니다.

{if work > 90min}
⚠️ 90분 이상 작업하셨어요. 충분히 쉬세요!
{/if}
```

## 4. Log Break

Add to daily log:
```markdown
### {HH:MM} - 휴식 시작

**작업 시간**: {duration}
**휴식 예정**: {break_minutes}분
```

User argument: $ARGUMENTS
