---
description: Run helper scripts
argument-hint: <helper-name> [args...]
allowed-tools: [Read, Bash(*), Glob]
---

# Run - Execute Helper Scripts

Run helper scripts from .work-shell/helpers/ or global helpers.

## Parse Arguments

`$ARGUMENTS`:
- `<name>` - Helper name (with or without extension)
- `<name> <args>` - Helper with arguments

## 1. Find Helper

Search order:
1. `.work-shell/helpers/{name}`
2. `.work-shell/helpers/{name}.sh`
3. `.work-shell/helpers/{name}.py`
4. `~/.work-shell/helpers/{name}`
5. `~/.work-shell/helpers/{name}.sh`
6. `~/.work-shell/helpers/{name}.py`

## 2. Determine Executor

Based on extension or shebang:
- `.sh` or `#!/bin/bash` → bash
- `.py` or `#!/usr/bin/env python` → python3
- `.js` → node
- No extension → check shebang

## 3. Execute

```bash
# Make executable if needed
chmod +x {helper_path}

# Run with arguments
{executor} {helper_path} {args}
```

Capture output and exit code.

## 4. Log Execution

Add to `.work-shell/logs/{date}.md`:
```markdown
### {HH:MM} - Helper 실행

**Helper**: {name}
**Args**: {args}
**Exit code**: {code}
```

## 5. Output

```
## Helper 실행

**{name}** {args}

---

{output}

---

**Exit code**: {code}
**실행 시간**: {duration}
```

If error:
```
## Helper 실행 실패

**{name}** {args}

**Error**: {error_message}

---

{stderr}

---

`/find {name}` 으로 비슷한 헬퍼를 찾아보세요.
```

User argument: $ARGUMENTS
