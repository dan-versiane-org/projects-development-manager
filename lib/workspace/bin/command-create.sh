#!/usr/bin/env bash

pdm::workspace::check_dependencies

workspace::create() {
  mkdir -p "${PDM_WORKSPACE_DIR}/${1}"

  _NAME="$1" \
    _ROOT="${PDM_WORKSPACE_DIR}/${1}" \
    _CONF="${PDM_DIR}/cache/workspace.json" \
    python3 "${PDM_DIR}/lib/workspace/scripts/create.py" >&2

  local result=$?

  if [ $result -eq 0 ]; then
    pdm::success "Added ${PDM_PC}${1}${PDM_RC} to workspaces."
    exit 0
  elif [ $result -eq 2 ]; then
    pdm::warn "The workspace name ${PDM_PC}${1}${PDM_RC} already exists."
    exit 2
  elif [ $result -eq 3 ]; then
    pdm::warn "The workspace root path ${PDM_PC}${PDM_WORKSPACE_DIR}/${1}${PDM_RC} already exists."
    exit 2
  fi
}

workspace::create $@
