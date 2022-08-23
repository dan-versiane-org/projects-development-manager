#!/usr/bin/python3

import json, os, sys;

WORK_NAME=os.environ['_NAME']
WORK_ROOT=os.environ['_ROOT']
WORK_CONF=os.environ['_CONF']

with open(WORK_CONF, 'r') as data_file:
  data=json.load(data_file)

for i in data:
  if i['name'] == WORK_NAME:
    sys.exit(2)
  if i['rootPath'] == WORK_ROOT:
    sys.exit(3)

def get_name(workspace):
  return workspace.get('name')

data.append({'name': WORK_NAME, 'rootPath': WORK_ROOT})
data.sort(key=get_name)

with open(WORK_CONF, 'w') as data_file:
  data_file.write(json.dumps(data, sort_keys=True, indent=2))
