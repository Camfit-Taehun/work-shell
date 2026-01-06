---
description: Start work session, load context and show previous work summary
argument-hint: [project-name]
allowed-tools: [Read, Write, Bash(git:*), Bash(date:*), Bash(ls:*), Glob]
---

# Hello - Work Session Start

You are starting a work session. Follow these steps:

## 1. Load Context

First, check for work-shell configuration:
- Read `work-shell.md` if it exists in the current directory
- Read `.work-shell/state.json` if it exists
- Read `.work-shell/config.yaml` if it exists

## 2. Check Environment

Get the current state:
- Run `git status --short` to see uncommitted changes
- Run `git branch --show-current` to get current branch
- Run `git log --oneline -5` to see recent commits

## 3. Session State

If `.work-shell/state.json` exists and has a `last_session`:
- Show summary of last session (what was done, when)
- Show any `pending_todos` from the last session

## 4. Start Session

Create or update `.work-shell/state.json` with:
```json
{
  "current_session": {
    "id": "[YYYY-MM-DD-THHMM format]",
    "started": "[ISO timestamp]",
    "status": "active",
    "branch": "[current git branch]"
  }
}
```

## 5. Greeting

Output a friendly greeting that includes:
- Current date/time
- Current branch and repo status
- Summary of last session (if any)
- Pending todos (if any)
- Ask what the user wants to work on

User argument: $ARGUMENTS
