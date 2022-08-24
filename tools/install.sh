set -e

# Make sure important variables exist if not already defined.
HOME="${HOME:-'$(getent passwd $USER 2>/dev/null | cut -d: -f6)'}"
# macOS does not have getent.
HOME="${HOME:-$(eval echo ~$USER)}"

# Default settings.
export PDM_DIR="${PDM_DIR:-$HOME/.pdm}"
REPO="dan-versiane-org/projects-development-manager"
REMOTE="https://github.com/${REPO}.git"
BRANCH=${BRANCH:-main}

PDM_PC="\e[35m"
PDM_RC="\e[1;31m"
PDM_YC="\e[33m"
PDM_GC="\e[32m"
PDM_RE="\e[0m"

pdm_command_exists() {
  command -v "$@" >/dev/null 2>&1
}

pdm_show_success() {
  echo "${PMD_BC}    ____  ____  __  ___${PDM_RE}"
  echo "${PDM_PC}   / __ \/ __ \/  |/  /${PDM_RE}"
  echo "${PDM_GC}  / /_/ / / / / /|_/ / ${PDM_RE}"
  echo "${PDM_YC} / ____/ /_/ / /  / /  ${PDM_RE}"
  echo "${PDM_RC}/_/   /_____/_/  /_/   ${PDM_RE}"
  echo
  echo "${PDM_PC} Awesome! PDM is now installed!${PDM_RE}"
}

pdm_setup() {
  if [ ! -d "${PDM_DIR}" ]; then
    git init --quiet "${PDM_DIR}" && cd "${PDM_DIR}" \
      && git config --local core.eol lf \
      && git config --local core.autocrlf false \
      && git config --local fsck.zeroPaddedFilemode ignore \
      && git config --local fetch.fsck.zeroPaddedFilemode ignore \
      && git config --local receive.fsck.zeroPaddedFilemode ignore \
      && git remote add origin "$REMOTE" \
      && git fetch --depth=1 origin \
      && git config --local pdm.remote origin \
      && git config --local pdm.branch "$BRANCH" \
      && git checkout -b "$BRANCH" "origin/${BRANCH}" || {
        [ ! -d "${PDM_DIR}" ] || {
          cd - >/dev/null 2>&1
          rm -rf "${PDM_DIR}" 2>/dev/null
        }
        echo " [${PDM_RC}Error${PDM_RE}]: Failed to install PDM."
        exit 1
      }
    cd - >/dev/null 2>&1
    echo
  fi
}

pdm_install() {
  if ! pdm_command_exists git; then
    echo " [${PMD_BC}Info${PDM_RE}]: You need \`git\` to install this."
    exit 1
  fi

  pdm_setup

  pdm_show_success
}

pdm_install
