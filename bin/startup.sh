#!/usr/bin/bash

## Loads the PDM environment
source "${PDM_DIR}/.env"

## Sets the variables
PDM_SCRIPTS_DIR="$PDM_DIR/scripts"
PDM_WORKSPACE_CONF="${PDM_DIR}/data/workspace.config"

## Loads them PDM utils
source "$PDM_DIR/utils.sh"
[ -f "$PDM_WORKSPACE_CONF" ] && source "$PDM_WORKSPACE_CONF"

do_exec_command() {
  local script="$PDM_SCRIPTS_DIR/$1.sh"

  if [ ! -f $script ];then
    echo -e " [\e[1;31mError\e[0m]: \e[1;35m${1}\e[0m command not be found."
    exit 1
  fi

  source $script
  command="handle_${1}_${2}"

  if ! type $command &> /dev/null;then
    echo -e " [\e[1;31mError\e[0m]: \e[1;35m${1} ${2}\e[0m could not be found."
    exit 1
  fi

  $command ${@:3:$#}
}

do_exec_command $@
