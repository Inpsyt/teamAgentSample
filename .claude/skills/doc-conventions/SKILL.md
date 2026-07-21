---
name: doc-conventions
description: 기획업무 산출물의 문서 규약 — 명명 규칙, 저장 위치, front-matter, 출처 표기, 한국어 작성 원칙. 모든 팀 에이전트가 산출물 작성 전에 로드한다.
---

# 문서 규약 (doc-conventions)

모든 산출물 마크다운 파일은 아래 규약을 따른다.

## 1. 명명 규칙

- 형식: `YYYY-MM-DD-<주제>.md` (예: `2026-07-21-경쟁사-요금제-비교.md`)
- 주제는 한국어 가능, 공백 대신 하이픈(`-`) 사용
- 동일 주제 파일이 이미 존재하면 덮어쓰지 않고 `-v2`, `-v3` 접미사로 새 버전 생성

## 2. 저장 위치

| 산출물 유형 | 폴더 |
|---|---|
| 리서치·벤치마킹 보고서 | `workspace/10-research/` |
| 기획서·제안서·요구사항서 초안 | `workspace/20-drafts/` |
| 취합 데이터·표 | `workspace/30-data/` |
| 회의 아젠다·회의록 | `workspace/40-meetings/` |
| 일정·WBS·태스크 보드 | `workspace/50-schedule/` |
| IA·화면 정의서·유저 플로우 | `workspace/60-web-planning/` |
| 주간보고·요약본 | `workspace/70-reports/` |
| 완료 프로젝트 보관 | `workspace/90-archive/` |

## 3. front-matter (모든 산출물 필수)

```yaml
---
title: <문서 제목>
agent: <작성 에이전트 이름 (research/benchmark/draft/data/meeting/schedule/web-planning/report/archive)>
status: 초안 | 검토중 | 확정
related:
  - <관련 문서 상대 경로 (없으면 빈 목록)>
---
```

## 4. 출처 표기

- 웹 자료: `[제목](URL) (접속일: YYYY-MM-DD)` 형식
- 내부 자료: `workspace/` 기준 상대 경로로 표기 (예: `workspace/10-research/2026-07-15-시장조사.md`)
- 확인되지 않은 내용은 본문에 **미확인**으로 명시한다

## 5. 한국어 작성 원칙

- 개조식(불릿·표) 기본
- 경영진 대상 요약은 서술형 요약을 문서 최상단에 먼저 배치
- 약어 첫 등장 시 풀네임 병기
