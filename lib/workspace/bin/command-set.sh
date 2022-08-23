#!/usr/bin/env bash

PDM_WORKSPACE_SCRIPTS="${PDM_DIR}/lib/workspace/scripts"
PDM_WORKSPACE_JSON="${PDM_DIR}/cache/workspace.json"
PDM_WORKSPACE_ENV="${PDM_DIR}/cache/workspace.env"

pdm::workspace::check_dependencies

workspace::get_info() {
  local workspace=$1
  _NAME="$1" _CONF="$PDM_WORKSPACE_JSON" python3 $PDM_WORKSPACE_SCRIPTS/info.py
}

workspace::set() {
  local result_info=$(workspace::get_info $1)
  local result=()

  IFS="|" read -a result <<< "$result_info"

  echo "PDM_WORKSPACE_CURRENT_NAME=\"${result[0]}\"" > $PDM_WORKSPACE_ENV
  echo "PDM_WORKSPACE_CURRENT_ROOT=\"${result[1]}\"" >> $PDM_WORKSPACE_ENV

  pdm::success "Setted workspace to ${PDM_PC}${1}${PDM_RC}."
}

workspace::set $@
unset PDM_WORKSPACE_SCRIPTS PDM_WORKSPACE_JSON PDM_WORKSPACE_ENV
