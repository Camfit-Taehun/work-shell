---
description: Fork session for parallel exploration
argument-hint: [name] | list | switch <name> | merge <name>
allowed-tools: [Read, Write, Bash(claude:*), Bash(osascript:*), Bash(mkdir:*), Bash(rm:*), Bash(cp:*), AskUserQuestion]
---

# Fork - Session Branching with Context Transfer

Create parallel work sessions while preserving **Claude conversation context**.

## Use Cases

1. **병렬 탐색**: 여러 접근 방식을 동시에 시도
2. **장기 작업 분리**: 백그라운드 작업을 별도 세션에서
3. **컨텍스트 보존**: 현재 대화 컨텍스트까지 전달

## Parse Arguments

`$ARGUMENTS` can be:
- `<name>` - Fork current session with name (includes context transfer)
- `list` - List all forks
- `switch <name>` - Switch to fork
- `merge <name>` - Merge fork results back (cleans up context files)
- `delete <name>` - Delete fork

## 1. Fork Session (Creating a Fork)

### Step 1: Generate Context Summary

**IMPORTANT**: Before creating the fork, summarize the current conversation context.

Create a context summary that includes:
- 현재 작업 중인 것 (what we're working on)
- 지금까지 결정한 것들 (decisions made)
- 시도했던 것들과 결과 (what was tried and results)
- 현재 이해하고 있는 것 (current understanding)
- 이 fork의 목적 (purpose of this fork - ask user if not clear)

### Step 2: Save Fork State

Create directory and files:

```bash
mkdir -p .work-shell/forks/{name}
```

Create `.work-shell/forks/{name}/state.json`:
```json
{
  "id": "{name}",
  "created": "{timestamp}",
  "parent_session": "{current_session_id}",
  "branch": "{git_branch}",
  "focus": "{current_focus}",
  "state_snapshot": { /* full state.json copy */ },
  "working_directory": "{cwd}",
  "status": "active"
}
```

### Step 3: Create Context File for Auto-Loading

Write context summary to `.work-shell/forks/{name}/context.md`:
```markdown
# Fork Context: {name}

> 이 파일은 fork 세션 시작 시 자동으로 로드됩니다.

## Fork 정보
- **생성**: {timestamp}
- **부모 세션**: {parent_session_id}
- **Branch**: {git_branch}
- **목적**: {fork_purpose}

## 이전 세션 컨텍스트

### 작업 중이던 것
{what we were working on}

### 결정 사항
{decisions made during conversation}

### 시도한 것들
{what was tried and results}

### 현재 이해
{current understanding of the problem/task}

## Fork 탐색 방향
{what this fork session should explore}

---
*이 컨텍스트를 바탕으로 작업을 계속하세요.*
```

### Step 4: Link to .claude for Auto-Loading

Copy the context file to `.claude/` directory so Claude Code auto-loads it:
```bash
cp .work-shell/forks/{name}/context.md .claude/fork-{name}.md
```

### Step 5: Open New Terminal

```bash
# macOS - iTerm2 preferred
osascript -e 'tell application "iTerm2" to create window with default profile command "cd {cwd} && claude"'

# Fallback: Terminal.app
osascript -e 'tell app "Terminal" to do script "cd {cwd} && claude"'
```

### Step 6: Mark Fork as Active

Update `.work-shell/forks/{name}/state.json` with `"status": "active"`

## 2. List Forks

```
## Session Forks

| Name | 상태 | 생성 | Branch |
|------|------|------|--------|
| feature-try-1 | active | 10분 전 | main |
| api-refactor | paused | 1시간 전 | main |

**현재 세션**: {current or main}

---

`/fork switch <name>` 으로 전환하세요.
```

## 3. Merge Fork

Merge results from a fork back to main session:

### Step 1: Read Fork Results
- Read `.work-shell/forks/{name}/context.md` for context
- Read fork's session logs if available
- Check git for any commits made in fork session

### Step 2: Import to Main Session
- Import decisions/notes to main session logs
- Optionally cherry-pick git commits
- Update main session's understanding with fork findings

### Step 3: Clean Up Context Files

**IMPORTANT**: Remove the auto-load file from .claude directory:
```bash
rm -f .claude/fork-{name}.md
```

### Step 4: Mark Fork as Merged
Update `.work-shell/forks/{name}/state.json`:
```json
{
  "status": "merged",
  "merged_at": "{timestamp}"
}
```

### Output Format
```
## Fork 머지 완료

**{name}** → **main**

### 가져온 내용
- 결정: {N}개
- 노트: {N}개
- 커밋: {N}개

### Fork 발견 사항
{summary of what was learned/discovered in fork}

### 정리됨
- [x] `.claude/fork-{name}.md` 삭제
- [x] Fork 상태 → merged

Fork `{name}`의 작업이 메인 세션에 병합되었습니다.
```

## 4. Delete Fork

Remove a fork completely:

```bash
# Remove context file from .claude
rm -f .claude/fork-{name}.md

# Remove fork directory
rm -rf .work-shell/forks/{name}
```

Output:
```
## Fork 삭제됨

**{name}** fork가 삭제되었습니다.
- [x] 컨텍스트 파일 삭제
- [x] Fork 데이터 삭제
```

## 5. Fork Creation Output

After successfully creating a fork, show:

```
## Session Fork 생성됨 🔀

**이름**: {name}
**상태**: 새 터미널에서 실행됨

### 현재 세션 컨텍스트
- Branch: `{branch}`
- Focus: {focus}

### 전달된 컨텍스트
- 작업 내용: {brief summary}
- 결정 사항: {N}개
- Fork 목적: {purpose}

### 파일 생성됨
- `.work-shell/forks/{name}/context.md`
- `.claude/fork-{name}.md` (자동 로드용)

---

새 터미널에서 `/ws-hello` 실행하면 컨텍스트가 자동 로드됩니다.
완료 후 `/ws-fork merge {name}` 으로 결과를 병합하세요.
```

User argument: $ARGUMENTS
