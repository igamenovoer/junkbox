#!/bin/bash

# require root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# check if ./change-user-uid.sh exists
TEAM_USER_LIST="huangzhe nieyujie shidebo linzhi chengxiao qinchao zhangleichao"

for user in $TEAM_USER_LIST; do
    echo "User: $user, UID: $(id -u $user)"
done

