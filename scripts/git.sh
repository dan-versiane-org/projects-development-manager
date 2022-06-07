#!/usr/bin/bash

GIT_REPO_FILE="${PDM_WORKSPACE_CURRENT_ROOT}/config/pdm/repository.config"
GIT_PROJECTS_DIR="${PDM_WORKSPACE_CURRENT_ROOT}/projects"

git_commands() {
  echo "$(pdm_show_command 'checkout' 'Switch to a different branch of projects')"
  echo "$(pdm_show_command 'clone' 'Clone a git repo')"
  echo "$(pdm_show_command 'current' 'Show the current branch of projects')"
  echo "$(pdm_show_command 'help' 'Show this help')"
}

handle_git_help() {
  echo -e " ${PDM_TC}Usage:${PDM_RC}"
  echo -e "${PDM_SPACE}${PDM_PC}${PDM_SETUP_NAME} git ${PDM_GC}[command]${PDM_RC}"$'\n'
  echo -e " ${PDM_TC}Available commands:${PDM_RC}"
  echo -e "$(git_commands)" | column -t -s "|"
}

git_clone_one() {
  local REPO_URL="$2"
  local PROJECT_FULL_DIR="${GIT_PROJECTS_DIR}/${1}"

  if [ -d $PROJECT_FULL_DIR ]; then
    # pdm_warning "Directory $PROJECT_FULL_DIR already exists."
    return
  fi

  if [ -z $DEFAULT_BRANCH ]; then
    git clone "$REPO_URL" "$PROJECT_FULL_DIR" || {
      pdm_error "Failed to clone $1"
      exit 1
    }
  else
    git clone --branch="$DEFAULT_BRANCH" "$REPO_URL" "$PROJECT_FULL_DIR" || {
      pdm_error "Failed to clone $1"
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
    git_message_error="Cannot find file ${PDM_PC}'$GIT_REPO_FILE'${PDM_RC}."
  elif [ ! -s "$GIT_REPO_FILE" ]; then
    git_message_error="No projects found on repository config."
  fi

  if [ -n "$git_message_error" ]; then
    pdm_error "$git_message_error"$'\n'
    echo -e " ${PDM_TC}Example:${PDM_RC}"
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

    pdm_error "Project $1 not found on config repo."
    exit 1
  fi

  pdm_success "Clone successful."
}

handle_git_current() {
  local result
  for i in $(ls ${GIT_PROJECTS_DIR}); do
    cd ${GIT_PROJECTS_DIR}/${i}
    local current=$(git branch --show-current)
    result="${result}"$'\n'"  ${PDM_PC}${i}|:${PDM_GC} ${current}${PDM_RC}"
  done
  echo -e "$result" | column -t -s "|"

  cd ${PDM_DIR}
}

handle_git_checkout() {
  local branch=$1
  local git_params=""
  local only_checkout=0

  for ARG in ${@:2:$#}; do
    case "${ARG}" in
      -f|--force) git_params="$git_params -f";;
      -o|--only-checkout) only_checkout=1;;
    esac
  done

  for i in $(ls ${GIT_PROJECTS_DIR}); do
    cd ${GIT_PROJECTS_DIR}/${i}

    local current=$(git branch --show-current)
    echo -e >&2 "  * ${PDM_PC}${i}: ${PDM_GC}${current} -> ${branch}${PDM_RC}"

    if [ $only_checkout -eq 1 ]; then
      git checkout -q "${branch}" $git_params 2>/dev/null || {
        pdm_error "Failed to checkout ${PDM_PC}${i} to ${1}${PDM_RC}"
        continue
      }
    else
      if [ "$current" != "$branch" ]; then
        git fetch origin --prune 2>/dev/null
        git checkout -q "${branch}" $git_params 2>/dev/null || {
          pdm_error "Failed to checkout ${PDM_PC}${i} to ${1}${PDM_RC}"
          continue
        }
      fi

      git pull origin "${branch}" 2>/dev/null || {
        pdm_error "Failed to pull ${PDM_PC}${i} -> ${1}${PDM_RC}"
        continue
      }
    fi
  done

  cd ${PDM_DIR}

  echo
  handle_git_current
}
