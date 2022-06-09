#!/usr/bin/bash

has_package() {
  type "$1" > /dev/null 2>&1
}

pdm_default_install_dir() {
  printf %s "${HOME}/.pdm"
}

pdm_install_dir() {
  pdm_default_install_dir
}

pdm_source() {
  printf %s "git@github.com:dan-versiane-org/projects-development-manager.git"
}

pdm_version() {
  printf %s "stable"
}

pdm_update_from_git() {
  local INSTALL_DIR="$(pdm_install_dir)"
  local INSTALL_VERSION="$(pdm_version)"

  if ! command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" fetch origin "$INSTALL_VERSION" --depth=1 2>/dev/null; then
    echo -e >&2 " [\e[1;31mError\e[0m]: Failed to update with $INSTALL_VERSION."
    exit 2
  fi

  command git -c advice.detachedHead=false --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" checkout -f --quiet FETCH_HEAD || {
    echo -e >&2 " [\e[1;31mError\e[0m]: Failed to checkout on $INSTALL_VERSION."
    exit 2
  }

  echo " => Updated to $INSTALL_VERSION!"

  return
}

pdm_install_from_git() {
  local INSTALL_DIR="$(pdm_install_dir)"
  local INSTALL_VERSION="$(pdm_version)"

  if [ -d "$INSTALL_DIR/.git" ]; then
    # Updating repo
    echo " => This is already installed in $INSTALL_DIR, trying to update!"
    pdm_update_from_git
  else
    # Cloning repo
    command git -c advice.detachedHead=false clone "$(pdm_source)" --depth=1 --branch "${INSTALL_VERSION}" --single-branch "${INSTALL_DIR}" || {
      echo -e >&2 ' [\e[1;31mError\e[0m]: Failed to clone repo.'
      exit 2
    }
  fi

  return
}

do_install() {
  if has_package git; then
    pdm_install_from_git
  else
    echo -e >&2 ' [\e[1;34mInfo\e[0m]: You need `git` to install this.'
    exit 1
  fi
}

## Installing
do_install

pdm_get_profile_zsh_or_bash() {
  if [ -f "$HOME/.zshrc" ]; then
    printf %s "$HOME/.zshrc"
  else
    printf %s "$HOME/.bashrc"
  fi
}

pdm_read_an_answer() {
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

do_get_workspace_dir() {
  echo "$(pdm_read_an_answer '  What is the name of the dir workspaces?' "$HOME/workspaces")"
}

do_setup() {
  local PDM_DIR="$(pdm_install_dir)"
  local PDM_RC_FILE="${HOME}/.pdmrc"
  local PROFILE=$(pdm_get_profile_zsh_or_bash)

  mkdir -p $PDM_DIR

  if [ ! -f "${PDM_RC_FILE}" ]; then
    local PDM_WORKSPACE_DIR=$(do_get_workspace_dir)

    echo "#!/usr/bin/env bash" > $PDM_RC_FILE
    echo >> $PDM_RC_FILE
    echo "export PDM_DIR=\"\${HOME}/.pdm\"" >> $PDM_RC_FILE
    echo "export PDM_WORKSPACE_DIR=\"$PDM_WORKSPACE_DIR\"" >> $PDM_RC_FILE
    echo "[ -s \"\${PDM_DIR}/bin/bash_completion\" ] && \\. \"\${PDM_DIR}/bin/bash_completion\"" >> $PDM_RC_FILE
  fi

  local HAS_SOURCE=$(grep -c "source \"\${HOME}/.pdmrc\"" $PROFILE)
  if [ $HAS_SOURCE -ne 1 ]; then
    echo >> $PROFILE
    echo "source \"\${HOME}/.pdmrc\" ## This loads pdm" >> $PROFILE
    echo >> $PROFILE
  fi

  sudo ln -fs "$PDM_DIR/bin/pdm.sh" "/usr/bin/pdm"
}

## Setting
do_setup
