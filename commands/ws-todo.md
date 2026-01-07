---
description: Manage todo items (add/done/list/remove)
argument-hint: <add|done|list|remove> [item]
allowed-tools: [Read, Write, Bash(date:*)]
---

# Todo - Task Management

Manage your pending tasks. Supports: add, done, list, remove

## Parse Arguments

`$ARGUMENTS` can be:
- `add <task>` - Add new todo
- `done <number|text>` - Mark todo as complete
- `list` or empty - Show all todos
- `remove <number|text>` - Remove todo without completing

## 1. Read Current State

Read `.work-shell/state.json` to get `pending_todos` array.

## 2. Execute Command

### add <task>
```json
{
  "pending_todos": [
    ...existing,
    {
      "id": "{generated-id}",
      "text": "{task}",
      "created": "{ISO timestamp}",
      "session": "{current_session_id}"
    }
  ]
}
```

Output: `+ TODO 추가됨: {task}`

### done <number|text>
- If number: mark todo at that index as done
- If text: find matching todo and mark done

Move to completed in session log, remove from pending_todos.

Output: `✓ 완료: {task}`

### list (default)
Output:
```
## TODO 목록

### 미완료 ({N}개)
1. [ ] {task1} (추가: {date})
2. [ ] {task2} (추가: {date})

### 오늘 완료 ({N}개)
1. [x] {completed1}
2. [x] {completed2}
```

### remove <number|text>
Remove todo without marking complete.

Output: `- TODO 삭제됨: {task}`

## 3. Update State

Write updated `pending_todos` back to `.work-shell/state.json`.

Also update `work-shell.md` Progress section if it exists.

User argument: $ARGUMENTS
