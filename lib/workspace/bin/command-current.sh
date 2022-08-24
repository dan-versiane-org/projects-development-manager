#!/usr/bin/env bash

source "${PDM_DIR}/cache/workspace.env"

pdm_workspace_current_name="$(pdm::workspace::current_name)"
pdm_workspace_current_path="$(pdm::workspace::current_path)"

if [ -z "${pdm_workspace_current_name}" ]; then
  pdm::warn "No workspace is currently set."
  exit 2
fi

echo
pdm::echo "Workspace: ${PDM_PC}${pdm_workspace_current_name}${PDM_RC}"
pdm::echo "Root path: ${PDM_PC}${pdm_workspace_current_path}${PDM_RC}"

unset pdm_workspace_current_name pdm_workspace_current_root
