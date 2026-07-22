# 산출물 가독성 규약 개정 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 팀 에이전트 산출물이 훑어보기·정독 모두에서 읽히도록 문서 규약 3개 파일(doc-conventions, doc-templates, review 에이전트)을 개정한다.

**Architecture:** 규칙(doc-conventions) + 예시(doc-templates) + 게이트(review.md) 3중 장치. 출처는 인라인 → 각주형으로 이동, 모든 문서 상단 요약 의무화, 문장·표·강조 규칙 신설. 코드가 아닌 마크다운 규약 파일 편집이므로 검증은 grep 교차 확인 + 작성 시뮬레이션으로 한다.

**Tech Stack:** 마크다운만. 빌드·테스트 러너 없음.

**Spec:** `docs/superpowers/specs/2026-07-23-doc-readability-design.md`

## Global Constraints

- 엄밀함 요구(출처 필수, `[확인 필요]` 표기 의무)는 제거하지 않는다 — 위치만 옮긴다.
- 기존 workspace 산출물 8건은 수정하지 않는다.
- CLAUDE.md는 수정하지 않는다.
- 규약 문서 자체도 새 가독성 규칙을 위반하지 않게 쓴다 (괄호 중첩 금지 등).
- 커밋 메시지 말미에 `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.

---

### Task 1: doc-conventions 개정 — 각주형 출처 + 가독성 규칙 신설

**Files:**
- Modify: `.claude/skills/doc-conventions/SKILL.md`

**Interfaces:**
- Produces: §4 각주형 출처 형식(`[1] <제목> — <경로/URL>`)과 §6 가독성 규칙. Task 2의 템플릿 예시와 Task 3의 review 검증 항목이 이 규칙 문구를 기준으로 삼는다.

- [ ] **Step 1: §4 출처 표기를 각주형으로 교체**

현재 §4 (교체 대상):

```markdown
## 4. 출처 표기

- 웹 자료: `[제목](URL) (접속일: YYYY-MM-DD)` 형식
- 내부 자료: `workspace/` 기준 상대 경로로 표기 (예: `workspace/10-research/2026-07-15-시장조사.md`)
- 확인되지 않은 내용은 본문에 **미확인**으로 명시한다
```

새 §4 (아래로 전체 교체):

```markdown
## 4. 출처 표기 (각주형)

- 본문에는 각주 번호만 남긴다. 예: `...레코드는 통합하지만 관계를 잃는 경우가 많다 [1].`
- 본문 문장 안에 파일 경로·URL을 직접 쓰지 않는다.
- 전체 경로·URL은 문서 말미 `## 출처` 섹션에 번호 목록으로만 표기한다:
  - 웹 자료: `[1] <제목> — <URL> (접속일: YYYY-MM-DD)`
  - 내부 자료: `[2] <제목> — workspace/10-research/2026-07-15-시장조사.md §a`
- 확인되지 않은 내용은 본문에 `[확인 필요]` 마커만 짧게 붙인다. 사유·후속 계획 등 긴 설명은 "미확인·추가 조사 필요" 섹션에 모은다.
```

- [ ] **Step 2: §5의 중복 문장 제거**

§6에서 모든 문서에 요약을 의무화하므로, §5의 아래 한 줄을 삭제한다:

```markdown
- 경영진 대상 요약은 서술형 요약을 문서 최상단에 먼저 배치
```

삭제 후 §5는 다음 두 줄만 남는다:

```markdown
## 5. 한국어 작성 원칙

- 개조식(불릿·표) 기본
- 약어 첫 등장 시 풀네임 병기
```

- [ ] **Step 3: §6 가독성 규칙 신설 (파일 말미에 추가)**

```markdown
## 6. 가독성 규칙

산출물은 30초 훑어보기와 정독 모두를 견뎌야 한다.

- **요약 우선**: front-matter 바로 아래 `## 요약` 섹션을 둔다 — 결론·핵심 근거·다음 액션 3줄. 모든 산출물 공통.
- 불릿 1개 = 1문장, 최대 2문장. 길어지면 하위 불릿으로 쪼갠다.
- 괄호 중첩 금지. 괄호 안 괄호를 쓰지 않고, 한 문장에 괄호는 1개까지. 부연이 길면 별도 문장으로 뺀다.
- 표 셀은 구절 단위. 셀에 2문장 이상이 필요하면 표 대신 소제목+불릿을 쓴다. 재현 절차·상세 근거는 표 아래 본문에 둔다.
- **볼드는 섹션당 최대 2회** — 결론에만 쓴다.
```

- [ ] **Step 4: 검증**

Run: `grep -n "상대 경로로 표기\|경영진 대상 요약" .claude/skills/doc-conventions/SKILL.md`
Expected: 출력 없음 (옛 규칙이 모두 제거됨)

Run: `grep -c "^## " .claude/skills/doc-conventions/SKILL.md`
Expected: `6` (섹션 §1~§6)

- [ ] **Step 5: Commit**

```bash
git add .claude/skills/doc-conventions/SKILL.md
git commit -m "feat: doc-conventions 각주형 출처·가독성 규칙(§6) 도입

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 2: doc-templates 개정 — 요약 의무화·각주 예시·QA 표 지침

**Files:**
- Modify: `.claude/skills/doc-templates/SKILL.md`

**Interfaces:**
- Consumes: Task 1의 §4 각주 형식·§6 요약 규격 (템플릿 예시가 이 형식을 그대로 보여줘야 함)
- Produces: 12개 템플릿의 개정판. Task 3의 review가 "템플릿 필수 섹션 누락" 검증 시 이 템플릿을 기준으로 삼는다.

- [ ] **Step 1: 공통 머리말 교체**

현재:

```markdown
모든 템플릿은 doc-conventions의 front-matter를 문서 최상단에 붙인 뒤 사용한다.
```

교체:

```markdown
모든 템플릿은 doc-conventions의 front-matter를 문서 최상단에 붙인 뒤 사용한다.
front-matter 바로 아래에는 `## 요약`을 둔다 — 결론·핵심 근거·다음 액션 3줄.
예외: 회의 아젠다는 머리말의 "목적"이 요약을 대신한다.
출처는 본문 각주 번호 `[1]` + 말미 `## 출처` 목록으로 표기한다 (doc-conventions §4).
```

- [ ] **Step 2: 요약 섹션이 없던 6개 템플릿에 `## 요약` 추가**

각 템플릿의 `# <제목>` 바로 다음 줄에 `## 요약 (3줄: 결론·근거·다음 액션)` 한 줄을 삽입한다. 대상과 삽입 위치:

1. **기획서**: `# <기획명>` 다음
2. **요구사항 정의서**: `# <프로젝트명> 요구사항 정의서` 다음
3. **회의록**: `# <회의명> 회의록` 다음 (`- 일시: ...` 줄보다 앞)
4. **화면 정의서**: `# <화면명> 화면 정의서` 다음 (`- 화면ID: ...` 줄보다 앞)
5. **IA 문서**: `# <서비스명> IA` 다음
6. **리뷰 노트**: `# <원문서 제목> 리뷰 노트` 다음 (`- 원문서: ...` 줄보다 앞)

기존에 요약이 있는 템플릿(제안서·리서치·경쟁분석·주간보고·경영진 요약·QA 리포트)은 섹션명을 유지하되, 리서치·경쟁분석의 `## 요약 (3~5줄)`을 `## 요약 (3줄: 결론·근거·다음 액션)`으로 통일한다.

- [ ] **Step 3: 출처·참고 자료 섹션을 각주형 예시로 교체**

기획서의 `## 참고 자료`, 리서치 보고서의 `## 출처`, 경쟁분석의 `## 출처`를 아래 형태로 교체한다 (제안서의 `## 참고 자료`도 동일):

```markdown
## 출처
[1] <제목> — <URL> (접속일: YYYY-MM-DD)
[2] <제목> — workspace/<경로> §<섹션>
```

기획서·제안서는 섹션명을 `## 참고 자료`에서 `## 출처`로 바꾸지 않고 유지하되, 내부 형식은 위 각주 목록과 동일하게 한다.

- [ ] **Step 4: QA 리포트 표에 셀 과밀 방지 지침 삽입**

높음·중간 표 아래에 지침 줄을 추가해 아래 형태로 만든다:

```markdown
## 🔴 높음

| 위치 | 현재 | 수정 제안 |
|---|---|---|

(셀은 증상·제안 요지 1~2구절만. 재현 절차·요청/응답 근거는 표 아래 불릿으로)
- 재현 절차: <단계 나열>
- 근거: <네트워크 응답·로그 등>

## 🟠 중간

| 위치 | 현재 | 수정 제안 |
|---|---|---|

(셀은 증상·제안 요지 1~2구절만. 상세는 표 아래 불릿으로)
```

- [ ] **Step 5: 검증**

Run: `grep -n "3~5줄" .claude/skills/doc-templates/SKILL.md`
Expected: 출력 없음

Run: `grep -c "요약" .claude/skills/doc-templates/SKILL.md`
Expected: 14 이상 (머리말 1 + 신규 6 + 기존 유지분)

Run: `grep -n "\[1\]" .claude/skills/doc-templates/SKILL.md`
Expected: 각주 예시가 기획서·제안서·리서치·경쟁분석 4곳에 존재

- [ ] **Step 6: Commit**

```bash
git add .claude/skills/doc-templates/SKILL.md
git commit -m "feat: doc-templates 요약 의무화·각주형 출처 예시·QA 표 지침 반영

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 3: review 에이전트에 가독성 게이트 추가

**Files:**
- Modify: `.claude/agents/review.md`

**Interfaces:**
- Consumes: Task 1 §6의 규칙 항목 (검증 관점 문구가 규칙과 1:1 대응해야 함)

- [ ] **Step 1: 검증 관점 목록에 가독성 항목 추가**

`review.md`의 "3. 다음 관점으로 검증한다:" 목록에서 `- **수치 일관성**: ...` 줄 다음에 아래 한 줄을 추가한다:

```markdown
   - **가독성**: 상단 `## 요약` 누락, 본문 인라인 전체 경로·URL 인용(각주형 위반), 표 셀 과밀(셀당 2문장 이상), 괄호 중첩 — 위반은 심각도 "하"로 지적한다
```

- [ ] **Step 2: 검증**

Run: `grep -n "가독성" .claude/agents/review.md`
Expected: 1건, 검증 관점 목록 안에 위치

- [ ] **Step 3: Commit**

```bash
git add .claude/agents/review.md
git commit -m "feat: review 에이전트 검증 관점에 가독성 게이트 추가

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 4: 교차 검증 + 작성 시뮬레이션 (파일 변경 없음)

**Files:**
- 읽기만: 위 3개 파일
- 임시 산출: 스크래치패드에 샘플 문서 1건 (커밋하지 않음)

**Interfaces:**
- Consumes: Task 1~3의 최종 상태

- [ ] **Step 1: 인라인 인용 잔재 교차 확인**

Run: `grep -n "workspace/" .claude/skills/doc-templates/SKILL.md .claude/skills/doc-conventions/SKILL.md`
Expected: 남은 매치가 전부 허용 위치인지 눈으로 확인 — 허용 위치는 (a) §2 저장 위치 표, (b) front-matter `related` 예시, (c) `## 출처` 각주 예시, (d) 회의 아젠다 "사전 참고 자료"·경영진 요약 "근거 자료"·리뷰 노트 "원문서" 같은 링크 전용 섹션. 본문 문장 안 경로가 남아 있으면 해당 Task로 돌아가 수정.

- [ ] **Step 2: 새 규약으로 미니 리서치 보고서 작성 시뮬레이션**

스크래치패드에 `sample-research.md`를 아래 내용으로 작성해 규칙 적용이 실제로 가능한지 확인한다:

```markdown
---
title: 샘플 — AI 회의록 도구 요금 조사
agent: research
status: 초안
related: []
---

# AI 회의록 도구 요금 조사

## 요약 (3줄: 결론·근거·다음 액션)
- 결론: 주요 3사 요금은 인당 월 $10~18 밴드에 수렴한다.
- 근거: 3사 공식 요금 페이지 실측 [1][2] — 국내 부가세 포함가는 [확인 필요].
- 다음 액션: 파일럿 대상 1개 도구 선정 후 2주 무료 체험.

## 조사 결과
- A사 Pro는 인당 월 $10이다 [1].
- B사 Business는 인당 월 $18이며 연 결제 기준이다 [2].

## 미확인·추가 조사 필요 항목
- 국내 결제 시 부가세 포함 여부 — 각사 셀프서브 결제 화면까지 진입해야 확인 가능, 다음 조사에서 실측 예정.

## 출처
[1] A사 요금 안내 — https://example.com/a/pricing (접속일: 2026-07-23)
[2] B사 요금 안내 — https://example.com/b/pricing (접속일: 2026-07-23)
```

체크리스트로 확인: 요약 3줄 규격 ✓ / 본문 각주 번호만 ✓ / `[확인 필요]` 마커 짧게 + 상세는 미확인 섹션 ✓ / 괄호 중첩 없음 ✓ / 볼드 남용 없음 ✓. 어긋나는 규칙이 있으면 규약 문구를 수정하고 해당 Task를 재커밋한다.

- [ ] **Step 3: 샘플 파일 삭제**

Run: 스크래치패드의 `sample-research.md` 삭제 (workspace·저장소에 남기지 않음)
