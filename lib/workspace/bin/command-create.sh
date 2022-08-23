#!/usr/bin/env bash

PDM_WORKSPACE_SCRIPTS="${PDM_DIR}/lib/workspace/scripts"
PDM_WORKSPACE_JSON="${PDM_DIR}/cache/workspace.json"
PDM_WORKSPACE_ENV="${PDM_DIR}/cache/workspace.env"

pdm::workspace::check_dependencies

workspace::create() {
  local _ROOT="${PDM_WORKSPACE_DIR}/${1}"
  local _CONF="$PDM_WORKSPACE_JSON"

  mkdir -p "$_ROOT"

  _NAME="$1" \
    _ROOT="$_ROOT" \
    _CONF="$_CONF" \
    python3 "${PDM_WORKSPACE_SCRIPTS}/create.py" >&2

  local result=$?

  if [ $result -eq 0 ]; then
    pdm::success "Added ${PDM_PC}${1}${PDM_RC} to workspaces."
    exit 0
  elif [ $result -eq 2 ]; then
    pdm::warn "The workspace name ${PDM_PC}${1}${PDM_RC} already exists."
    exit 2
  elif [ $result -eq 3 ]; then
    pdm::warn "The workspace root path ${PDM_PC}${_ROOT}${PDM_RC} already exists."
    exit 2
  fi
}

workspace::create $@
unset PDM_WORKSPACE_SCRIPTS PDM_WORKSPACE_JSON PDM_WORKSPACE_ENV
