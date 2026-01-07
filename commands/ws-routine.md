---
description: Manage scheduled routines and triggers
argument-hint: <add|list|remove|enable|disable> [args]
allowed-tools: [Read, Write, Bash(date:*), AskUserQuestion]
---

# Routine - Scheduled Task Management

Manage routines that run on schedule, events, or conditions.

## Parse Arguments

`$ARGUMENTS` can be:
- `add "<trigger>" <command>` - Add new routine
- `list` - Show all routines
- `remove <id>` - Remove routine
- `enable <id>` - Enable routine
- `disable <id>` - Disable routine

## Trigger Types

### Time-based (cron style)
- `"매일 09:00"` → `"0 9 * * *"`
- `"매주 월요일 10:00"` → `"0 10 * * 1"`
- `"30분마다"` → interval: 30 minutes
- `"1시간마다"` → interval: 60 minutes

### Event-based
- `"on:session-start"` - When /hello runs
- `"on:session-end"` - When /bye runs
- `"on:commit"` - After git commit
- `"on:push"` - After git push
- `"on:pr-create"` - After PR created

### Condition-based
- `"when:files>10"` - When changed files > 10
- `"when:duration>1h"` - When session > 1 hour
- `"when:commits>5"` - When session commits > 5

## 1. Execute Command

### add
Parse trigger and command, add to `.work-shell/routines.yaml`:
```yaml
routines:
  - id: "{generated-id}"
    name: "{auto-generated name}"
    trigger:
      type: cron|interval|event|condition
      # type-specific fields
    command: "{command}"
    enabled: true
    created: "{timestamp}"
```

### list
```
## 등록된 루틴

### 활성 ({N}개)
| ID | 트리거 | 커맨드 | 다음 실행 |
|----|--------|--------|----------|
| morning-status | 매일 09:00 | /status | 내일 09:00 |
| auto-log | 30분마다 | /log 자동 | 12분 후 |

### 비활성 ({N}개)
| ID | 트리거 | 커맨드 |
|----|--------|--------|
| ... | ... | ... |
```

### remove/enable/disable
Update `.work-shell/routines.yaml` accordingly.

## 2. Output

### add
```
## 루틴 추가됨

**ID**: {id}
**트리거**: {trigger_description}
**커맨드**: {command}

다음 실행: {next_run_time}

---

`/routine list` 로 전체 루틴을 확인하세요.
```

User argument: $ARGUMENTS
