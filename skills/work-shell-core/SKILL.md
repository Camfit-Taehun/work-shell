---
name: work-shell-core
description: Use this skill when the user mentions session management, work logging, or uses Korean phrases like "안녕", "바이", "기록". This skill handles work session lifecycle, progress tracking, and context management.
version: 1.0.0
---

# Work Shell Core Skill

This skill manages work session lifecycle and logging for productive development workflows.

## Session States

Sessions can be in the following states:
- **inactive**: No active session
- **active**: Session is running, work in progress
- **paused**: Session temporarily suspended

## Session Lifecycle

### Starting a Session (/hello, /안녕)

When starting a session:

1. **Load Previous Context**
   - Check `.work-shell/state.json` for last session info
   - Load `work-shell.md` for project context
   - Check for uncommitted changes from previous session

2. **Initialize New Session**
   - Generate session ID: `YYYY-MM-DD-THHMM`
   - Record start timestamp
   - Capture current git branch

3. **Present Context**
   - Summarize last session if exists
   - List pending todos
   - Show current branch and status
   - Suggest what to work on

### During a Session (/log, /기록)

Quick checkpoints capture:
- Progress updates
- Decisions made
- Important observations
- Context snapshots

Checkpoints are stored in:
- `.work-shell/logs/YYYY-MM-DD.md` (daily log)
- `.work-shell/state.json` (quick_notes array)

### Ending a Session (/bye, /바이)

When ending a session:

1. **Generate Summary**
   - Calculate session duration
   - List commits made
   - Summarize file changes
   - Compile checkpoint notes

2. **Save Session Log**
   - Create `.work-shell/sessions/[session-id].md`
   - Create `.work-shell/sessions/[session-id].json`

3. **Update Project Context**
   - Update `work-shell.md` with session summary
   - Record pending todos for next session

4. **Git Integration** (if enabled)
   - Optionally commit session logs
   - Use conventional commit format

## Data Formats

### state.json Structure

```json
{
  "version": "1.0.0",
  "current_session": {
    "id": "2026-01-07-T1430",
    "started": "2026-01-07T14:30:00Z",
    "status": "active",
    "branch": "main",
    "quick_notes": []
  },
  "last_session": {
    "id": "2026-01-06-T1000",
    "ended": "2026-01-06T12:30:00Z",
    "summary": "Brief summary of work done",
    "branch": "feature/auth"
  },
  "pending_todos": []
}
```

### Session Log Format

Each session log (`.work-shell/sessions/*.md`) contains:
- Session metadata (time, branch, duration)
- Work summary
- Changes made (files, commits)
- Decisions/notes recorded
- Next steps/todos

## Directory Structure

When work-shell is active in a project:

```
project/
├── .work-shell/
│   ├── config.yaml      # Local settings
│   ├── state.json       # Current session state
│   ├── sessions/        # Session logs
│   │   ├── 2026-01-07-T1430.md
│   │   └── 2026-01-07-T1430.json
│   ├── logs/            # Daily checkpoint logs
│   │   └── 2026-01-07.md
│   └── helpers/         # Custom scripts
└── work-shell.md        # Project context (like CLAUDE.md)
```

## Configuration

Settings in `.work-shell/config.yaml`:

```yaml
git:
  auto_commit: false      # Auto-commit on /bye
  commit_prefix: "chore(work-shell):"

session:
  auto_pause_minutes: 30  # Auto-pause after inactivity

logging:
  include_git_status: true
  include_timestamps: true
```

## Best Practices

1. Start each work session with `/hello`
2. Use `/log` frequently to capture decisions
3. End sessions properly with `/bye`
4. Keep `work-shell.md` updated with project context
5. Review pending todos at session start
