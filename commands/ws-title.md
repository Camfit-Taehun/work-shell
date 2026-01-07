---
description: Set terminal title (iTerm, Terminal.app, VSCode)
argument-hint: [title] or [--reset]
allowed-tools: [Bash, Read]
---

# Title - Set Terminal Title

Set the terminal window/tab title. Works with:
- iTerm2
- macOS Terminal.app
- VSCode integrated terminal
- Most other terminals supporting ANSI escape sequences

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: Show current title from state
- `<title>`: Set custom title
- `--reset`: Reset to default
- `--auto`: Set based on current session/focus

## 1. Read Current State

Read `.work-shell/state.json` and `.work-shell/config.yaml` for:
- Current session info
- Focus task
- Title format preference

## 2. Determine Title

### If `--auto` or empty with active session:
Use format from config (default: `[branch] path`):
- `{project}`: Directory name or project name from work-shell.md
- `{branch}`: Current git branch
- `{path}`: Last N directories of current path (default: 3)
- `{focus}`: Current focus task
- `{session}`: Session ID

### If `--reset`:
Clear title (restore terminal default)

### If custom title provided:
Use as-is

## 3. Set Terminal Title

Execute the appropriate escape sequence:

```bash
# Universal method (works for most terminals)
echo -ne "\033]0;${TITLE}\007"

# iTerm2 specific (for tab vs window)
# Tab title:
echo -ne "\033]1;${TITLE}\007"
# Window title:
echo -ne "\033]2;${TITLE}\007"
```

For persistent title during session, also set:
```bash
# Prevent shell from overwriting title
export PROMPT_COMMAND=""
# Or for zsh
export DISABLE_AUTO_TITLE="true"
```

## 4. Update State

Save current title to state for reference:
```json
{
  "current_session": {
    "terminal_title": "{title}"
  }
}
```

## 5. Output

```
## Terminal Title Set

**Title**: {title}

Supported terminals: iTerm2, Terminal.app, VSCode, xterm

**Tip**: Add to config for auto-title on session start:
```yaml
terminal:
  auto_title: true
  title_format: "[{branch}] {path}"
  path_depth: 3
```
```

User argument: $ARGUMENTS
