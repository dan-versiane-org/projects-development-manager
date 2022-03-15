#!/usr/bin/bash

source "$PDM_DIR/.env"

do_setup() {
  alias pdm="$PDM_DIR/bin/startup.sh"
}

do_setup
