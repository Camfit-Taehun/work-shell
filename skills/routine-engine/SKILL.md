---
name: routine-engine
description: Handles scheduled routines, triggers, and automated tasks. Use when user mentions "루틴", "자동", "매일", "매주", "트리거".
version: 1.0.0
---

# Routine Engine Skill

Manages scheduled and triggered automated tasks.

## Trigger Types

### Time-based (Cron)
```yaml
trigger:
  type: cron
  schedule: "0 9 * * *"  # 매일 09:00
```

Natural language mapping:
- "매일 09:00" → `0 9 * * *`
- "매주 월요일 10:00" → `0 10 * * 1`
- "매월 1일" → `0 0 1 * *`

### Interval-based
```yaml
trigger:
  type: interval
  minutes: 30
```

- "30분마다" → interval: 30
- "1시간마다" → interval: 60
- "2시간마다" → interval: 120

### Event-based
```yaml
trigger:
  type: event
  event: session-start
```

Available events:
- `session-start` - When /hello runs
- `session-end` - When /bye runs
- `post-commit` - After git commit
- `post-push` - After git push
- `pr-create` - After PR created
- `pre-compact` - Before context compaction

### Condition-based
```yaml
trigger:
  type: condition
  condition: "files_changed > 10"
```

Available conditions:
- `files_changed > N` - Changed files count
- `session_duration > Nh` - Session longer than N hours
- `commits > N` - Session commits exceed N
- `time_since_log > Nm` - Minutes since last /log

## Routine Definition

```yaml
routines:
  - id: unique-id
    name: "Display Name"
    description: "What this routine does"
    trigger:
      type: cron|interval|event|condition
      # type-specific fields
    command: "/status"  # or pipeline
    enabled: true
    created: "2026-01-07T01:00:00Z"
    last_run: null
    next_run: "2026-01-07T09:00:00Z"
```

## Routine Commands

- `/routine add "<trigger>" <command>` - Add routine
- `/routine list` - List all routines
- `/routine remove <id>` - Remove routine
- `/routine enable <id>` - Enable routine
- `/routine disable <id>` - Disable routine
- `/routine run <id>` - Run routine manually

## Execution

Routines are checked and executed by hooks:
1. On session start (SessionStart hook)
2. After commands (post-command check)
3. Periodically during session

When a routine triggers:
1. Log the execution
2. Run the command
3. Update last_run
4. Calculate next_run (for cron/interval)
