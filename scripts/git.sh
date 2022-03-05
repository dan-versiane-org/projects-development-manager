#!/usr/bin/bash

GIT_REPO_FILE="$PDM_DIR/data/repo.config"

git_version() {
  printf %s "v0.1.2"
}

git_commands() {
  echo -e "
${SPACE}\e[0;32mcheckout|\e[0mSwitch to a different branch of projects
${SPACE}\e[0;32mcurrent|\e[0mShow the current branch of projects
${SPACE}\e[0;32mclone|\e[0mClone a git repo
${SPACE}\e[0;32mhelp|\e[0mShow this help
"
}

handle_git_help() {
  local SPACE="   "
  local NEWLINE=$'\n'

  echo -e "$NEWLINE\e[1;35m${PDM_SETUP_NAME} git \e[0mversion \e[4;33m$(git_version)\e[0m$NEWLINE"
  echo -e " \e[4;33mUsage:\e[0m"
  echo -e "${SPACE}\e[0;35m${PDM_SETUP_NAME} git \e[0;32m[command]\e[0m$NEWLINE"
  echo -e " \e[4;33mAvailable commands:\e[0m"
  echo -e "$(git_commands)" | column -t -s "|"
}

git_clone_one() {
  local REPO_URL="$2"
  local PROJECT_FULL_DIR="${PDM_PROJECT_DIR}/${1}"

  if [ -d $PROJECT_FULL_DIR ]; then
    echo -e " \e[1;33m*\e[0m Warning: Directory $PROJECT_FULL_DIR already exists."
    return
  fi

  if [ -z $DEFAULT_BRANCH ]; then
    git clone "$REPO_URL" "$PROJECT_FULL_DIR" || {
      echo >&2 " * Failed to clone $1"
      exit 1
    }
  else
    git clone --branch="$DEFAULT_BRANCH" "$REPO_URL" "$PROJECT_FULL_DIR" || {
      echo >&2 " * Failed to clone $1"
      exit 1
    }
  fi
}

git_clone_all() {
  while read PROJECT; do
    local DELIMITER=";"
    local RESULT=()

    IFS="$DELIMITER" read -a RESULT <<< "$PROJECT"

    git_clone_one "${RESULT[0]}" "${RESULT[1]}"
  done < $GIT_REPO_FILE
}

handle_git_clone() {
  local git_message_error

  if [ ! -f $GIT_REPO_FILE ]; then
    git_message_error=" \e[1;31m*\e[0m Error: Cannot find file \e[0;35m'$GIT_REPO_FILE'\e[0m."$'\n'
  elif [ ! -s "$GIT_REPO_FILE" ]; then
    git_message_error=" \e[1;31m*\e[0m Error: No projects found on config repo."$'\n'
  fi

  if [ -n "$git_message_error" ]; then
    echo -e "$git_message_error"
    echo -e " \e[4;33mExample:\e[0m"
    echo -e "   project-name;github.com:any_user_git/project-url.git"$'\n'
    exit 1
  fi

  if [ -z $1 ]; then
    git_clone_all
  else
    while read PROJECT; do
      local DELIMITER=";"
      local RESULT=()

      IFS="$DELIMITER" read -a RESULT <<< "$PROJECT"

      if [ "$1" == "${RESULT[0]}" ]; then
        git_clone_one "${RESULT[0]}" "${RESULT[1]}"
        exit 0
      fi
    done < $GIT_REPO_FILE

    echo -e " \e[1;31m*\e[0m Error: Project $1 not found on config repo."
    exit 1
  fi

  echo -e $'\n'"\e[0;35m * Clone successful.\033[0m"
}

handle_git_current() {
  local result
  for i in $(ls ${PDM_PROJECT_DIR}); do
    cd ${PDM_PROJECT_DIR}/${i}
    local current=$(git branch --show-current)
    result="${result}"$'\n'"  \e[1;35m${i}|:\e[0;32m ${current}\e[0m"
  done
  echo -e "$result" | column -t -s "|"

  cd ${PDM_DIR}
}

handle_git_checkout() {
  local branch=$1

  local git_params=""

  if [[ $2 = "--force" ]]; then
    git_params="$git_params -f"
  fi

  for i in $(ls ${PDM_PROJECT_DIR}); do
    cd ${PDM_PROJECT_DIR}/${i}
    git fetch origin
    git checkout "${branch}" $git_params 2>/dev/null || {
      echo -e >&2 " \e[0;31m* Failed to checkout \e[1;35m${i} -> ${1}\e[0m"
      continue
    }
    git pull origin "${branch}" 2>/dev/null || {
      echo -e >&2 " \e[0;31m* Failed to pull \e[1;35m${i} -> ${1}\e[0m"
      continue
    }
  done

  cd ${PDM_DIR}

  echo
  handle_git_current
}
