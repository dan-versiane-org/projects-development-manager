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

do_install
