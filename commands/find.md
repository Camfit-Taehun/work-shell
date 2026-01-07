---
description: Search helpers and scripts by natural language
argument-hint: <query>
allowed-tools: [Read, Glob, Grep, Bash(ls:*)]
---

# Find - Helper Search

Search for helpers, scripts, and commands using natural language.

## Search Locations

1. `.work-shell/helpers/` - Project helpers
2. `~/.work-shell/helpers/` - Global helpers
3. `commands/` - Available commands

## Parse Arguments

`$ARGUMENTS` is the search query in natural language.

Examples:
- "배포" → deploy.sh, /pr, /flow deploy
- "테스트" → test.sh, /run test
- "커밋" → /commit, pre-commit.sh

## 1. Search

### Search helpers
```bash
ls .work-shell/helpers/ 2>/dev/null
ls ~/.work-shell/helpers/ 2>/dev/null
```

Match against:
- File names
- File contents (first line comment)
- Tags in helper metadata

### Search commands
Match against command descriptions and names.

## 2. Rank Results

Score by relevance:
- Exact name match: 100
- Name contains query: 50
- Description contains: 30
- Content contains: 10

## 3. Output

```
## 검색 결과: "{query}"

### 헬퍼 스크립트
| 이름 | 위치 | 설명 |
|------|------|------|
| deploy.sh | .work-shell/helpers/ | 배포 스크립트 |

### 커맨드
| 커맨드 | 설명 |
|--------|------|
| /pr | PR 생성 |
| /flow deploy | 배포 파이프라인 |

---

`/run <helper>` 로 헬퍼를 실행하세요.
```

User argument: $ARGUMENTS
