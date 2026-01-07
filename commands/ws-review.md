---
description: Generate review checklist for changes
argument-hint: [--pr <number>] [--self]
allowed-tools: [Read, Bash(git:*), Bash(gh:*), Glob]
---

# Review - Code Review Checklist

Generate a review checklist for current changes or a PR.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: Review current uncommitted/staged changes
- `--pr <number>`: Review specific PR
- `--self`: Self-review mode with stricter checks

## 1. Gather Changes

### For local changes
```bash
git diff --name-only
git diff --stat
```

### For PR
```bash
gh pr view <number> --json files,commits,additions,deletions
gh pr diff <number>
```

## 2. Analyze Changes

For each changed file, check:
- File type (code, test, config, docs)
- Change type (new, modified, deleted)
- Change size (lines added/removed)
- Complexity indicators

## 3. Generate Checklist

```markdown
## Review Checklist

**Branch**: `{branch}`
**Files**: {N}개
**Changes**: +{additions} -{deletions}

---

### 일반
- [ ] 코드가 의도대로 동작하는가?
- [ ] 불필요한 코드/주석이 없는가?
- [ ] 네이밍이 명확한가?

### 파일별 체크
{for each file}
#### `{filename}` (+{add} -{del})
- [ ] 로직 검토
- [ ] 에러 처리 확인
- [ ] {file-specific checks}
{end for}

### 테스트
- [ ] 테스트가 추가/수정되었는가?
- [ ] 엣지 케이스가 커버되는가?

### 보안
- [ ] 민감한 데이터 노출 없음
- [ ] 입력 검증 확인

### 성능
- [ ] N+1 쿼리 없음
- [ ] 불필요한 연산 없음

---

**Self-review Tips**:
1. 10분 휴식 후 다시 보기
2. 변경 의도 설명해보기
3. "이 코드를 처음 보는 사람이 이해할 수 있는가?"
```

## 4. Output

Display the checklist and optionally save to `.work-shell/reviews/{date}-{branch}.md`

User argument: $ARGUMENTS
