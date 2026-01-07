---
description: Start work session, load context and show previous work summary (project)
argument-hint: [project-name]
allowed-tools: [Read, Write, Bash(git:*), Bash(date:*), Bash(ls:*), Bash(gh:*), Glob, AskUserQuestion]
---

# Hello - Proactive Work Session Start

You are starting a work session. Be PROACTIVE - analyze the situation and make suggestions.

## 1. Environment Check

Run these commands to gather context:
```bash
# Fetch latest from remote
git fetch origin 2>/dev/null

# Check for unmerged commits from origin
git rev-list HEAD..origin/$(git branch --show-current) --count 2>/dev/null || echo "0"

# Current branch and status
git branch --show-current
git status --short

# Recent commits
git log --oneline -5
```

## 2. Load Context

Read these files if they exist:
- `work-shell.md` - project context
- `.work-shell/state.json` - session state
- `.work-shell/config.yaml` - settings
- `.work-shell/routines.yaml` - active routines

## 3. Analyze Situation

Based on gathered data, determine:

### Time Context
- How long since last session ended?
- Is it morning (suggest /status), after lunch (suggest continue), evening (suggest wrap up)?

### Git Context
- Are there unmerged commits from origin? How many?
- Are there uncommitted local changes?
- Which branch are we on? Is it the expected one?

### Work Context
- What was the last session about?
- Are there pending_todos?
- What was the focus?

## 4. Generate Proactive Suggestions

Based on analysis, generate 2-3 actionable suggestions using AskUserQuestion:

Examples:
- "origin에서 {N}개 커밋을 받지 않았어요. pull 할까요?"
- "어제 작업하던 {branch} 브랜치로 전환할까요?"
- "미완료 TODO가 {N}개 있어요: {list}. 이어서 할까요?"
- "커밋되지 않은 변경사항이 있어요. 확인해볼까요?"
- "{N}시간 만에 돌아오셨네요! 지난 작업 요약을 보여드릴까요?"

## 5. Update Session State

Create/update `.work-shell/state.json`:
```json
{
  "version": "2.0.0",
  "current_session": {
    "id": "[YYYY-MM-DD-THHMM]",
    "started": "[ISO timestamp]",
    "status": "active",
    "branch": "[current branch]",
    "focus": null,
    "quick_notes": [],
    "stats": {
      "commands_run": 0,
      "commits": 0,
      "files_changed": 0
    }
  }
}
```

## 6. Output Greeting

Format your greeting as:

```
## work-shell 세션 시작

**{날짜} {시간}** | Branch: `{branch}`

---

### 환경 상태
- Remote: {N}개 커밋 미수신 / 동기화됨
- Local: {N}개 파일 변경됨 / Clean
- 마지막 세션: {경과 시간} 전

### 마지막 세션 ({날짜})
> {요약}

### 미완료 작업
- [ ] {todo1}
- [ ] {todo2}

---

### 제안
[AskUserQuestion으로 선택지 제시]
```

User argument: $ARGUMENTS
