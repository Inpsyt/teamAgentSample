#!/bin/bash
# workspace 산출물 형식 게이트 (doc-conventions §1 명명 규칙 · §3 front-matter)
# PostToolUse(Write|Edit) hook — 위반 시 decision:block으로 작성 에이전트에 즉시 피드백.
# '## 요약' 등 내용 규칙은 유형별 예외가 있어 review 에이전트가 담당한다.

input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_response.filePath // empty')

[ -z "$file" ] && exit 0

# workspace 아래 .md만 검사
case "$file" in
  */workspace/*.md) ;;
  *) exit 0 ;;
esac

# 예외: 보드·색인·안내 파일, 00-inbox 임시 자료
base=$(basename "$file")
case "$base" in
  README.md|INDEX.md|tasks.md) exit 0 ;;
esac
case "$file" in
  */workspace/00-inbox/*) exit 0 ;;
esac

[ -f "$file" ] || exit 0

errors=""

# §1 명명 규칙: YYYY-MM-DD-<주제>.md
if ! [[ "$base" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-.+\.md$ ]]; then
  errors+="- 명명 규칙 위반: 'YYYY-MM-DD-<주제>.md' 형식이어야 합니다 (현재: ${base})"$'\n'
fi

# §3 front-matter: '---'로 시작 + title/agent/status/related 키
if [ "$(head -n 1 "$file")" != "---" ]; then
  errors+="- front-matter 누락: 파일 첫 줄이 '---'여야 합니다"$'\n'
else
  fm=$(awk 'NR==1{next} /^---$/{exit} {print}' "$file")
  for key in title agent status related; do
    if ! printf '%s\n' "$fm" | grep -q "^${key}:"; then
      errors+="- front-matter에 '${key}:' 항목이 없습니다"$'\n'
    fi
  done
fi

if [ -n "$errors" ]; then
  reason="[형식 게이트] doc-conventions 위반 — ${file}
${errors}doc-conventions 스킬(§1 명명 규칙, §3 front-matter)에 맞게 파일을 수정하세요."
  jq -n --arg r "$reason" '{decision: "block", reason: $r}'
fi
exit 0
