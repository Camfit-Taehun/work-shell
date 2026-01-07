---
description: Sync team helpers and settings
argument-hint: [pull|push|status]
allowed-tools: [Read, Write, Bash(git:*), Bash(curl:*)]
---

# Sync - Team Sync

Synchronize team-shared helpers, templates, and settings.

## Configuration

In `.work-shell/config.yaml`:
```yaml
team:
  name: "team-name"
  shared_helpers:
    remote: "git@github.com:team/work-shell-helpers.git"
    path: ".work-shell/team-helpers"
  sync:
    auto: false
    interval: "daily"
```

## Parse Arguments

`$ARGUMENTS`:
- Empty or `status` - Show sync status
- `pull` - Pull latest from team repo
- `push` - Push local changes to team

## 1. Status

```
## Team Sync 상태

**팀**: {team_name}
**Remote**: {remote_url}

### 로컬 상태
- 마지막 동기화: {last_sync}
- 로컬 변경: {local_changes}

### 리모트 상태
- 새로운 업데이트: {remote_changes}

---

`/sync pull` 로 최신 버전을 받으세요.
```

## 2. Pull

```bash
cd .work-shell/team-helpers
git pull origin main
```

```
## Team Sync 완료 (Pull)

### 업데이트된 내용
- helpers/{new_helper}.sh (신규)
- templates/review.md (수정)

### 적용됨
팀 헬퍼가 최신 버전으로 업데이트되었습니다.

---

`/find` 로 새 헬퍼를 확인하세요.
```

## 3. Push

```bash
cd .work-shell/team-helpers
git add .
git commit -m "Update from {user}"
git push origin main
```

```
## Team Sync 완료 (Push)

### 공유된 내용
- helpers/my-helper.sh

### 커밋
{commit_hash}: Update from {user}

---

팀원들이 `/sync pull` 로 받을 수 있습니다.
```

User argument: $ARGUMENTS
