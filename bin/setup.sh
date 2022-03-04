#!/bin/bash

do_setup() {
  source "$DAN_DEVELOP_DIR/.env"
  alias "$SETUP_NAME"="$DAN_DEVELOP_DIR/bin/startup.sh"
}

do_setup
