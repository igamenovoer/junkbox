#!/bin/bash

# require root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# check if ./change-user-uid.sh exists
if [ ! -f "./change-user-uid-group.sh" ]; then
    echo "./change-user-uid-group.sh does not exist"
    exit 1
fi

bash ./change-user-uid-group.sh huangzhe 3100 if3dv
bash ./change-user-uid-group.sh nieyujie 3101 if3dv
bash ./change-user-uid-group.sh shidebo 3102 if3dv
bash ./change-user-uid-group.sh linzhi 3103 if3dv
bash ./change-user-uid-group.sh chengxiao 3104 if3dv
bash ./change-user-uid-group.sh qinchao 3105 if3dv
bash ./change-user-uid-group.sh zhangleichao 3106 if3dv
