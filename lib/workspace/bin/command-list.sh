#!/usr/bin/env bash

PDM_WORKSPACE_SCRIPTS="${PDM_DIR}/lib/workspace/scripts"
PDM_WORKSPACE_JSON="${PDM_DIR}/cache/workspace.json"

pdm::workspace::check_dependencies

workspace::list() {
  echo >&2
  echo -e "$(_CONF="$PDM_WORKSPACE_JSON" python3 "$PDM_WORKSPACE_SCRIPTS/list.py")" | column -t -s "|" >&2
}

workspace::list
unset PDM_WORKSPACE_SCRIPTS PDM_WORKSPACE_JSON
