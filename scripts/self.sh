#!/usr/bin/bash

update_from_git() {
  local PROJECT_VERSION="$(pdm_latest_version)"

  if ! command git --git-dir="$PDM_DIR"/.git --work-tree="$PDM_DIR" fetch origin "$PROJECT_VERSION" --depth=1 2>/dev/null; then
    pdm_error "Failed to update with $PROJECT_VERSION."
    exit 2
  fi

  command git -c advice.detachedHead=false --git-dir="$PDM_DIR"/.git --work-tree="$PDM_DIR" checkout -f --quiet FETCH_HEAD || {
    pdm_error "Failed to checkout on $PROJECT_VERSION."
    exit 2
  }

  echo -e " [${PDM_PC}Success${PDM_RC}]: Updated to $PROJECT_VERSION!"
}

handle_self_update() {
  if pdm_has_package git; then
    update_from_git
  else
    echo -e >&2 ' [${PDM_IC}Info${PDM_RC}]: You need `git` to install this.'
    exit 1
  fi
}
