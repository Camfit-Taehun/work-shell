---
name: flow-engine
description: Handles command pipelines and flows. Use when user mentions "파이프라인", "플로우", "순차", "병렬", "백그라운드".
version: 1.0.0
---

# Flow Engine Skill

Manages command pipelines with sequential, parallel, and background execution.

## Syntax

### Sequential Execution (->)
```
/flow commit -> pr -> notify
```
Commands run one after another. Pipeline stops on first failure.

### Parallel Execution (&)
```
/flow test & lint & typecheck
```
Commands run simultaneously. Wait for all to complete.

### Grouping ()
```
/flow (test & lint) -> commit -> pr
```
Combine parallel and sequential execution.

### Background (bg)
```
/flow bg long-running-task
```
Run without blocking. Returns immediately.

## Parsing

Input: `(test & lint) -> commit -> pr`

AST:
```json
{
  "type": "sequence",
  "steps": [
    {
      "type": "parallel",
      "steps": [
        {"type": "command", "cmd": "test"},
        {"type": "command", "cmd": "lint"}
      ]
    },
    {"type": "command", "cmd": "commit"},
    {"type": "command", "cmd": "pr"}
  ]
}
```

## Flow Commands

- `/flow <pipeline>` - Execute pipeline directly
- `/flow run <name>` - Run saved flow
- `/flow save <name> "<pipeline>"` - Save flow
- `/flow list` - List saved flows
- `/flow delete <name>` - Delete flow
- `/flow status [id]` - Check background flow status

## Saved Flows

Stored in `.work-shell/flows.yaml`:
```yaml
flows:
  deploy:
    description: "Full deployment"
    pipeline: "commit -> pr -> (test & build) -> deploy"

  morning:
    description: "Morning routine"
    pipeline: "hello -> status -> todo list"

  cleanup:
    description: "End of day"
    pipeline: "summary -> bye"
```

## Execution Context

Each step receives context from previous step:
```json
{
  "step": 1,
  "total_steps": 3,
  "previous_result": { ... },
  "flow_id": "flow-abc123",
  "started": "2026-01-07T01:00:00Z"
}
```

## Background Flows

Background flows tracked in `.work-shell/flows/active/`:
```json
{
  "id": "flow-abc123",
  "pipeline": "long-task",
  "status": "running",
  "started": "2026-01-07T01:00:00Z",
  "current_step": 1,
  "output": []
}
```

## Error Handling

- Sequential: Stop on first error
- Parallel: Continue all, report failures at end
- Background: Log errors, continue
