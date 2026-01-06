# work-shell

Claude Code 세션 관리 및 작업 기록 도구

## 개요

work-shell은 Claude Code와 함께 사용하는 생산성 도구입니다. 작업 세션을 관리하고, 진행 상황을 기록하며, 컨텍스트를 유지합니다.

## 설치

```bash
# Claude Code 설정 디렉토리에 심볼릭 링크 생성
ln -s /path/to/work-shell ~/.claude/commands/work-shell
```

또는 프로젝트에 직접 복사:
```bash
cp -r work-shell/commands/ your-project/.claude/commands/
```

## 사용법

### 세션 시작

```
/hello
```
또는
```
/안녕
```

- 이전 세션 컨텍스트 로드
- 미완료 작업 표시
- Git 상태 확인

### 중간 기록

```
/log JWT 대신 세션 쿠키 사용 결정
```
또는
```
/기록 API 설계 완료
```

- 결정 사항 기록
- 진행 상황 체크포인트
- 나중에 참조할 메모

### 세션 종료

```
/bye
```
또는
```
/바이
```

- 세션 요약 생성
- 작업 내용 저장
- 다음 할 일 정리

## 디렉토리 구조

프로젝트에 work-shell 활성화 시:

```
your-project/
├── .work-shell/
│   ├── config.yaml      # 설정
│   ├── state.json       # 현재 상태
│   ├── sessions/        # 세션 로그
│   └── logs/            # 일별 기록
└── work-shell.md        # 프로젝트 컨텍스트
```

## 설정

`.work-shell/config.yaml`:

```yaml
git:
  auto_commit: false      # /bye 시 자동 커밋
  commit_prefix: "chore(work-shell):"

session:
  auto_pause_minutes: 30  # 비활성 시 자동 일시정지

logging:
  include_git_status: true
  include_timestamps: true
```

## 워크플로우 예시

```
$ claude

> /hello
안녕하세요! work-shell 세션을 시작합니다.

마지막 세션 (어제):
- 사용자 인증 모듈 구현
- 브랜치: feature/auth

미완료 작업:
- [ ] 단위 테스트 작성

무엇을 도와드릴까요?

> (작업 진행...)

> /log 로그인 API 완성, 테스트 통과
체크포인트 저장됨 (14:35)

> (더 많은 작업...)

> /bye
세션을 종료합니다.

이번 세션:
- 커밋: 3개
- 변경 파일: 5개

저장 완료:
- .work-shell/sessions/2026-01-07-T1430.md

다음에 또 만나요!
```

## 라이선스

MIT
