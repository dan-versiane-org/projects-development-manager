#!/usr/bin/env bash

pdm::workspace::check_dependencies

workspace::get_info() {
  local workspace=$1
  _NAME="$1" _CONF="${PDM_DIR}/cache/workspace.json" python3 "${PDM_DIR}/lib/workspace/scripts/info.py"
}

workspace::set() {
  local result_info=$(workspace::get_info $1)
  local result=()

  IFS="|" read -a result <<< "$result_info"

  if [ -z ${result[0]} ]; then
    pdm::error "There is no workspace created with name ${PDM_PC}${1}${PDM_RC}."
    return 1
  fi

  echo "PDM_WORKSPACE_CURRENT_NAME=\"${result[0]}\"" > "${PDM_DIR}/cache/workspace.env"
  echo "PDM_WORKSPACE_CURRENT_ROOT=\"${result[1]}\"" >> "${PDM_DIR}/cache/workspace.env"

  pdm::success "Setted workspace to ${PDM_PC}${1}${PDM_RC}."
}

workspace::set $@
