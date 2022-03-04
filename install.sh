#!/usr/bin/bash

has_package() {
  type "$1" > /dev/null 2>&1
}

default_install_dir() {
  printf %s "${HOME}/.dan-developer"
}

install_dir() {
  default_install_dir
}

project_source() {
  printf %s "git@github.com:danielversiane13/development-projects.git"
}

project_latest_version() {
  printf %s "main"
}

update_from_git() {
  local INSTALL_DIR
  local PROJECT_VERSION
  INSTALL_DIR="$(install_dir)"
  PROJECT_VERSION="$(project_latest_version)"

  if ! command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" fetch origin "$PROJECT_VERSION" --depth=1 2>/dev/null; then
    echo >&2 " * Failed to update with $PROJECT_VERSION."
    exit 2
  fi

  command git -c advice.detachedHead=false --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" checkout -f --quiet FETCH_HEAD || {
    echo >&2 " * Failed to checkout on $PROJECT_VERSION."
    exit 2
  }

  echo " => Updated to $PROJECT_VERSION!"

  return
}

install_from_git() {
  local INSTALL_DIR
  local PROJECT_VERSION
  INSTALL_DIR="$(install_dir)"
  PROJECT_VERSION="$(project_latest_version)"

  if [ -d "$INSTALL_DIR/.git" ]; then
    # Updating repo
    echo " => This is already installed in $INSTALL_DIR, trying to update!"
    update_from_git
  else
    # Cloning repo
    command git clone "$(project_source)" --depth=1 "${INSTALL_DIR}" || {
      echo >&2 ' * Failed to clone repo.'
      exit 2
    }
  fi

  return
}

do_install() {
  if has_package git; then
    install_from_git
  else
    echo >&2 ' * You need `git` to install this.'
    exit 1
  fi
}

## Installing
do_install

read_an_answer() {
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

do_get_setup_name() {
  echo "$(read_an_answer '  What is the name of the bin you want to use?' 'dev')"
}

do_get_project_dir() {
  echo "$(read_an_answer '  What is the name of the dir projects?' "$HOME/Workflow/projects")"
}

get_profile_zsh_or_bash() {
  if [ -f "$HOME/.zshrc" ]; then
    echo "$HOME/.zshrc"
  else
    echo "$HOME/.bashrc"
  fi
}

do_setup() {
  SETUP_NAME=$(do_get_setup_name)
  PROJECT_DIR=$(do_get_project_dir)

  echo "SETUP_NAME=$SETUP_NAME" > "$(install_dir)/.env"
  echo "PROJECT_DIR=$PROJECT_DIR" >> "$(install_dir)/.env"

  mkdir -p $PROJECT_DIR

  local tmp_exists=$(grep -c "export DAN_DEVELOP_DIR" $(get_profile_zsh_or_bash))
  if [ $tmp_exists -ne 1 ]; then
    echo >> $(get_profile_zsh_or_bash)
    echo "export DAN_DEVELOP_DIR=\"$(install_dir)\"" >> $(get_profile_zsh_or_bash)
    echo "[ -s \"\$DAN_DEVELOP_DIR/bin/setup.sh\" ] && \. \"\$DAN_DEVELOP_DIR/bin/setup.sh\"" >> $(get_profile_zsh_or_bash)
  fi
}

## Setting
do_setup
