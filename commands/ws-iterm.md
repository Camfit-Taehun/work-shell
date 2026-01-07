---
description: Manage iTerm2 panel settings (title, badge, background color, layout presets)
argument-hint: [title|badge|bg|layout|save|load|list] [value]
allowed-tools: [Read, Write, Bash(echo:*), Bash(printf:*), Bash(cat:*), Bash(mkdir:*), Bash(ls:*), Glob, AskUserQuestion]
---

# iTerm2 Panel Configuration

Manage iTerm2 terminal settings including title, badge, background color, and layout presets.

User argument: $ARGUMENTS

## Parse Arguments

Parse the first word as subcommand:
- `title <text>` - Set panel title
- `badge <text>` - Set panel badge (large translucent text)
- `bg <color>` - Set background color (hex like #1a1a2e or name like red, blue)
- `layout <cols>x<rows>` - Show instructions for panel layout (e.g., 3x2)
- `save <name>` - Save current iTerm settings as preset
- `load <name>` - Load and apply saved preset
- `list` - List saved presets
- `clear` - Clear title and badge
- (no args) - Show current panel info and available commands

## Color Presets

Common color names to hex:
- `red` → #2d1f1f (dark red tint)
- `green` → #1f2d1f (dark green tint)
- `blue` → #1f1f2d (dark blue tint)
- `yellow` → #2d2d1f (dark yellow tint)
- `purple` → #2d1f2d (dark purple tint)
- `orange` → #2d251f (dark orange tint)
- `cyan` → #1f2d2d (dark cyan tint)
- `prod` → #3d1f1f (production warning red)
- `dev` → #1f2d1f (development green)
- `test` → #1f1f2d (test blue)
- `default` → #1c1c1c (default dark)

## Implementation

### For `title <text>`:
```bash
echo -ne "\033]0;TEXT_HERE\007"
```
Output: "✓ Panel title set to: TEXT_HERE"

### For `badge <text>`:
```bash
printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "TEXT_HERE" | base64)
```
Output: "✓ Badge set to: TEXT_HERE"

### For `bg <color>`:
First convert color name to hex if needed (use color presets above).
```bash
# RGB values from hex (remove # prefix)
# For #1a1a2e → R=26, G=26, B=46
printf "\e]Ph%s\e\\" "RRGGBB"
```
Alternative using OSC 11:
```bash
printf "\e]11;#RRGGBB\a"
```
Output: "✓ Background color set to: #RRGGBB"

### For `layout <cols>x<rows>`:
Don't execute anything, just show instructions:
```
iTerm 패널 레이아웃 만들기: {cols}x{rows}

1. 가로 분할 (Cmd+D): {cols-1}번 반복
2. 각 열에서 세로 분할 (Cmd+Shift+D): {rows-1}번씩

단축키 참고:
- Cmd + D: 가로 분할
- Cmd + Shift + D: 세로 분할
- Cmd + Opt + 방향키: 패널 이동
- Cmd + Shift + Enter: 패널 최대화 토글
- Window → Save Window Arrangement: 레이아웃 저장
```

### For `save <name>`:
1. Ask user for current settings via AskUserQuestion:
   - title (optional)
   - badge (optional)
   - background color (optional, hex format)
   - description (optional)
2. Save to `.work-shell/iterm-presets.yaml`:
```yaml
presets:
  <name>:
    title: "value"
    badge: "value"
    bg: "#rrggbb"
    description: "description"
    created: "ISO date"
```
Output: "✓ Preset '{name}' saved"

### For `load <name>`:
1. Read `.work-shell/iterm-presets.yaml`
2. Find preset by name
3. Apply each setting that exists:
   - title → execute title escape sequence
   - badge → execute badge escape sequence
   - bg → execute background color escape sequence
Output: "✓ Preset '{name}' applied (title: X, badge: Y, bg: Z)"

### For `list`:
1. Read `.work-shell/iterm-presets.yaml`
2. Output formatted list:
```
📋 Saved iTerm Presets:

  NAME          TITLE      BADGE      BG         DESCRIPTION
  ─────────────────────────────────────────────────────────
  dev-server    DEV        🟢 DEV     #1f2d1f    Development
  prod-db       PROD DB    ⚠️ PROD    #3d1f1f    Production DB
  ...
```

### For `clear`:
```bash
echo -ne "\033]0;\007"  # clear title
printf "\e]1337;SetBadgeFormat=\a"  # clear badge
```
Output: "✓ Title and badge cleared"

### For no arguments:
Show help:
```
🖥️  iTerm Panel Settings

Usage: /iterm <command> [value]

Commands:
  title <text>     Set panel title
  badge <text>     Set badge (translucent overlay)
  bg <color>       Set background (#hex or name: red, green, blue, prod, dev)
  layout <CxR>     Show layout instructions (e.g., 3x2)
  save <name>      Save current settings as preset
  load <name>      Apply saved preset
  list             List saved presets
  clear            Clear title and badge

Examples:
  /iterm title "API Server"
  /iterm badge PROD
  /iterm bg prod
  /iterm bg #1a1a2e
  /iterm save my-setup
  /iterm load my-setup
  /iterm layout 3x2

Shortcuts:
  /iterm dev       Quick: badge=DEV, bg=green tint
  /iterm prod      Quick: badge=⚠️PROD, bg=red tint
  /iterm test      Quick: badge=TEST, bg=blue tint
```

### Quick Presets (built-in):
- `/iterm dev` → badge "DEV", bg #1f2d1f
- `/iterm prod` → badge "⚠️ PROD", bg #3d1f1f
- `/iterm test` → badge "TEST", bg #1f1f2d

## State

Presets are stored in `.work-shell/iterm-presets.yaml`.
If file doesn't exist, create it with empty presets list.

## Output Format

Always output results in a clear, concise format. Use emoji sparingly:
- ✓ for success
- ✗ for error
- 📋 for lists
- 🖥️ for help header
