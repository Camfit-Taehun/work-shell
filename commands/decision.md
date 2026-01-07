---
description: Record a decision with reason
argument-hint: <decision> [--reason <why>]
allowed-tools: [Read, Write, Edit, Bash(date:*), AskUserQuestion]
---

# Decision - Record Decision

Record an important decision with its reasoning.

## Parse Arguments

`$ARGUMENTS` format:
- `<decision>` - The decision made
- `--reason <why>` - Optional reason (will ask if not provided)

## 1. Get Decision Details

If reason not provided, ask user:
- What was the decision?
- Why was this decision made?
- What alternatives were considered?

## 2. Record Decision

### Update work-shell.md
Add to Decisions Log table:
```markdown
| {date} | {decision} | {reason} |
```

### Update daily log
Append to `.work-shell/logs/{date}.md`:
```markdown
### {HH:MM} - Decision

**결정**: {decision}

**이유**: {reason}

**대안**: {alternatives if any}

---
```

### Update session notes
Add to `.work-shell/state.json` quick_notes:
```json
{
  "time": "{timestamp}",
  "type": "decision",
  "note": "{decision}",
  "reason": "{reason}"
}
```

## 3. Output

```
## Decision 기록됨

**결정**: {decision}

**이유**: {reason}

**기록 위치**:
- work-shell.md Decisions Log
- .work-shell/logs/{date}.md

---

나중에 `/history decisions` 로 모든 결정을 조회할 수 있습니다.
```

User argument: $ARGUMENTS
