---
description: Fork session for parallel exploration
argument-hint: [name] | list | switch <name> | merge <name>
allowed-tools: [Read, Write, Bash(claude:*), Bash(osascript:*), AskUserQuestion]
---

# Fork - Session Branching

Create parallel work sessions while preserving context.

## Use Cases

1. **병렬 탐색**: 여러 접근 방식을 동시에 시도
2. **장기 작업 분리**: 백그라운드 작업을 별도 세션에서
3. **컨텍스트 보존**: 현재 상태 저장 후 다른 작업

## Parse Arguments

`$ARGUMENTS` can be:
- `<name>` - Fork current session with name
- `list` - List all forks
- `switch <name>` - Switch to fork
- `merge <name>` - Merge fork results back
- `delete <name>` - Delete fork

## 1. Fork Session

### Save current context
Create `.work-shell/forks/{name}.json`:
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

### Open new terminal
```bash
# macOS
osascript -e 'tell app "Terminal" to do script "cd {cwd} && claude"'

# Or iTerm2
osascript -e 'tell application "iTerm2" to create window with default profile command "cd {cwd} && claude"'
```

### Initialize fork session
The new session should:
1. Detect it's a fork (check for fork flag)
2. Load fork context
3. Show fork indicator in prompts

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
1. Read fork's session logs
2. Import decisions/notes to main
3. Optionally apply git changes
4. Mark fork as merged

```
## Fork 머지

**{name}** → **main**

### 가져온 내용
- 결정: {N}개
- 노트: {N}개
- 커밋: {N}개

### 병합 완료
Fork `{name}`의 작업이 메인 세션에 병합되었습니다.
```

## 4. Output

### Fork
```
## Session Fork 생성됨

**이름**: {name}
**상태**: 새 터미널에서 실행됨

### 현재 세션
- Branch: `{branch}`
- Focus: {focus}

---

새 터미널에서 `/hello` 로 fork 세션을 시작하세요.
완료 후 `/fork merge {name}` 으로 결과를 병합할 수 있습니다.
```

User argument: $ARGUMENTS
