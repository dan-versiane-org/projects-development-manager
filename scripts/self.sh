#!/usr/bin/bash

has_package() {
  type "$1" > /dev/null 2>&1
}

project_latest_version() {
  printf %s "v0.1.0"
}

update_from_git() {
  local PROJECT_VERSION="$(project_latest_version)"

  if ! command git --git-dir="$PDM_DIR"/.git --work-tree="$PDM_DIR" fetch origin "$PROJECT_VERSION" --depth=1 2>/dev/null; then
    echo -e >&2 " [\e[1;31mError\e[0m]: Failed to update with $PROJECT_VERSION."
    exit 2
  fi

  command git -c advice.detachedHead=false --git-dir="$PDM_DIR"/.git --work-tree="$PDM_DIR" checkout -f --quiet FETCH_HEAD || {
    echo -e >&2 " [\e[1;31mError\e[0m]: Failed to checkout on $PROJECT_VERSION."
    exit 2
  }

  echo -e " [\e[1;35mSuccess\e[0m]: Updated to $PROJECT_VERSION!"
}

handle_self_update() {
  if has_package git; then
    update_from_git
  else
    echo -e >&2 ' [\e[1;34mInfo\e[0m]: You need `git` to install this.'
    exit 1
  fi
}
