#!/usr/bin/bash

## Sets the variables
PDM_SCRIPTS_DIR="$PDM_DIR/scripts"
PDM_SPACE="  "
PDM_ECHO_SPACE=" "

## Sets the colors variables
PDM_PC="\e[1;35m" # Primary Color
PDM_EC="\e[1;31m" # Error Color
PDM_WC="\e[1;33m" # Warning Color
PDM_IC="\e[1;34m" # Info Color
PDM_GC="\e[0;32m" # Green Color
PDM_TC="\e[4;33m" # Title Color
PDM_RC="\e[0m" # Reset Color

pdm_has_package() {
  type "$1" > /dev/null 2>&1
}

pdm_current_version() {
  printf %s $(cat $PDM_DIR/version.md)
}

pdm_latest_version() {
  printf %s $(curl -o- -s https://raw.githubusercontent.com/danielversiane13/projects-development-manager/main/version.md)
}

pdm_success() {
  echo -e >&2 "${PDM_ECHO_SPACE}[${PDM_PC}Success${PDM_RC}]: $1"
}

pdm_error() {
  echo -e >&2 "${PDM_ECHO_SPACE}[${PDM_EC}Error${PDM_RC}]: $1"
}

pdm_warning() {
  echo -e >&2 "${PDM_ECHO_SPACE}[${PDM_WC}Warning${PDM_RC}]: $1"
}

pdm_info() {
  echo -e >&2 "${PDM_ECHO_SPACE}[${PDM_IC}Info${PDM_RC}]: $1"
}

pdm_show_command() {
  printf %s "${PDM_SPACE}${PDM_GC}${1}|${PDM_RC}${2}"
}

pdm_has_current_workspace() {
  if [ -z "$PDM_WORKSPACE_CURRENT_NAME" ]; then
    return 1
  fi
}
