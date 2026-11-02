---
name: task-format
description: 태스크·액션아이템 규약 — 액션아이템 표기 형식, workspace/50-schedule/tasks.md 태스크 보드 구조, 회의록 액션아이템의 보드 이관 규칙. meeting·schedule 업무 작업자가 로드한다.
---

# 태스크·액션아이템 규약 (task-format)

## 1. 액션아이템 형식

```markdown
- [ ] <내용> @담당자 ~YYYY-MM-DD #프로젝트
```

- 담당자 미정이면 `@미정`, 기한 미정이면 `~미정`, 프로젝트 무관이면 `#일반`
- 완료 시 `- [x]`로 변경하고 뒤에 `(완료: YYYY-MM-DD)` 추가

## 2. 태스크 보드 (`workspace/50-schedule/tasks.md`)

```markdown
---
title: 태스크 보드
agent: schedule
status: 확정
related: []
---
# 태스크 보드
## 대기
## 진행중
## 완료
## 지연
```

- 태스크는 항상 위 4개 섹션 중 하나에만 존재한다
- `지연` = 기한(`~날짜`)이 오늘보다 과거인데 미완료인 항목. schedule 작업자가 보드를 읽을 때마다 재분류한다
- 보드 파일이 없으면 schedule 작업자가 위 구조로 새로 생성한다

## 3. 회의록 → 보드 이관 규칙

- meeting 작업자가 회의록의 "액션아이템" 섹션을 이 형식으로 기록한다
- 이관 작업은 작업자 간 직접 호출이 아니라 PM(메인 세션)이 meeting 작업 완료 후 schedule 작업을 순차 위임하여 수행한다
- schedule 작업자는 이관 시 원본 회의록 경로를 태스크 뒤에 `(출처: workspace/40-meetings/<파일>)`로 남긴다
- 이미 보드에 있는 동일 항목은 중복 추가하지 않는다
