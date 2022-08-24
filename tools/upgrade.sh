#!/usr/bin/env bash

( source "${PDM_DIR}/tools/check_upgrade.sh" "--ignore-mode" )

if [ $? -eq 1 ] ;then
  pdm::info 'PDM already updated.'
  exit 1
fi

local ret=0

cd "${PDM_DIR}"

## Setting up git config
git config --local core.eol lf
git config --local core.autocrlf false
git config --local fsck.zeroPaddedFilemode ignore
git config --local fetch.fsck.zeroPaddedFilemode ignore
git config --local receive.fsck.zeroPaddedFilemode ignore
resetAutoStash=$(git config --local --bool rebase.autoStash 2>/dev/null)
git config --local rebase.autoStash true

## Get Branch and Remote
local BRANCH REMOTE
REMOTE=$(git config --local pdm.remote)
REMOTE=${REMOTE:-origin}
BRANCH=$(git config --local pdm.branch)
BRANCH=${BRANCH:-main}

## Get current version
local CURRENT_VERSION=$(cat "${PDM_DIR}/version.md")

## Checkout branch
git checkout -q "${BRANCH}" -- || return 1

## Update branch
if LANG= git pull --quiet --rebase ${REMOTE} ${BRANCH}; then
  local LATEST_VERSION=$(cat "${PDM_DIR}/version.md")

  ## Show Success
  pdm::echo "${PDM_IC}    ____  ____  __  ___${PDM_RC}"
  pdm::echo "${PDM_PC}   / __ \/ __ \/  |/  /${PDM_RC}"
  pdm::echo "${PDM_GC}  / /_/ / / / / /|_/ / ${PDM_RC}"
  pdm::echo "${PDM_WC} / ____/ /_/ / /  / /  ${PDM_RC}"
  pdm::echo "${PDM_EC}/_/   /_____/_/  /_/   ${PDM_RC}"
  pdm::echo
  pdm::echo "${PDM_PC2} Awesome! PDM has been updated!${PDM_RC} (${PDM_PC}${CURRENT_VERSION}${PDM_RC} -> ${PDM_PC}${LATEST_VERSION}${PDM_RC})"

  ## Update last checked timestamp
  echo $(date +"%s") > "${PDM_DIR}/.upgraded_at"
else
  ret=$?
fi

## Reset auto stash
case "$resetAutoStash" in
  "") git config --local --unset rebase.autoStash ;;
  *) git config --local rebase.autoStash "$resetAutoStash" ;;
esac

cd - >/dev/null 2>&1

return $ret
