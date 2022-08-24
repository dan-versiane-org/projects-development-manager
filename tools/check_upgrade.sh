#!/usr/bin/env bash

ASK="yes"

if [ ${1} = "--ignore-mode" ]; then
  PDM_UPDATE_MODE="auto"
fi

pdm::check_upgrade_reminder() {
  ## TODO: In development
  return 0
}

case ${PDM_UPDATE_MODE} in
  "disabled")
    return 1;;
  "ask")
    ASK="yes"
    ;;
  "auto")
    ASK="no"
    ;;
  "reminder")
    # if ! pdm::check_upgrade_reminder; then
    #   unset -f pdm::check_upgrade_reminder
    #   return 1
    # fi
    ASK="yes"
    ;;
  *)
    return 127;;
esac

REMOTE_HEAD=""
LOCAL_HEAD=""

## Check if have a remote upgrade (0: yes, 1: no)
pdm::has_upgrade() {
  local BRANCH
  BRANCH=$(builtin cd "${PDM_DIR}"; git config --local pdm.branch)
  BRANCH=${BRANCH:-main}

  local REMOTE REMOTE_URL
  REMOTE=$(builtin cd "${PDM_DIR}"; git config --local pdm.remote)
  REMOTE=${REMOTE:-origin}
  REMOTE_URL=$(builtin cd "${PDM_DIR}"; git config remote.${REMOTE}.url)

  local REPO
  case "${REMOTE_URL}" in
    https://github.com/*) REPO=${REMOTE_URL#https://github.com/} ;;
    git@github.com:*) REPO=${REMOTE_URL#git@github.com:} ;;
    *)
    return 0 ;;
  esac
  REPO=${REPO%.git}

  local GIT_API_URL="https://api.github.com/repos/${REPO}/commits/${BRANCH}"

  ## Get local HEAD.
  LOCAL_HEAD=$(builtin cd "${PDM_DIR}"; git rev-parse ${BRANCH} 2>/dev/null) || return 0

  ## Get remote HEAD.
  REMOTE_HEAD=$(curl -fsSL -H 'Accept: application/vnd.github.v3.sha' ${GIT_API_URL} 2>/dev/null)

  ## Compare local and remote HEADs
  [[ "${LOCAL_HEAD}" != "${REMOTE_HEAD}" ]] || return 1
}

if ! pdm::has_upgrade; then
  return 1
fi

## Check ask
if [ "${ASK:-yes}" = "yes" ]; then
  while true; do
    read -p "$(echo -e " ~ [${PDM_PC}PDM${PDM_RC}] ${PDM_PC2}Would you like to update?${PDM_RC} [Y/n] ")" yn
    case $yn in
        [Yy]*) break;;
        "") break;;
        *) return 1;;
    esac
  done
  echo
fi

$(builtin cd "${PDM_DIR}"; git merge-base ${LOCAL_HEAD} ${REMOTE_HEAD} 2>/dev/null)

return 0
