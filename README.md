# work-shell v2.0

Claude Code 생산성 쉘 - 세션 관리, 자동화, 파이프라인 지원

## 개요

work-shell은 Claude Code 위에서 동작하는 생산성 도구입니다:
- 세션 관리 및 컨텍스트 유지
- 능동적 상황 분석 및 제안
- 루틴/트리거 자동화
- 커맨드 파이프라인
- 세션 브랜칭

## 설치

### 마켓플레이스에서 설치 (권장)

```bash
# 1. 마켓플레이스 추가
claude plugin marketplace add https://raw.githubusercontent.com/Camfit-Taehun/work-shell/master/marketplace.json

# 2. 플러그인 설치
claude plugin install work-shell@camfit-plugins
```

### 수동 설치

```bash
# Git clone으로 설치
git clone https://github.com/Camfit-Taehun/work-shell.git .claude/plugins/work-shell

# Claude 실행 (플러그인 로드)
claude --plugin-dir .claude/plugins/work-shell
```

### 프로젝트 초기화

설치 후 프로젝트에서 `/hello`를 실행하면 자동으로 초기화됩니다.
수동 초기화:

```bash
mkdir -p .work-shell/logs .work-shell/sessions
cp .claude/plugins/work-shell/templates/* .work-shell/
```

## 커맨드 목록 (31개)

### Core
| 커맨드 | 설명 |
|--------|------|
| `/hello` | 세션 시작 + 상황 분석 + 제안 |
| `/bye` | 세션 종료 + 요약 저장 |
| `/log <note>` | 빠른 체크포인트 |
| `/status` | 현재 상태 대시보드 |
| `/todo <add\|done\|list>` | 할일 관리 |
| `/commit` | 스마트 커밋 |
| `/summary` | 작업 리포트 |

### Context
| 커맨드 | 설명 |
|--------|------|
| `/context` | work-shell.md 조회/수정 |
| `/focus <task>` | 집중 작업 설정 |
| `/decision <text>` | 의사결정 기록 |
| `/note` | 긴 형식 노트 |

### Git
| 커맨드 | 설명 |
|--------|------|
| `/branch` | 브랜치 관리 |
| `/pr` | PR 생성 (세션 로그 기반) |
| `/review` | 코드 리뷰 체크리스트 |
| `/stash` | 스마트 스태시 |

### System
| 커맨드 | 설명 |
|--------|------|
| `/routine` | 루틴 관리 |
| `/flow` | 파이프라인 실행 |
| `/fork` | 세션 브랜칭 |
| `/config` | 설정 관리 |
| `/update` | 플러그인 자체 업데이트 |

### Productivity
| 커맨드 | 설명 |
|--------|------|
| `/find` | 헬퍼 검색 |
| `/run` | 스크립트 실행 |
| `/timer` | 포모도로 타이머 |
| `/break` | 휴식 모드 |
| `/title` | 터미널 타이틀 설정 |

### Team
| 커맨드 | 설명 |
|--------|------|
| `/handoff` | 인수인계 문서 |
| `/share` | 팀 공유 |
| `/sync` | 팀 동기화 |

### Analysis
| 커맨드 | 설명 |
|--------|------|
| `/stats` | 작업 통계 |
| `/retro` | 회고 템플릿 |
| `/history` | 히스토리 검색 |

## 핵심 기능

### 능동적 /hello

```
/hello 실행 시:
- origin에서 3개 커밋을 받지 않았어요. pull 할까요?
- 미완료 TODO가 2개 있어요. 이어서 할까요?
- 어제 작업하던 feature/auth 브랜치로 전환할까요?
```

### 루틴/트리거

```bash
# 시간 기반
/routine add "매일 09:00" /status

# 이벤트 기반
/routine add "on:commit" /log 커밋완료

# 조건 기반
/routine add "when:files>10" /log 대규모변경
```

### 파이프라인

```bash
# 순차 실행
/flow commit -> pr -> notify

# 병렬 실행
/flow (test & lint) -> commit

# 저장된 플로우
/flow run deploy
```

### 세션 브랜칭

```bash
# 현재 컨텍스트로 새 세션
/fork "experiment"

# 결과 병합
/fork merge experiment
```

## 디렉토리 구조

```
project/
├── .work-shell/
│   ├── config.yaml      # 설정
│   ├── state.json       # 세션 상태
│   ├── routines.yaml    # 루틴 정의
│   ├── flows.yaml       # 플로우 정의
│   ├── sessions/        # 세션 로그
│   ├── logs/            # 일별 기록
│   ├── notes/           # 노트
│   ├── helpers/         # 커스텀 스크립트
│   ├── forks/           # 포크 상태
│   └── retros/          # 회고
├── work-shell.md        # 프로젝트 컨텍스트
└── .claude/
    ├── commands/        # 커맨드 링크
    └── settings.json    # 권한 설정
```

## 워크플로우 예시

```
> /hello
## work-shell 세션 시작

**2026-01-07 09:00** | Branch: `main`

### 환경 상태
- Remote: 2개 커밋 미수신
- Local: Clean

### 미완료 작업
- [ ] API 테스트 작성
- [ ] 문서 업데이트

### 제안
origin에서 새 커밋이 있어요. pull 할까요?

> 응 해줘

> /focus API 테스트 작성
## Focus 설정됨
> API 테스트 작성

> (작업...)

> /log 단위 테스트 3개 추가
체크포인트 저장됨 (09:30)

> /commit
## 커밋 완료
**abc1234** `test: API 단위 테스트 추가`

> /bye
## 세션 종료

**요약**: API 테스트 작성
**커밋**: 1개 | **파일**: 3개

다음에 또 만나요!
```

## 라이선스

MIT
