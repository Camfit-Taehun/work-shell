---
description: Search past sessions and logs
argument-hint: [sessions|decisions|notes|<query>]
allowed-tools: [Read, Glob, Grep]
---

# History - Search History

Search through past sessions, decisions, and notes.

## Parse Arguments

`$ARGUMENTS`:
- Empty - Show recent history
- `sessions` - List past sessions
- `decisions` - List all decisions
- `notes` - List all notes
- `<query>` - Search for specific term

## 1. Search

### sessions
List `.work-shell/sessions/*.md`:
```
## 세션 히스토리

| 날짜 | Branch | 시간 | 요약 |
|------|--------|------|------|
| 2026-01-07 | master | 2h | work-shell v2.0 구현 |
| 2026-01-06 | feature | 1h | 인증 모듈 작업 |
| ... | ... | ... | ... |

총 {N}개 세션

---

`/history sessions <date>` 로 특정 날짜 세션을 확인하세요.
```

### decisions
Search all decision entries:
```
## 결정 히스토리

| 날짜 | 결정 | 이유 |
|------|------|------|
| 2026-01-07 | JWT 대신 세션 | 보안상 이유 |
| 2026-01-05 | React 사용 | 팀 경험 |
| ... | ... | ... |

총 {N}개 결정

---

`/history decisions <keyword>` 로 검색하세요.
```

### notes
List `.work-shell/notes/*.md`:
```
## 노트 히스토리

| 날짜 | 제목 | 태그 |
|------|------|------|
| 2026-01-07 | API 설계 메모 | #api #design |
| 2026-01-06 | 미팅 노트 | #meeting |

총 {N}개 노트
```

### <query>
Full-text search across all logs:
```
## 검색 결과: "{query}"

### 세션에서 발견
- 2026-01-07: "...{context}..."
- 2026-01-05: "...{context}..."

### 결정에서 발견
- 2026-01-07: "...{context}..."

### 노트에서 발견
- API 설계 메모: "...{context}..."

---

{N}개 결과 발견
```

## 2. Output

Show results with context snippets and links to full content.

User argument: $ARGUMENTS
