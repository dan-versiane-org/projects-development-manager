#!/usr/bin/env bash

pdm::workspace::check_dependencies

workspace::delete() {
  # TODO: in development
  pdm::echo "in development"
}

workspace::delete ${@}
