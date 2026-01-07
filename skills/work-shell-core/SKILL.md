---
name: work-shell-core
description: Use this skill for session management, work logging, todos, commits, and general productivity. Handles Korean phrases like "안녕", "바이", "기록", "상태", "할일".
version: 2.0.0
---

# Work Shell Core Skill v2.0

Complete productivity shell for Claude Code with session management, automation, and pipelines.

## Available Commands

### Core
- `/hello` - Proactive session start with suggestions
- `/bye` - Session end with summary
- `/log` - Quick checkpoint
- `/status` - Dashboard view
- `/todo` - Task management
- `/commit` - Smart git commit
- `/summary` - Work reports

### Context
- `/context` - View/edit work-shell.md
- `/focus` - Set current focus
- `/decision` - Record decisions
- `/note` - Long-form notes

### Git
- `/branch` - Branch management
- `/pr` - Create PRs
- `/review` - Code review checklist
- `/stash` - Smart stash

### Productivity
- `/find` - Search helpers
- `/run` - Execute scripts
- `/timer` - Pomodoro timer
- `/break` - Take breaks

### Team
- `/handoff` - Task handoff docs
- `/share` - Share with team
- `/sync` - Team sync

### Analysis
- `/stats` - Work statistics
- `/retro` - Retrospectives
- `/history` - Search history

### System
- `/routine` - Scheduled tasks
- `/flow` - Command pipelines
- `/fork` - Session branching
- `/config` - Settings

## Session Lifecycle

```
[없음] ─/hello─▶ [active]
                    │
        ┌───────────┼───────────┐
        │           │           │
    /log, /todo   /focus    /break
        │           │           │
        └───────────┼───────────┘
                    │
                  /bye
                    │
                    ▼
              [completed]
```

## State v2.0 Structure

```json
{
  "version": "2.0.0",
  "current_session": {
    "id": "2026-01-07-T0115",
    "started": "2026-01-07T01:15:00+09:00",
    "status": "active",
    "branch": "master",
    "focus": "Current task description",
    "quick_notes": [],
    "timer": null,
    "stats": {
      "commands_run": 0,
      "commits": 0,
      "files_changed": 0
    }
  },
  "last_session": { ... },
  "pending_todos": [],
  "active_routines": [],
  "active_flows": [],
  "forks": []
}
```

## Proactive Behavior

When starting a session (/hello), proactively:
1. Check for unmerged remote commits
2. Show uncommitted local changes
3. Display pending todos
4. Suggest actions based on context
5. Ask user what they want to do

## Directory Structure v2.0

```
project/
├── .work-shell/
│   ├── config.yaml
│   ├── state.json
│   ├── routines.yaml
│   ├── flows.yaml
│   ├── sessions/
│   ├── logs/
│   ├── notes/
│   ├── helpers/
│   ├── forks/
│   ├── retros/
│   ├── handoffs/
│   └── auto-logs/
└── work-shell.md
```

## Best Practices

1. Start with `/hello` - get context and suggestions
2. Set `/focus` for the current task
3. Use `/log` frequently for checkpoints
4. Use `/decision` for important choices
5. End with `/bye` to save everything
6. Use `/routine` for repetitive tasks
7. Use `/flow` for common sequences
