#!/usr/bin/env bash

workspace::commands() {
  echo "$(pdm::show_command 'create' 'Create a new workspace')"
  echo "$(pdm::show_command 'current' 'Shows the current workspace')"
  echo "$(pdm::show_command 'delete' 'Delete a workspace')"
  echo "$(pdm::show_command 'edit' 'Edit a workspace')"
  echo "$(pdm::show_command 'help' 'Show this help')"
  echo "$(pdm::show_command 'list' 'Show all workspaces')"
  echo "$(pdm::show_command 'set' 'Set a workspace current')"
}

workspace::help() {
  pdm::echo " ${PDM_TC}Usage:${PDM_RC}"
  pdm::echo "  ${PDM_PC}pdm workspace ${PDM_GC}[command]${PDM_RC}"$'\n'
  pdm::echo " ${PDM_TC}Available commands:${PDM_RC}"
  echo -e "$(workspace::commands)" | column -t -s "|"
}

workspace::help
