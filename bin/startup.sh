#!/usr/bin/bash

source "$PDM_DEVELOP_DIR/.env"

do_exec_command() {
  local command="$1.sh"
  shift
}

do_exec_command $@
