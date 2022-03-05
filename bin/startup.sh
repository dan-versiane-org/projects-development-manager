#!/usr/bin/bash

source "$PDM_DIR/.env"
source "$PDM_DIR/configs/path.env"

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

  shift 2
  $command $@
}

do_exec_command $@
