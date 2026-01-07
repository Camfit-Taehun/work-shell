---
description: Set or show current focus task
argument-hint: [task description]
allowed-tools: [Read, Write, Edit, Bash(date:*)]
---

# Focus - Set Current Focus

Set or display the current focus task for this session.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: Show current focus
- `<task>`: Set new focus

## 1. Read Current State

- `.work-shell/state.json` - current session
- `work-shell.md` - Current Focus section

## 2. Execute

### Show Focus (no args)
```
## 현재 Focus

> {current_focus or "설정되지 않음"}

**설정 시간**: {time}
**경과**: {duration}

---

**Tip**: `/focus <task>` 로 집중 작업을 설정하세요.
```

### Set Focus (with args)
1. Update `.work-shell/state.json`:
   ```json
   {
     "current_session": {
       "focus": "{task}",
       "focus_started": "{ISO timestamp}"
     }
   }
   ```

2. Update `work-shell.md` Current Focus section:
   ```markdown
   ## Current Focus

   - {task} (설정: {date})
   ```

3. Add to log:
   Append to `.work-shell/logs/{date}.md`:
   ```markdown
   ### {HH:MM} - Focus 변경

   > {task}
   ```

## 3. Output

```
## Focus 설정됨

> {task}

**시작**: {time}

이제 이 작업에 집중하세요. `/log` 로 진행상황을 기록하세요.
```

User argument: $ARGUMENTS
