#!/bin/bash

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    if [ "$arg" == "--dry-run" ]; then
        DRY_RUN=true
    fi
done

# create group
TEAM_GROUP_ID=1100
TEAM_GROUP_NAME=if3dv

echo "create group $TEAM_GROUP_NAME with id $TEAM_GROUP_ID"
if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would execute: groupadd -g $TEAM_GROUP_ID $TEAM_GROUP_NAME"
else
    groupadd -g $TEAM_GROUP_ID $TEAM_GROUP_NAME
fi

# create users
TEAM_USER_LIST="huangzhe nieyujie shidebo linzhi chengxiao qinchao zhangleichao"
TEAM_USER_IDS="3100 3101 3102 3103 3104 3105 3106"

# create users
for user in $TEAM_USER_LIST; do
    # get user id from TEAM_USER_IDS    
    user_id=$(echo $TEAM_USER_IDS | cut -d' ' -f1)
    TEAM_USER_IDS=$(echo $TEAM_USER_IDS | cut -d' ' -f2-)

    echo "create user $user with id $user_id"
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would execute: ./create-single-user.sh $user $user_id $TEAM_GROUP_NAME"
    else
        bash ./create-single-user.sh $user $user_id $TEAM_GROUP_NAME
    fi
done
