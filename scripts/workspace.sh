#!/usr/bin/bash

PDM_WORKSPACE_SCRIPTS="$PDM_DIR/scripts/workspace"
PDM_WORKSPACE_JSON="$PDM_DIR/data/workspace.json"

workspace_check_dependencies() {
  if ! pdm_has_package python3;then
    pdm_warning 'You need `python3` to use this resource.'
    return 1
  fi
}

workspace_check_dependencies || exit 1

[ ! -f $PDM_WORKSPACE_JSON ] && echo "["$'\n'"]" > $PDM_WORKSPACE_JSON
[ ! -f $PDM_WORKSPACE_CONF ] && echo "" > $PDM_WORKSPACE_CONF

workspace_commands() {
  echo "$(pdm_show_command 'create' 'Create a new workspace')"
  echo "$(pdm_show_command 'current' 'Shows the current workspace')"
  echo "$(pdm_show_command 'delete' 'Delete a workspace')"
  echo "$(pdm_show_command 'edit' 'Edit a workspace')"
  echo "$(pdm_show_command 'help' 'Show this help')"
  echo "$(pdm_show_command 'list' 'Show all workspaces')"
  echo "$(pdm_show_command 'set' 'Set a workspace current')"
}

workspace_get_info() {
  local workspace=$1
  _NAME="$1" _CONF="$PDM_WORKSPACE_JSON" python3 $PDM_WORKSPACE_SCRIPTS/info.py
}

handle_workspace_help() {
  echo -e " ${PDM_TC}Usage:${PDM_RC}"
  echo -e "${PDM_SPACE}${PDM_PC}${PDM_SETUP_NAME} workspace ${PDM_GC}[command]${PDM_RC}"$'\n'
  echo -e " ${PDM_TC}Available commands:${PDM_RC}"
  echo -e "$(workspace_commands)" | column -t -s "|"
}

handle_workspace_create() {
  local _ROOT="${PDM_WORKSPACE_DIR}/${1}"
  local _CONF="$PDM_WORKSPACE_JSON"

  mkdir -p "$_ROOT"

  _NAME="$1" \
    _ROOT="$_ROOT" \
    _CONF="$_CONF" \
    python3 "$PDM_WORKSPACE_SCRIPTS/create.py" >&2

  local result=$?

  if [ $result -eq 0 ]; then
    pdm_success "Added ${PDM_PC}${1}${PDM_RC} to workspaces."
    pdm_has_current_workspace || handle_workspace_set $1
    exit 0
  elif [ $result -eq 2 ]; then
    pdm_error "The workspace name ${PDM_PC}${1}${PDM_RC} already exists."
    exit 1
  elif [ $result -eq 3 ]; then
    pdm_error "The workspace root path ${PDM_PC}${_ROOT}${PDM_RC} already exists."
    exit 1
  fi
}

handle_workspace_current() {
  if ! pdm_has_current_workspace; then
    pdm_error "No workspace is currently set."
    exit 1
  fi

  echo >&2 "Workspace: ${PDM_WORKSPACE_CURRENT_NAME}"
  echo >&2 "Root path: ${PDM_WORKSPACE_CURRENT_ROOT}"
}

handle_workspace_delete() {
  echo >&2 "delete"
}

handle_workspace_edit() {
  echo >&2 "edit"
}

handle_workspace_list() {
  echo >&2 ""
  echo -e "$(_CONF="$PDM_WORKSPACE_JSON" python3 "$PDM_WORKSPACE_SCRIPTS/list.py")" | column -t -s "|" >&2
  echo >&2 ""
}

handle_workspace_set() {
  local result_info=$(workspace_get_info $1)

  oIFS="$IFS"
  local result=()
  IFS="|" read -a result <<< "$result_info"
  IFS="$oIFS"

  echo >&2 "PDM_WORKSPACE_CURRENT_NAME=\"${result[0]}\"" > $PDM_WORKSPACE_CONF
  echo >&2 "PDM_WORKSPACE_CURRENT_ROOT=\"${result[1]}\"" >> $PDM_WORKSPACE_CONF

  pdm_success "Setted workspace to ${PDM_PC}${1}${PDM_RC}."
}
