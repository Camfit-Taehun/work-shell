---
description: End work session, save progress and create session log
argument-hint: [summary-note]
allowed-tools: [Read, Write, Bash(git:*), Bash(date:*), Glob, AskUserQuestion]
---

# Bye - Work Session End

You are ending a work session. Follow these steps:

## 1. Gather Session Info

Collect information about this session:
- Read `.work-shell/state.json` to get session start time
- Run `git log --oneline` since session start
- Run `git diff --stat` to see what changed
- Run `git status --short` for uncommitted changes

## 2. Generate Session Summary

Create a summary including:
- Session duration (start to now)
- Commits made during session
- Files changed
- Key decisions or notes (from /log entries if any)

## 3. Save Session Log

Create session log file at `.work-shell/sessions/[session-id].md`:
```markdown
# Session: [YYYY-MM-DD HH:MM]

**Branch**: [branch name]
**Duration**: [calculated duration]
**Status**: completed

## Summary
[Generated summary of work done]

## Changes
[List of changed files]

## Commits
[List of commits during session]

## Notes
[Any /log entries from this session]

## Next
[Pending todos or suggested next steps]
```

## 4. Update State

Update `.work-shell/state.json`:
- Move `current_session` to `last_session`
- Set `current_session` to null
- Update `pending_todos` if user mentioned any

## 5. Update work-shell.md

If `work-shell.md` exists, update the "Session History" section with this session's summary.

## 6. Git Commit (Optional)

Check `.work-shell/config.yaml` for `git.auto_commit` setting.
If enabled, ask user if they want to commit the session logs.

## 7. Farewell

Output a friendly farewell that includes:
- Session summary
- What was saved
- Pending todos for next time
- Encouraging message

User note: $ARGUMENTS
