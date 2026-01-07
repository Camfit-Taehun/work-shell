---
description: Update work-shell plugin to latest version
argument-hint: [--check]
allowed-tools: [Bash, Read]
---

# Update - Self-update work-shell plugin

Update the work-shell plugin to the latest version from GitHub.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: Update to latest version
- `--check`: Only check for updates, don't install

## 1. Detect Installation Method

Find where work-shell is installed:

```bash
# Check possible locations
# 1. Marketplace installation
MARKETPLACE_PATH="$HOME/.claude/plugins/cache/camfit-plugins/work-shell"

# 2. Project-level plugin
PROJECT_PATH=".claude/plugins/work-shell"

# 3. Find by CLAUDE_PLUGIN_ROOT if available
```

## 2. Get Current Version

Read current version from plugin.json:
```bash
cat <plugin-path>/.claude-plugin/plugin.json | grep version
```

## 3. Check for Updates

```bash
# Fetch latest from remote
cd <plugin-path>
git fetch origin master

# Compare versions
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/master)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Already up to date"
else
    # Show what's new
    git log --oneline HEAD..origin/master
fi
```

## 4. Update (if not --check)

```bash
# Pull latest changes
git pull origin master

# Show changelog
git log --oneline -5
```

## 5. Output

### If up to date:
```
## work-shell 업데이트

**현재 버전**: v{version}
**상태**: 최신 버전입니다

마지막 업데이트: {date}
```

### If updated:
```
## work-shell 업데이트 완료

**이전 버전**: v{old_version}
**새 버전**: v{new_version}

### 변경 사항
{git log of new commits}

**Tip**: 새 기능을 확인하려면 `/help`를 실행하세요.
```

### If --check with updates available:
```
## work-shell 업데이트 확인

**현재 버전**: v{version}
**최신 버전**: v{latest}

### 새로운 변경 사항
{git log of pending commits}

업데이트하려면 `/update`를 실행하세요.
```

User argument: $ARGUMENTS
