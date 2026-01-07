# Session: work-shell v2.0 구현

**날짜**: 2026-01-07 01:00 ~ 02:00
**Branch**: master
**Duration**: ~1시간
**Status**: completed

---

## 요약

work-shell v2.0을 완전히 새롭게 설계하고 구현했습니다. MVP에서 시작하여 29개 커맨드, 루틴/트리거 시스템, 파이프라인, 세션 브랜칭까지 포함한 완전한 생산성 쉘을 만들었습니다.

---

## 진행 과정

### Phase 0: 초기 기획 및 MVP (v1.0)

1. **프로젝트 구상**
   - Claude Code 위에서 동작하는 생산성 쉘 컨셉
   - `#` 커맨드로 자연어 요청 → 스크립트/에이전트 실행
   - `/hello`, `/bye`, `/log` 기본 커맨드

2. **MVP 구현**
   - 디렉토리 구조 생성
   - 기본 커맨드 3개 (hello, bye, log)
   - work-shell-core 스킬
   - 템플릿 파일들 (config.yaml, state.json, work-shell.md)

3. **테스트**
   - Git 저장소 초기화
   - /hello, /log, /bye 시뮬레이션 테스트
   - 세션 로그 생성 확인

### Phase 1: 확장 기획

사용자 요구사항 수집:
- 능동적인 /hello (상황 분석, 미수신 코드, TODO 표시)
- 루틴 작업 지정 (주기적 자동 실행)
- 트리거 기반 작업 (조건부 실행)
- 파이프라인 (커맨드 체이닝)
- 병렬/백그라운드 실행
- 세션 브랜칭 (컨텍스트 보존)
- 자동 기록 (5분 단위)

### Phase 2: v2.0 설계

인터뷰를 통한 상세 요구사항 확정:
- 코드 소스: Git remote (origin)
- 루틴 정의: 커맨드로 등록 (`/routine add...`)
- 파이프라인 문법: 체이닝 스타일 (`->`, `&`)
- 세션 브랜칭: 병렬 탐색, 장기 작업 분리, 컨텍스트 보존
- 자동 기록: 대화 요약 저장
- 트리거: 시간 + 이벤트 + 조건 모두 지원
- 능동성: 제안 + 확인 형식
- 외부 연동: MCP 플러그인으로 확장 가능

### Phase 3: v2.0 구현

#### 커맨드 (29개)

**Core (7개)**
- `/hello` - 능동적 세션 시작
- `/bye` - 세션 종료
- `/log` - 빠른 체크포인트
- `/status` - 대시보드
- `/todo` - 할일 관리
- `/commit` - 스마트 커밋
- `/summary` - 리포트

**Context (4개)**
- `/context` - work-shell.md 관리
- `/focus` - 집중 작업 설정
- `/decision` - 의사결정 기록
- `/note` - 긴 형식 노트

**Git (4개)**
- `/branch` - 브랜치 관리
- `/pr` - PR 생성
- `/review` - 리뷰 체크리스트
- `/stash` - 스마트 스태시

**Productivity (4개)**
- `/find` - 헬퍼 검색
- `/run` - 스크립트 실행
- `/timer` - 포모도로
- `/break` - 휴식 모드

**Team (3개)**
- `/handoff` - 인수인계
- `/share` - 팀 공유
- `/sync` - 팀 동기화

**Analysis (3개)**
- `/stats` - 통계
- `/retro` - 회고
- `/history` - 히스토리 검색

**System (4개)**
- `/routine` - 루틴 관리
- `/flow` - 파이프라인
- `/fork` - 세션 브랜칭
- `/config` - 설정

**한국어 (3개)**
- `/안녕`, `/바이`, `/기록`

#### 스킬 (4개)

1. **work-shell-core** - 메인 스킬 (v2.0)
2. **routine-engine** - 루틴/트리거 처리
3. **flow-engine** - 파이프라인 실행
4. **fork-manager** - 세션 브랜칭

#### 템플릿 (5개)

- `state.json` (v2.0)
- `config.yaml` (v2.0)
- `routines.yaml`
- `flows.yaml`
- `work-shell.md`

---

## 생성된 파일 목록

### Commands (32개)
```
commands/core/hello.md
commands/core/bye.md
commands/core/log.md
commands/core/status.md
commands/core/todo.md
commands/core/commit.md
commands/core/summary.md
commands/context/context.md
commands/context/focus.md
commands/context/decision.md
commands/context/note.md
commands/git/branch.md
commands/git/pr.md
commands/git/review.md
commands/git/stash.md
commands/productivity/find.md
commands/productivity/run.md
commands/productivity/timer.md
commands/productivity/break.md
commands/team/handoff.md
commands/team/share.md
commands/team/sync.md
commands/analysis/stats.md
commands/analysis/retro.md
commands/analysis/history.md
commands/system/routine.md
commands/system/flow.md
commands/system/fork.md
commands/system/config.md
commands/ko/안녕.md
commands/ko/바이.md
commands/ko/기록.md
```

### Skills (4개)
```
skills/work-shell-core/SKILL.md
skills/work-shell-core/references/session-lifecycle.md
skills/routine-engine/SKILL.md
skills/flow-engine/SKILL.md
skills/fork-manager/SKILL.md
```

### Templates (6개)
```
templates/config.yaml
templates/state.json
templates/work-shell.md
templates/routines.yaml
templates/flows.yaml
templates/settings.json
```

### Other
```
.claude-plugin/plugin.json
.claude/commands/ (심볼릭 링크들)
.claude/settings.json
hooks/hooks.json
README.md
```

---

## 핵심 기능 상세

### 1. 능동적 /hello

```
/hello 실행 시:
1. git fetch origin
2. 미수신 커밋 수 확인
3. 마지막 세션 요약
4. pending_todos 표시
5. AskUserQuestion으로 제안:
   - "origin에서 3개 커밋을 받지 않았어요. pull 할까요?"
   - "미완료 TODO가 2개 있어요. 이어서 할까요?"
```

### 2. 루틴/트리거 시스템

```bash
# 시간 기반
/routine add "매일 09:00" /status

# 이벤트 기반
/routine add "on:commit" /log 커밋완료

# 조건 기반
/routine add "when:files>10" /log 대규모변경
```

### 3. 파이프라인

```bash
# 순차 (->)
/flow commit -> pr -> notify

# 병렬 (&)
/flow (test & lint) -> commit

# 백그라운드
/flow bg long-task

# 저장된 플로우
/flow run deploy
```

### 4. 세션 브랜칭

```bash
/fork "experiment"     # 새 세션 열기
/fork list             # 목록
/fork merge experiment # 결과 병합
```

---

## 다음 단계

1. [ ] Claude Code 재시작하여 커맨드 인식
2. [ ] 실제 /hello 테스트
3. [ ] 루틴 설정 테스트
4. [ ] 파이프라인 테스트
5. [ ] 팀 공유 기능 설정 (Slack/Notion)

---

## 의사결정 로그

| 시간 | 결정 | 이유 |
|------|------|------|
| 01:00 | 하이브리드 방식 선택 | Skills + CLAUDE.md 조합으로 유연성 확보 |
| 01:10 | Git remote (origin) 기준 | 가장 일반적인 워크플로우 |
| 01:15 | 커맨드로 루틴 등록 | YAML 직접 편집보다 직관적 |
| 01:20 | 체이닝 스타일 파이프라인 | Unix 파이프 스타일보다 가독성 좋음 |
| 01:25 | 모든 트리거 타입 지원 | 시간+이벤트+조건 모두 필요 |
| 01:30 | 제안+확인 능동성 | 자동 실행은 위험, 정보만 제공은 부족 |

---

## 통계

- 총 파일: 52개
- 커맨드: 29개 + 한국어 3개
- 스킬: 4개
- 작업 시간: ~1시간
