# Session Lifecycle Reference

## State Transitions

```
[No Session] ─── /hello ───> [Active]
                                │
                ┌───────────────┼───────────────┐
                │               │               │
            /log (checkpoint)   │          (30min idle)
                │               │               │
                └───────────────┼───────────────┘
                                │
                            /bye
                                │
                                v
                          [Completed] ───> [No Session]
```

## Command Flow

### /hello Flow

```
1. Check for .work-shell/state.json
   ├── Exists with last_session?
   │   └── Show last session summary
   └── No previous session?
       └── Welcome new user

2. Check git status
   ├── Uncommitted changes?
   │   └── Warn about pending changes
   └── Clean working tree
       └── Continue

3. Create new session
   ├── Generate session ID
   ├── Record start time
   ├── Capture branch name
   └── Update state.json

4. Output greeting
   ├── Current status
   ├── Pending todos
   └── Ask what to work on
```

### /log Flow

```
1. Capture current state
   ├── Timestamp
   ├── Git branch
   └── Brief status

2. Format log entry
   └── User's note + context

3. Append to daily log
   └── .work-shell/logs/YYYY-MM-DD.md

4. Update session state
   └── Add to quick_notes array

5. Confirm checkpoint saved
```

### /bye Flow

```
1. Calculate session duration
   └── Now - session.started

2. Gather session data
   ├── Commits since start
   ├── Files changed
   └── Checkpoint notes

3. Generate summary
   └── Structured session report

4. Save session log
   ├── .work-shell/sessions/[id].md
   └── .work-shell/sessions/[id].json

5. Update state
   ├── Move current → last_session
   ├── Clear current_session
   └── Save pending_todos

6. Update work-shell.md
   └── Add to Session History

7. Optional: Git commit
   └── If config.git.auto_commit

8. Output farewell
   ├── Session summary
   ├── Saved files
   └── Next todos
```

## Data Examples

### Session Start State

```json
{
  "version": "1.0.0",
  "current_session": {
    "id": "2026-01-07-T1430",
    "started": "2026-01-07T14:30:00Z",
    "status": "active",
    "branch": "feature/new-feature",
    "quick_notes": []
  },
  "last_session": null,
  "pending_todos": []
}
```

### After Checkpoint

```json
{
  "version": "1.0.0",
  "current_session": {
    "id": "2026-01-07-T1430",
    "started": "2026-01-07T14:30:00Z",
    "status": "active",
    "branch": "feature/new-feature",
    "quick_notes": [
      {
        "time": "2026-01-07T15:00:00Z",
        "note": "Decided to use JWT for auth"
      }
    ]
  },
  "last_session": null,
  "pending_todos": []
}
```

### After Session End

```json
{
  "version": "1.0.0",
  "current_session": null,
  "last_session": {
    "id": "2026-01-07-T1430",
    "ended": "2026-01-07T17:00:00Z",
    "summary": "Implemented JWT authentication",
    "branch": "feature/new-feature",
    "commits": 5,
    "files_changed": 8
  },
  "pending_todos": [
    "Add unit tests",
    "Update API docs"
  ]
}
```
