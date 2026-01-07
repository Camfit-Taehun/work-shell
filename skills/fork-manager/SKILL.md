---
name: fork-manager
description: Handles session branching and parallel exploration with context transfer. Use when user mentions "포크", "브랜치 세션", "병렬 탐색", "컨텍스트 보존", "세션 분기".
version: 2.0.0
---

# Fork Manager Skill

Manages session branching for parallel work exploration **with Claude conversation context transfer**.

## Key Feature: Context Transfer

Unlike simple session forking, this skill transfers the **Claude conversation context** to the new session:
- What was being worked on
- Decisions made during conversation
- What was tried and results
- Current understanding of the problem

## Use Cases

1. **병렬 탐색**: 여러 접근 방식을 동시에 시도 (각각 컨텍스트 유지)
2. **장기 작업 분리**: 백그라운드 작업을 별도 세션에서 (컨텍스트 전달)
3. **컨텍스트 보존**: 현재 대화 상태 저장 후 다른 작업
4. **실험적 변경**: 위험한 변경을 별도 세션에서 시도

## Fork Commands

- `/ws-fork <name>` - Create fork with context transfer
- `/ws-fork list` - List all forks
- `/ws-fork switch <name>` - Switch to fork
- `/ws-fork merge <name>` - Merge fork results (cleans up context files)
- `/ws-fork delete <name>` - Delete fork

## How Context Transfer Works

### 1. Fork Creation

```
[Current Session]
     │
     │ /ws-fork experiment
     │
     ├─► Generate context summary
     │   - 작업 중인 것
     │   - 결정 사항
     │   - 시도한 것들
     │   - 현재 이해
     │   - Fork 목적
     │
     ├─► Save to files:
     │   - .work-shell/forks/{name}/context.md
     │   - .work-shell/forks/{name}/state.json
     │
     ├─► Copy to .claude/ for auto-load:
     │   - .claude/fork-{name}.md
     │
     └─► Open new terminal with Claude
```

### 2. Fork Session Start

```
[New Terminal - Claude starts]
     │
     │ /ws-hello
     │
     ├─► Detect .claude/fork-*.md
     │
     ├─► Read fork context
     │
     ├─► Display: "🔀 Fork 세션 시작: {name}"
     │
     └─► Brief user on previous context
         - 작업 중이던 것
         - 결정 사항
         - Fork 탐색 방향
```

### 3. Fork Merge/Delete

```
[Any Session]
     │
     │ /ws-fork merge {name}
     │
     ├─► Import fork findings
     │
     ├─► Clean up .claude/fork-{name}.md
     │
     └─► Mark fork as merged
```

## File Structure

```
project/
├── .claude/
│   └── fork-{name}.md      # Auto-loaded by Claude (temporary)
├── .work-shell/
│   └── forks/
│       └── {name}/
│           ├── state.json   # Fork metadata
│           └── context.md   # Conversation context
```

## Fork State

Stored in `.work-shell/forks/{name}/state.json`:
```json
{
  "id": "feature-exploration",
  "created": "2026-01-08T10:00:00Z",
  "parent_session": "2026-01-08-T0930",
  "branch": "master",
  "focus": "Current focus at fork time",
  "working_directory": "/path/to/project",
  "state_snapshot": { /* full state.json copy */ },
  "status": "active",
  "context_file": ".work-shell/forks/feature-exploration/context.md"
}
```

## Context File Format

`.work-shell/forks/{name}/context.md`:
```markdown
# Fork Context: {name}

> 이 파일은 fork 세션 시작 시 자동으로 로드됩니다.

## Fork 정보
- **생성**: 2026-01-08 10:00
- **부모 세션**: 2026-01-08-T0930
- **Branch**: master
- **목적**: OAuth2 대신 session-based auth 탐색

## 이전 세션 컨텍스트

### 작업 중이던 것
API 인증 시스템 리팩토링

### 결정 사항
- JWT에서 전환하기로 함
- passport.js 사용

### 시도한 것들
- passport-jwt 설정 완료
- 토큰 갱신 로직 구현 중 문제 발생

### 현재 이해
토큰 갱신이 복잡해서 다른 방식 고려 중

## Fork 탐색 방향
session-based auth로 전환 시 장단점 파악
```

## Fork Lifecycle

```
[Main Session]
      │
   /ws-fork "experiment"
      │
      ├─────────────────────────┐
      │                         │
      │  Context transferred    │
      │         ↓               │
 [Main continues]        [Fork session]
      │                    │ (컨텍스트 로드됨)
      │                    │
      │                (work...)
      │                    │
      │              /ws-fork merge
      │                    │
      ◄────────────────────┘
      │   Results + learnings
      │   .claude/fork-*.md 삭제
      │
 [Results merged]
```

## Best Practices

1. **명확한 Fork 목적**: Fork 생성 시 탐색 방향을 명확히
2. **컨텍스트 품질**: 요약이 정확해야 새 세션이 효과적
3. **적시 머지**: Fork 완료 후 바로 merge하여 .claude 파일 정리
4. **단일 책임**: 하나의 fork는 하나의 탐색 방향만
