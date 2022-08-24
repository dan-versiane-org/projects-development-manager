#!/usr/bin/env bash

pdm::workspace::check_dependencies

workspace::list() {
  echo >&2
  echo -e "$(_CONF="${PDM_DIR}/cache/workspace.json" python3 "${PDM_DIR}/lib/workspace/scripts/list.py")" | column -t -s "|" >&2
}

workspace::list
