#!/usr/bin/python3

import json, os, sys;

WORK_CONF=os.environ['_CONF']

with open(WORK_CONF, 'r') as data_file:
  data=json.load(data_file)

print('\e[4;4mWorkspace\e[0m' + '|' + '\e[4;4mRoot path\e[0m')
for i in data:
  print('\e[1;35m' + i['name'] + '\e[0m|' + i['rootPath'])
