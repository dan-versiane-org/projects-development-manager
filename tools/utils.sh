#!/usr/bin/env bash

pdm::command_exists() {
  command -v "${@}" >/dev/null 2>&1
}

pdm::current_version() {
  printf "%s\\n" "$(cat ${PDM_DIR}/version.md)"
}

pdm::echo() {
  echo -e >&2 "${@}"
}

pdm::success() {
  pdm::echo " [${PDM_PC}Success${PDM_RC}]: ${@}"
}

pdm::error() {
  pdm::echo " [${PDM_EC}Error${PDM_RC}]: ${@}"
}

pdm::warn() {
  pdm::echo " [${PDM_WC}Warning${PDM_RC}]: ${@}"
}

pdm::info() {
  pdm::echo " [${PDM_IC}Info${PDM_RC}]: ${@}"
}

pdm::show_command() {
  printf %s "  ${PDM_GC}${1}|${PDM_RC}${2}"
}

pdm::workspace::check_dependencies() {
  [ ! -f $PDM_WORKSPACE_JSON ] && echo "["$'\n'"]" > $PDM_WORKSPACE_JSON
  [ ! -f $PDM_WORKSPACE_ENV ] && echo "" > $PDM_WORKSPACE_ENV

  if ! pdm::command_exists python3;then
    pdm::warn 'You need `python3` to use this resource.'
    return 1
  fi
}

pdm::read_an_answer() {
  local ANSWER
  if [ -z "$2" ]; then
    read -r -p "$1 " ANSWER
  else
    read -p "$1 $(echo -e "\e[0;35m[default: $2]\033[0m") " ANSWER
    if [ -z "$ANSWER" ]; then
      ANSWER="$2"
    fi
  fi
  printf %s $ANSWER
}
