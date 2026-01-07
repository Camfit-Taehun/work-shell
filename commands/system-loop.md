---
name: loop
description: Run a pipeline task repeatedly for a specified duration without user interaction
arguments:
  - name: task
    description: The task or pipeline to execute (can be a command name or task description)
    required: true
  - name: duration
    description: "Duration to run (e.g., '30m', '2h', '1d') or iteration count (e.g., '10x')"
    required: true
  - name: interval
    description: "Interval between runs (e.g., '5m', '30s'). Default: immediate"
    required: false
---

# Loop Command - 장기 반복 실행

사용자 입력 없이 지정된 기간 동안 파이프라인 작업을 자동으로 반복 실행합니다.

## 실행 모드

**중요**: 이 명령은 자동화 모드로 실행됩니다:
- 사용자 확인을 요청하지 않음
- 에러 발생 시 자동으로 재시도
- 진행 상황을 로그에 기록

## 파라미터 해석

1. **duration 파싱**:
   - `30m` = 30분 동안 실행
   - `2h` = 2시간 동안 실행
   - `1d` = 1일 동안 실행
   - `10x` = 10회 반복 실행

2. **interval 파싱** (선택):
   - `5m` = 5분 간격
   - `30s` = 30초 간격
   - 생략 시 = 즉시 다음 반복

## 실행 프로세스

```
1. 파라미터 검증 및 파싱
2. 루프 시작 시간 기록
3. 반복 실행:
   a. 현재 반복 횟수 및 경과 시간 로깅
   b. 태스크 실행
   c. 결과 기록
   d. interval만큼 대기 (설정된 경우)
   e. 종료 조건 확인 (시간/횟수)
4. 완료 요약 출력
```

## 태스크 실행

주어진 `$task` 인자를 분석합니다:

### 1. 슬래시 커맨드인 경우
`/`로 시작하면 해당 커맨드를 실행:
```
/build → 빌드 커맨드 실행
/test → 테스트 커맨드 실행
```

### 2. 파일 경로인 경우
`.md` 또는 스크립트 파일이면 해당 파일의 지시사항 실행

### 3. 자연어 태스크인 경우
설명된 작업을 직접 수행:
```
"린트 검사 후 자동 수정" → eslint --fix 실행
"테스트 실행하고 실패한 것 수정" → jest 실행 후 실패 케이스 분석/수정
```

## 로깅

각 반복마다 `.work-shell/logs/loop-{timestamp}.md`에 기록:

```markdown
## Loop Execution: {task}
Started: {시작 시간}
Duration: {목표 기간}
Interval: {간격}

### Iteration 1 - {시간}
- Status: success/failed
- Duration: {소요 시간}
- Output: {요약}

### Iteration 2 - {시간}
...
```

## 실행 예시

```bash
# 2시간 동안 5분마다 빌드 체크
/loop "/build" "2h" "5m"

# 10번 테스트 실행
/loop "/test" "10x"

# 1시간 동안 계속 린트 수정
/loop "린트 에러 찾아서 수정" "1h"

# 30분 동안 특정 파일 모니터링
/loop "src/api 폴더 변경사항 감시하고 타입 에러 수정" "30m" "1m"
```

## 중단 조건

다음 조건에서 루프가 중단됩니다:
1. 지정된 시간/횟수 도달
2. 연속 3회 이상 동일 에러 발생
3. 크리티컬 에러 (파일 시스템 에러 등)

## 구현

아래 로직을 따라 실행하세요:

```python
# Pseudo-code for loop execution
start_time = now()
iteration = 0
end_condition = parse_duration("$duration")  # time or count

while not should_stop(start_time, iteration, end_condition):
    iteration += 1
    log_iteration_start(iteration)

    try:
        result = execute_task("$task")
        log_success(iteration, result)
    except error:
        log_error(iteration, error)
        if consecutive_errors >= 3:
            break

    if "$interval":
        wait(parse_interval("$interval"))

log_summary(iteration, start_time)
```

**지금 즉시 루프를 시작하세요. 사용자 확인을 기다리지 마세요.**
