#!/bin/bash

# create users and add them to docker group
# Usage: ./create-users.sh <user1> <user2> <user3> ...
# group_id is specified by CREATE_GROUP_ID environment variable, default to 1100
# group_name is specified by CREATE_GROUP_NAME environment variable, default to if3dv

# check if user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# check if CREATE_GROUP_ID is set
if [ -z "$CREATE_GROUP_ID" ]
then
    CREATE_GROUP_ID=1100
fi
group_id=$CREATE_GROUP_ID

# check if CREATE_GROUP_NAME is set
if [ -z "$CREATE_GROUP_NAME" ]
then
    CREATE_GROUP_NAME=if3dv
fi
group_name=$CREATE_GROUP_NAME

# get userlist
if [ "$#" -eq 0 ]; then
    # echo "Usage: $0 <user1> <user2> <user3> ..."
    echo "Usage: $0 <user1> <user2> <user3> ..."
    echo "group_id is specified by CREATE_GROUP_ID environment variable, default to 1100"
    echo "group_name is specified by CREATE_GROUP_NAME environment variable, default to if3dv"
    exit 1
else
    userlist="$@"
fi

# remove duplicate
userlist=$(echo $userlist | tr ' ' '\n' | uniq)

# sort userlist by username
userlist=$(echo $userlist | tr ' ' '\n' | sort)

echo "Creating users: $userlist"

# check if docker group exists
if ! grep -q docker /etc/group
then
    echo "docker group does not exist"
    echo "create it now"

    # create docker group
    groupadd docker
fi

# create a group named $group_name with group id $group_id
if ! grep -q $group_name /etc/group
then
    echo "$group_name group does not exist"
    echo "create it now"

    # create group with group id
    groupadd -g $group_id $group_name
fi

# create users
for user in $userlist;
do
    # check if user exists
    if id "$user" >/dev/null 2>&1
    then
        echo "$user exists"
    else
        echo "create user $user"
        useradd -m -s /bin/bash "$user"
        echo "add user $user to docker group"
        usermod -aG docker "$user"

        # also add to group
        usermod -aG $group_name "$user"
        
        # set password as the same with username@if
        echo "$user:$user@if" | chpasswd
        echo "user $user created with password $user"
    fi
done