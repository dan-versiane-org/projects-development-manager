#!/usr/bin/python3

import json, os, sys;

WORK_NAME=os.environ['_NAME']
WORK_CONF=os.environ['_CONF']

with open(WORK_CONF, 'r') as data_file:
  data=json.load(data_file)

for i in data:
  if i['name'] == WORK_NAME:
    print(i['name'] + '|' + i['rootPath'])
    sys.exit(0)
