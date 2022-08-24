#!/usr/bin/env bash

if [ ${1} = '--force' ]; then
  ( source "${PDM_DIR}/tools/upgrade.sh" )
  return $?
fi

( source "${PDM_DIR}/tools/check_upgrade.sh" "--ignore-mode" )

if [ $? -eq 1 ] ;then
  pdm::info 'PDM already updated.'
  exit 1
elif [ $? -eq 127 ] ;then
  exit 1
fi

( source "${PDM_DIR}/tools/upgrade.sh" )
return $?
