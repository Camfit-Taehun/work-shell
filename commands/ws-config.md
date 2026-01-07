---
description: Manage work-shell configuration
argument-hint: [show|set|reset] [key] [value]
allowed-tools: [Read, Write, Edit, AskUserQuestion]
---

# Config - Configuration Management

View and modify work-shell settings.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty or `show` - Show all settings
- `show <key>` - Show specific setting
- `set <key> <value>` - Set a value
- `reset` - Reset to defaults
- `reset <key>` - Reset specific key

## Configuration Keys

### git
- `git.auto_commit` (bool) - Auto-commit on /bye
- `git.commit_prefix` (string) - Commit message prefix

### session
- `session.auto_pause_minutes` (int) - Auto-pause timeout

### logging
- `logging.include_git_status` (bool) - Include git in logs
- `logging.include_timestamps` (bool) - Include timestamps
- `logging.max_session_history` (int) - Max sessions to keep

### allowed_tools
- `allowed_tools` (array) - Auto-approved tools

### routines
- `routines.enabled` (bool) - Enable routine system

## 1. Read Config

Read `.work-shell/config.yaml`

## 2. Execute

### show
```
## work-shell 설정

### Git
| 키 | 값 | 설명 |
|----|-----|------|
| auto_commit | false | /bye 시 자동 커밋 |
| commit_prefix | "chore(work-shell):" | 커밋 접두사 |

### Session
| 키 | 값 | 설명 |
|----|-----|------|
| auto_pause_minutes | 0 | 자동 일시정지 (0=비활성) |

### Logging
| 키 | 값 | 설명 |
|----|-----|------|
| include_git_status | true | 로그에 git 상태 포함 |
| include_timestamps | true | 타임스탬프 포함 |
| max_session_history | 50 | 최대 세션 기록 수 |

### Allowed Tools ({N}개)
- Read, Write, Edit, ...

---

`/config set <key> <value>` 로 수정하세요.
```

### set
Update `.work-shell/config.yaml`:
```
## 설정 변경됨

**{key}**: {old_value} → {new_value}

변경사항이 저장되었습니다.
```

Also update `.claude/settings.json` if needed (for allowed_tools).

### reset
Restore from `templates/config.yaml`:
```
## 설정 초기화됨

{key or all} 설정이 기본값으로 복원되었습니다.
```

User argument: $ARGUMENTS
