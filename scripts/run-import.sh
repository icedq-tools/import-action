#!/usr/bin/env bash
set -euo pipefail

# Build the icedq import command from env vars set by action.yml.
ARGS=(
  "import"
  "--bundle" "${BUNDLE}"
  "--kind" "${KIND}"
  "--mapping-file" "${MAPPING_FILE}"
  "--timeout" "${TIMEOUT}"
  "--retain-log" "icedq-import.log"
  "--output" "json"
)

if [[ "${USE_FQN:-false}" == "true" ]]; then
  ARGS+=("--use-fqn")
fi
if [[ "${STRICT:-true}" == "true" ]]; then
  ARGS+=("--strict")
fi
if [[ "${TERMINATE_ON_CONFLICT:-false}" == "true" ]]; then
  ARGS+=("--terminate-on-conflict")
fi

# Capture stdout (JSON) and stderr (logs + task-id) separately.
TMP_JSON="$(mktemp)"
TMP_ERR="$(mktemp)"
set +e
icedq "${ARGS[@]}" >"${TMP_JSON}" 2>"${TMP_ERR}"
EXIT_CODE=$?
set -e

# Echo the CLI's stderr to the action log so users can see what happened.
cat "${TMP_ERR}" >&2

# Try to surface task-id and parsed result fields as Action outputs.
TASK_ID="$(grep -oE 'task-id:[[:space:]]*[^[:space:]]+' "${TMP_ERR}" | head -1 | awk '{print $2}' || true)"
if command -v jq >/dev/null 2>&1; then
  STATUS="$(jq -r '.status // empty' "${TMP_JSON}" 2>/dev/null || true)"
  SKIPPED="$(jq -r '.skippedCount // 0' "${TMP_JSON}" 2>/dev/null || echo 0)"
else
  STATUS="$(node -e "try{console.log(JSON.parse(require('fs').readFileSync('${TMP_JSON}','utf8')).status||'')}catch(e){}")"
  SKIPPED="$(node -e "try{console.log(JSON.parse(require('fs').readFileSync('${TMP_JSON}','utf8')).skippedCount||0)}catch(e){console.log(0)}")"
fi

{
  echo "task-id=${TASK_ID:-}"
  echo "status=${STATUS:-Unknown}"
  echo "skipped-count=${SKIPPED:-0}"
} >>"${GITHUB_OUTPUT}"

# Append a markdown summary to the workflow run.
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  {
    echo "## iceDQ import"
    echo ""
    echo "- **Status:** ${STATUS:-Unknown}"
    echo "- **Task ID:** \`${TASK_ID:-n/a}\`"
    echo "- **Skipped rules:** ${SKIPPED:-0}"
    echo "- **Bundle:** \`${BUNDLE}\`"
    echo "- **Workspace:** \`${ICEDQ_WORKSPACE_ID}\`"
  } >>"${GITHUB_STEP_SUMMARY}"
fi

# Echo CLI stdout JSON for downstream debugging.
cat "${TMP_JSON}"

exit "${EXIT_CODE}"
