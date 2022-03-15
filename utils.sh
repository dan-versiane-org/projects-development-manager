#!/usr/bin/bash

PDM_SCRIPTS_DIR="$PDM_DIR/scripts"
PDM_SPACE="  "
PDM_ECHO_SPACE=" "

pdm_has_package() {
  type "$1" > /dev/null 2>&1
}

pdm_latest_version() {
  printf %s $(curl -o- -s https://raw.githubusercontent.com/danielversiane13/projects-development-manager/main/version.md)
}

pdm_success() {
  echo -e >&2 "${PDM_ECHO_SPACE}[\e[1;35mSuccess\e[0m]: $1"
}

pdm_error() {
  echo -e >&2 "${PDM_ECHO_SPACE}[\e[1;31mError\e[0m]: $1"
}

pdm_warning() {
  echo -e >&2 "${PDM_ECHO_SPACE}[\e[1;33mWarning\e[0m]: $1"
}

pdm_info() {
  echo -e >&2 "${PDM_ECHO_SPACE}[\e[1;34mInfo\e[0m]: $1"
}

pdm_show_command() {
  printf %s "${PDM_SPACE}\e[0;32m${1}|\e[0m${2}"
}
