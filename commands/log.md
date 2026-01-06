---
description: Quick checkpoint - save a progress note or decision
argument-hint: <note>
allowed-tools: [Read, Write, Bash(git:*), Bash(date:*)]
---

# Log - Quick Checkpoint

You are saving a quick checkpoint/note. This is for capturing:
- Progress updates
- Decisions made
- Important observations
- Things to remember

## 1. Get Current State

- Get current timestamp
- Get current git branch
- Get current git status (brief)

## 2. Prepare Log Entry

Create a log entry with:
- Timestamp
- The user's note
- Current context (branch, recent changes)

## 3. Append to Daily Log

Append to `.work-shell/logs/[YYYY-MM-DD].md`:
```markdown
### [HH:MM]

**Branch**: [current branch]

[User's note]

**Context**: [brief git status if relevant]

---
```

Create the file if it doesn't exist, with a header:
```markdown
# Work Log: [YYYY-MM-DD]

---
```

## 4. Update State

If `.work-shell/state.json` exists, add this note to `quick_notes` array in current session.

## 5. Confirmation

Briefly confirm the checkpoint was saved with timestamp.

User note: $ARGUMENTS
