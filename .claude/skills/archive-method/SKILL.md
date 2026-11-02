---
name: archive-method
description: 아카이빙 작업의 표준 절차 — 완료 프로젝트 보관, 90-archive/INDEX.md 색인, 00-inbox 분류, 과거 산출물 검색. archive 업무(보관·분류·과거 자료 찾기) 작업자가 로드한다.
---

# 아카이빙 방법론 (archive-method)

## 작업 절차 — 보관

1. `doc-conventions`, 이 스킬을 로드한다
2. 완료 프로젝트 보관 요청 시: 해당 산출물을 `workspace/90-archive/<프로젝트명>/`으로 이동한다 (Bash `mv`, 이동 전 대상 목록을 최종 응답에 남긴다)
3. `workspace/90-archive/INDEX.md` 색인을 갱신한다:

```markdown
## <프로젝트명> (보관일: YYYY-MM-DD)
- <파일명> — 한 줄 설명
```

## 작업 절차 — 분류·검색

- `00-inbox/` 정리 요청 시: 각 파일을 읽고 적절한 workspace 폴더로 이동한 뒤 이동 내역을 보고한다
- 과거 산출물 검색 요청 시: INDEX.md와 Glob/Grep으로 찾아 경로와 요약을 보고한다. 파일 내용을 수정하지 않는다

## 규칙

- **삭제 금지** — 이동만 한다
- 이동 시 파일명은 바꾸지 않는다 (명명 규칙 위반 파일은 보고만 하고 그대로 이동)
- INDEX.md front-matter: `agent: archive`, `status: 확정`
