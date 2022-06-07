#!/usr/bin/bash

## Sets the variables
PDM_SCRIPTS_DIR="$PDM_DIR/scripts"
PDM_WORKSPACE_CONF="${PDM_DIR}/data/workspace.config"

## Loads them PDM utils
source "$PDM_DIR/utils.sh"
[ -f "$PDM_WORKSPACE_CONF" ] && source "$PDM_WORKSPACE_CONF"

do_exec_command() {
  local script="$PDM_SCRIPTS_DIR/$1.sh"

  if [ ! -f $script ];then
    pdm_error "${PDM_PC}${1}${PDM_RC} script not be found."
    exit 1
  fi

  source $script
  command="handle_${1}_${2}"

  if ! type $command &> /dev/null;then
    pdm_error "${PDM_PC}${1} ${2}${PDM_RC} command not be found."
    exit 1
  fi

  $command ${@:3:$#}
}

do_exec_command $@
