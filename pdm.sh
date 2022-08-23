export PDM_DIR="${PDM_DIR:-"${HOME}/.pdm"}"
export PDM_WORKSPACE_DIR="${PDM_WORKSPACE_DIR:-"${HOME}/workspaces"}"

PDM_BIN="${PDM_DIR}/bin"
PATH="${PDM_BIN}:${PATH}"

unset PDM_BIN
