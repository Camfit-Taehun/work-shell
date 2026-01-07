---
description: Run command pipelines
argument-hint: <pipeline> | run <name> | save <name> "<pipeline>"
allowed-tools: [Read, Write, Bash(*), AskUserQuestion]
---

# Flow - Command Pipeline

Execute commands in sequence, parallel, or background.

## Syntax

### Sequential (->)
```
/flow commit -> pr -> notify
```
Run commands one after another. Stop if any fails.

### Parallel (&)
```
/flow (test & lint) -> commit
```
Run commands in parentheses simultaneously.

### Background (bg)
```
/flow bg long-task
```
Run in background, continue working.

### Saved flows
```
/flow run deploy-flow
/flow save deploy-flow "commit -> pr -> deploy"
/flow list
```

## Parse Arguments

`$ARGUMENTS` can be:
- `<pipeline>` - Execute pipeline directly
- `run <name>` - Run saved flow
- `save <name> "<pipeline>"` - Save flow for reuse
- `list` - List saved flows
- `bg <command>` - Run command in background

## 1. Parse Pipeline

Parse operators:
- `->` : Sequential
- `&` : Parallel
- `( )` : Grouping
- `bg` : Background

Build execution tree:
```json
{
  "type": "sequential",
  "steps": [
    {"type": "command", "cmd": "/commit"},
    {"type": "parallel", "steps": [
      {"type": "command", "cmd": "/test"},
      {"type": "command", "cmd": "/lint"}
    ]},
    {"type": "command", "cmd": "/pr"}
  ]
}
```

## 2. Execute

### Sequential
Execute each step, pass context forward.
```
[1/3] /commit ... ✓
[2/3] /test & /lint ... ✓
[3/3] /pr ... ✓
```

### Parallel
Use Task tool to run commands simultaneously.
Wait for all to complete before continuing.

### Background
Start execution, return immediately.
Save status to `.work-shell/flows/active/{id}.json`

## 3. Save/Load Flows

`.work-shell/flows.yaml`:
```yaml
flows:
  deploy-flow:
    description: "Full deploy pipeline"
    pipeline: "commit -> pr -> (test & build) -> deploy"
    created: "{timestamp}"

  morning:
    description: "Morning routine"
    pipeline: "hello -> status -> todo list"
```

## 4. Output

### Direct execution
```
## Flow 실행

`commit -> pr -> notify`

---

[1/3] /commit
      ✓ 커밋 완료 (abc1234)

[2/3] /pr
      ✓ PR #123 생성됨

[3/3] /notify
      ✓ 알림 전송됨

---

**결과**: 성공 (3/3)
**소요 시간**: 45초
```

### Background
```
## Flow 백그라운드 실행

**ID**: flow-{id}
**Pipeline**: {pipeline}

백그라운드에서 실행 중...

`/flow status {id}` 로 진행 상황을 확인하세요.
```

User argument: $ARGUMENTS
