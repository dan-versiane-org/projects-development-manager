#!/usr/bin/env bash

pdm::workspace::check_dependencies

workspace::edit() {
  # TODO: in development
  pdm::echo "in development"
}

workspace::edit ${@}
