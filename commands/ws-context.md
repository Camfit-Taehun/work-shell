---
description: View or edit work-shell.md project context
argument-hint: [show|edit|section-name]
allowed-tools: [Read, Write, Edit]
---

# Context - Project Context Management

View or edit the work-shell.md project context file.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty or `show`: Display current context
- `edit`: Open for editing suggestions
- `<section>`: Show specific section (focus, progress, decisions, etc.)

## 1. Read Context

Read `work-shell.md` from project root.

## 2. Execute Command

### show (default)
Display the full work-shell.md content formatted nicely.

### edit
Ask user what they want to change:
- Update project description
- Modify current focus
- Add to progress
- Update quick reference

### <section>
Extract and show specific section:
- `focus` → Current Focus section
- `progress` → Progress section
- `decisions` → Decisions Log
- `reference` → Quick Reference
- `history` → Session History

## 3. Output

```
## Project Context

{work-shell.md content}

---

**Tip**: `/focus` 로 현재 집중 작업을, `/decision` 으로 의사결정을 기록하세요.
```

User argument: $ARGUMENTS
