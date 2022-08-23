#!/usr/bin/env bash

source "${PDM_DIR}/cache/workspace.env"

if [ -z "${PDM_WORKSPACE_CURRENT_NAME}" ]; then
  pdm::warn "No workspace is currently set."
  exit 2
fi

echo
pdm::echo "Workspace: ${PDM_PC}${PDM_WORKSPACE_CURRENT_NAME}${PDM_RC}"
pdm::echo "Root path: ${PDM_PC}${PDM_WORKSPACE_CURRENT_ROOT}${PDM_RC}"

unset PDM_WORKSPACE_CURRENT_NAME PDM_WORKSPACE_CURRENT_ROOT
