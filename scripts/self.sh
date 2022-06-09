#!/usr/bin/bash

do_setup_rc() {
  PDM_RC_FILE="${HOME}/.pdmrc"

  echo "#!/usr/bin/env bash" > $PDM_RC_FILE
  echo >> $PDM_RC_FILE
  echo "export PDM_DIR=\"${PDM_DIR}\"" >> $PDM_RC_FILE
  echo "export PDM_WORKSPACE_DIR=\"$PDM_WORKSPACE_DIR\"" >> $PDM_RC_FILE
  echo >> $PDM_RC_FILE
  echo "[ \"\${1}\" = \"--ignore-update\" ] || pdm self update" >> $PDM_RC_FILE
  echo >> $PDM_RC_FILE
  echo "[ -s \"\${PDM_DIR}/bin/bash_completion\" ] && \\. \"\${PDM_DIR}/bin/bash_completion\"" >> $PDM_RC_FILE

  source $PDM_RC_FILE "--ignore-update"
}

update_from_git() {
  local LATEST_VERSION="$(pdm_latest_version)"
  local CURRENT_VERSION="$(pdm_current_version)"

  if [ "${LATEST_VERSION}" = "${CURRENT_VERSION}" ]; then
    exit 0
  fi

  while true; do
    read -p "$(echo -e " ~ [${PDM_PC}PDM${PDM_RC}] \e[0;35mWould you like to update?${PDM_RC} [Y/n] ")" yn
    case $yn in
        [Yy]*) break;;
        "") break;;
        *) exit 0;;
    esac
  done

  if ! command git --git-dir="$PDM_DIR"/.git --work-tree="$PDM_DIR" fetch origin "stable" --depth=1 2>/dev/null; then
    pdm_error "Failed to update with $LATEST_VERSION."
    exit 2
  fi

  command git -c advice.detachedHead=false --git-dir="$PDM_DIR"/.git --work-tree="$PDM_DIR" checkout -f --quiet FETCH_HEAD || {
    pdm_error "Failed to checkout on $LATEST_VERSION."
    exit 2
  }

  do_setup_rc

  pdm_echo "${PDM_IC}    ____  ____  __  ___${PDM_RC}"
  pdm_echo "${PDM_PC}   / __ \/ __ \/  |/  /${PDM_RC}"
  pdm_echo "${PDM_GC}  / /_/ / / / / /|_/ / ${PDM_RC}"
  pdm_echo "${PDM_WC} / ____/ /_/ / /  / /  ${PDM_RC}"
  pdm_echo "${PDM_EC}/_/   /_____/_/  /_/   ${PDM_RC}"
  pdm_echo
  pdm_echo "\e[0;35m Awesome! PDM has been updated!${PDM_RC} (${PDM_PC}${CURRENT_VERSION}${PDM_RC} -> ${PDM_PC}${LATEST_VERSION}${PDM_RC})"
}

handle_self_update() {
  if pdm_has_package git; then
    update_from_git
  else
    pdm_info 'You need `git` to install this.'
    exit 1
  fi
}
