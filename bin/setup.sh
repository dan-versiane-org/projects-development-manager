#!/bin/bash

dan_dir() {
  printf %s "$(dirname $(dirname $(readlink -f $0)))"
}

echo $(dan_dir)
