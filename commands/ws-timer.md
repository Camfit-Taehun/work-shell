---
description: Pomodoro timer for focused work
argument-hint: [start|stop|status] [minutes]
allowed-tools: [Read, Write, Bash(date:*), AskUserQuestion]
---

# Timer - Pomodoro Timer

Manage focused work sessions with timed intervals.

## Parse Arguments

`$ARGUMENTS`:
- Empty or `status` - Show current timer
- `start [minutes]` - Start timer (default: 25 min)
- `stop` - Stop current timer
- `break [minutes]` - Start break timer (default: 5 min)

## 1. Timer State

Store in `.work-shell/state.json`:
```json
{
  "current_session": {
    "timer": {
      "type": "focus|break",
      "started": "{timestamp}",
      "duration_minutes": 25,
      "task": "{current_focus}"
    }
  }
}
```

## 2. Execute

### start
```
## 타이머 시작

**시간**: {minutes}분
**태스크**: {focus or "일반 작업"}
**종료 예정**: {end_time}

---

집중하세요! 완료되면 알려드릴게요.

**Tip**: `/timer stop` 으로 중단, `/log` 로 진행상황 기록
```

### status
```
## 타이머 상태

**진행 중**: {type} 타이머
**남은 시간**: {remaining}분 {seconds}초
**태스크**: {task}

[████████░░░░░░░░] {percent}%
```

### stop
```
## 타이머 중단됨

**경과 시간**: {elapsed}분
**원래 목표**: {target}분

`/log` 로 진행상황을 기록하세요.
```

### Timer completion
When timer ends (checked periodically):
```
## 타이머 완료!

**{type}** 세션 완료: {duration}분

{if focus}
수고하셨습니다! 잠시 휴식하세요.
`/timer break` 로 휴식 타이머를 시작하세요.
{/if}

{if break}
휴식 끝! 다시 집중할 준비가 되셨나요?
`/timer start` 로 다음 세션을 시작하세요.
{/if}
```

User argument: $ARGUMENTS
