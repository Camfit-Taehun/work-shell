---
name: fork-manager
description: Handles session branching and parallel exploration. Use when user mentions "포크", "브랜치 세션", "병렬 탐색", "컨텍스트 보존".
version: 1.0.0
---

# Fork Manager Skill

Manages session branching for parallel work exploration.

## Use Cases

1. **Parallel Exploration**: Try multiple approaches simultaneously
2. **Long Task Separation**: Run time-consuming tasks in separate session
3. **Context Preservation**: Save current state before risky changes

## Fork Commands

- `/fork <name>` - Create fork with name
- `/fork list` - List all forks
- `/fork switch <name>` - Switch to fork
- `/fork merge <name>` - Merge fork results
- `/fork delete <name>` - Delete fork

## Fork State

Stored in `.work-shell/forks/<name>.json`:
```json
{
  "id": "feature-exploration",
  "created": "2026-01-07T01:00:00Z",
  "parent_session": "2026-01-07-T0115",
  "branch": "master",
  "focus": "Current focus at fork time",
  "working_directory": "/path/to/project",
  "state_snapshot": {
    "version": "2.0.0",
    "current_session": { ... },
    "pending_todos": [ ... ]
  },
  "status": "active",
  "notes": []
}
```

## Creating a Fork

1. Save current session state
2. Create fork record
3. Open new terminal with Claude
4. New session loads fork context

### macOS Implementation
```bash
# Terminal.app
osascript -e 'tell app "Terminal" to do script "cd /path && claude"'

# iTerm2
osascript -e 'tell application "iTerm2" to create window with default profile command "cd /path && claude"'
```

## Fork Detection

When `/hello` runs, check:
1. Is there a pending fork to load?
2. If yes, show fork indicator
3. Load fork context instead of main

## Merging Forks

When merging:
1. Read fork's session logs
2. Extract decisions and notes
3. Import to main session
4. Optionally cherry-pick git commits
5. Mark fork as merged

## Fork Lifecycle

```
[Main Session]
      │
   /fork "experiment"
      │
      ├──────────────────┐
      │                  │
 [Main continues]   [Fork session]
      │                  │
      │              (work...)
      │                  │
      │            /fork merge
      │                  │
      ◄──────────────────┘
      │
 [Results merged]
```

## Best Practices

1. Use descriptive fork names
2. Keep forks focused on single task
3. Merge or delete forks promptly
4. Document fork purpose in notes
