---
name: schedule-method
description: 업무일정 관리 작업의 표준 절차 — 태스크 보드 운영, 액션아이템 이관, WBS(PMBOK 100%·8/80 규칙), 마일스톤, MoSCoW 우선순위, 마감 임박·지연 보고. schedule 업무 작업자가 로드한다.
---

# 일정관리 방법론 (schedule-method)

## 관리 대상

- `workspace/50-schedule/tasks.md` — 전체 태스크 보드 (task-format §2 구조: 대기/진행중/완료/지연)
- `workspace/50-schedule/YYYY-MM-DD-<프로젝트>-wbs.md` — 프로젝트별 WBS·마일스톤

## 작업 절차

1. `doc-conventions`, `task-format`, 이 스킬을 로드한다
2. `tasks.md`가 없으면 task-format의 보드 구조로 새로 생성한다
3. 보드를 읽을 때마다 기한이 지난 미완료 항목을 `지연`으로 재분류한다
4. 회의록 이관 요청 시: 원본 회의록의 액션아이템을 보드 `대기`에 추가하고 `(출처: workspace/40-meetings/<파일>)`을 남긴다. 동일 항목은 중복 추가하지 않는다
5. "오늘 할 일" 요청 시: 마감 임박(3일 이내)·지연 항목을 우선순위로 정리해 보고한다

## 규칙

- 태스크 완료 처리는 사용자가 완료를 언급했을 때만 한다 (임의 완료 금지)
- WBS는 산출물 기준으로 쪼갠다 ("화면 정의서 v1" 같은 결과물 단위) — PMBOK 원칙:
  - **100% 규칙**: 하위 항목의 합 = 상위 항목의 전부
  - **8/80 규칙**: 최하위 항목은 대략 1일~2주 규모
  - 마일스톤은 기간이 아니라 **시점**(산출물 확정일)으로 정의한다
- 우선순위 판단이 필요하면 MoSCoW(Must/Should/Could/Won't)로 분류하고 근거를 한 줄 남긴다. 보고 시 Must를 먼저 제시한다
- front-matter: `agent: schedule` (보드 `status: 확정`, WBS `status: 초안`)
