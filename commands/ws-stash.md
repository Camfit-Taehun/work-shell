---
description: Stash changes with context preservation
argument-hint: [save|pop|list|show] [message]
allowed-tools: [Read, Write, Bash(git:*)]
---

# Stash - Smart Git Stash

Stash changes while preserving work-shell context.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty or `save`: Stash current changes
- `save <message>`: Stash with message
- `pop`: Restore latest stash
- `list`: List all stashes
- `show <index>`: Show stash contents

## 1. Execute Command

### save (default)
```bash
git stash push -m "work-shell: {message or auto-generated}"
```

Also save context to `.work-shell/stashes/{timestamp}.json`:
```json
{
  "stash_id": "stash@{0}",
  "timestamp": "{ISO}",
  "message": "{message}",
  "branch": "{branch}",
  "focus": "{current_focus}",
  "files": ["{changed files}"],
  "session_id": "{session_id}"
}
```

Output:
```
## Stash 저장됨

**ID**: stash@{0}
**메시지**: {message}
**파일**: {N}개

### 저장된 컨텍스트
- Branch: `{branch}`
- Focus: {focus}

---

`/stash pop` 으로 복원하세요.
```

### pop
```bash
git stash pop
```

Restore context from `.work-shell/stashes/` if available.

Output:
```
## Stash 복원됨

**메시지**: {message}
**파일**: {N}개 복원

### 복원된 컨텍스트
- 원래 Branch: `{branch}`
- 원래 Focus: {focus}
```

### list
```bash
git stash list
```

Enhance with work-shell context:
```
## Stash 목록

| # | 메시지 | Branch | 시간 |
|---|--------|--------|------|
| 0 | {msg} | {branch} | {time} |
| 1 | {msg} | {branch} | {time} |
```

### show <index>
```bash
git stash show -p stash@{index}
```

User argument: $ARGUMENTS
