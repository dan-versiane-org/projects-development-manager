#!/usr/bin/bash

docker_commands() {
  echo "$(pdm_show_command 'build' 'Build containers')"
  echo "$(pdm_show_command 'config' 'Show config of docker compose')"
  echo "$(pdm_show_command 'down' 'Stop containers')"
  echo "$(pdm_show_command 'exec' 'Exec command in containers')"
  echo "$(pdm_show_command 'help' 'Show this help')"
  echo "$(pdm_show_command 'up' 'Start containers')"
}

handle_docker_build() {
  cd ${PDM_WORKSPACE_CURRENT_ROOT}
  docker compose build ${@:1:$#}
  cd ${PDM_DIR}
}

handle_docker_config() {
  cd ${PDM_WORKSPACE_CURRENT_ROOT}
  docker compose config ${@:1:$#}
  cd ${PDM_DIR}
}

handle_docker_down() {
  cd ${PDM_WORKSPACE_CURRENT_ROOT}
  docker compose down ${@:1:$#}
  cd ${PDM_DIR}
}

handle_docker_exec() {
  cd ${PDM_WORKSPACE_CURRENT_ROOT}
  docker compose exec ${@:1:$#}
  cd ${PDM_DIR}
}

handle_docker_help() {
  echo -e " ${PDM_TC}Usage:${PDM_RC}"
  echo -e "${PDM_SPACE}${PDM_PC}${PDM_SETUP_NAME} docker ${PDM_GC}[command]${PDM_RC}"$'\n'
  echo -e " ${PDM_TC}Available commands:${PDM_RC}"
  echo -e "$(docker_commands)" | column -t -s "|"
}

handle_docker_up() {
  cd ${PDM_WORKSPACE_CURRENT_ROOT}
  docker compose up ${@:1:$#}
  cd ${PDM_DIR}
}
