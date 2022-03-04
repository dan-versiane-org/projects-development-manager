#!/usr/bin/bash

source "$PDM_DEVELOP_DIR/.env"

do_setup() {
  alias "$PDM_SETUP_NAME"="$PDM_DEVELOP_DIR/bin/startup.sh"
}

do_setup
