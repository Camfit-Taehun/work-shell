# Fork Context: {name}

> 이 파일은 fork 세션 시작 시 자동으로 로드됩니다.
> Claude Code가 .claude/ 디렉토리의 이 파일을 읽어 컨텍스트를 복원합니다.

## Fork 정보

- **이름**: {name}
- **생성**: {timestamp}
- **부모 세션**: {parent_session_id}
- **Git Branch**: {git_branch}
- **목적**: {fork_purpose}

---

## 이전 세션 컨텍스트

### 작업 중이던 것

{what_we_were_working_on}

### 결정 사항

{decisions_made}

### 시도한 것들

{what_was_tried_and_results}

### 현재 이해

{current_understanding}

---

## Fork 탐색 방향

{exploration_direction}

---

## 참고 사항

{additional_notes}

---

*이 컨텍스트를 바탕으로 작업을 계속하세요.*
*작업 완료 후 `/ws-fork merge {name}` 으로 결과를 메인 세션에 병합하세요.*
