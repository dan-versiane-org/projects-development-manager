#!/usr/bin/bash

source "$PDM_DIR/.env"

do_setup() {
  alias "$PDM_SETUP_NAME"="$PDM_DIR/bin/startup.sh"
}

do_setup
