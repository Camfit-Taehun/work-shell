---
description: work-shell 플러그인 버전 확인
argument-hint:
allowed-tools: [Read, Bash]
---

# ws-version - 플러그인 버전 확인

work-shell 플러그인의 현재 버전과 설치 정보를 표시합니다.

## 1. 버전 정보 수집

플러그인 설치 위치를 확인하고 plugin.json에서 버전을 읽습니다:

```bash
# 가능한 설치 위치
# 1. 마켓플레이스: ~/.claude/plugins/cache/camfit-plugins/work-shell/
# 2. 로컬: ~/.claude/plugins/local/work-shell/
# 3. 프로젝트: .claude/plugins/work-shell/
```

## 2. 출력 형식

```
## work-shell 버전 정보

**버전**: v{version}
**설치 위치**: {path}
**설치 방식**: {marketplace|local|project}

### 커맨드 목록
- /ws-hello, /ws-bye, /ws-log, ...
- 총 {N}개 커맨드

### 업데이트
- 최신 버전 확인: `/ws-update --check`
- 업데이트: `/ws-update`

**GitHub**: https://github.com/Camfit-Taehun/work-shell
```

## 3. 실행

Read the plugin.json from the plugin installation directory and display version info.
