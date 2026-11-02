#!/bin/bash
# workspace 산출물 형식 게이트 (doc-conventions §1 명명 규칙 · §3 front-matter)
# PostToolUse(Write|Edit) hook — 위반 시 decision:block으로 작성 에이전트에 즉시 피드백.
# '## 요약' 등 내용 규칙은 유형별 예외가 있어 review 에이전트가 담당한다.

input=$(cat)

# jq가 없으면(기획자 PC·윈도우) 조용히 건너뛰지 않고 간이 파서 + 경고로 동작한다.
if command -v jq >/dev/null 2>&1; then
  has_jq=1
  file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_response.filePath // empty')
else
  has_jq=0
  file=$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 \
    | sed -e 's/^"file_path"[[:space:]]*:[[:space:]]*"//' -e 's/"$//' -e 's/\\\\/\\/g')
fi

# JSON 문자열 이스케이프 (jq 의존 없이 출력하기 위함)
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | awk '{ if (NR > 1) printf "%s", "\\n"; printf "%s", $0 }'
}

# 출력: decision(block)·reason·systemMessage를 jq 유무와 무관하게 JSON으로 낸다
emit() {
  local decision="$1" reason="$2" sysmsg="$3" out="{"
  [ -n "$decision" ] && out+="\"decision\":\"${decision}\",\"reason\":\"$(json_escape "$reason")\""
  if [ -n "$sysmsg" ]; then
    [ "$out" != "{" ] && out+=","
    out+="\"systemMessage\":\"$(json_escape "$sysmsg")\""
  fi
  printf '%s}\n' "$out"
}

[ -z "$file" ] && exit 0

# 윈도우 경로(C:\...)를 슬래시로 정규화
file="${file//\\//}"

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

warn=""
if [ "$has_jq" = 0 ]; then
  warn="[형식 게이트] jq 미설치 — 형식 검사 대체 모드(간이 파서)로 동작 중입니다. 정확한 검사를 위해 jq 설치를 권장합니다 (winget install jqlang.jq / brew install jq)."
fi

if [ -n "$errors" ]; then
  reason="[형식 게이트] doc-conventions 위반 — ${file}
${errors}doc-conventions 스킬(§1 명명 규칙, §3 front-matter)에 맞게 파일을 수정하세요."
  emit block "$reason" "$warn"
elif [ -n "$warn" ]; then
  emit "" "" "$warn"
fi
exit 0
