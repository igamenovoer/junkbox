#!/bin/bash

# create a single user with a specific id, and add it to a group
# Usage: ./create-single-user.sh <username> <user_id> <group_name>

# check if user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get userlist
if [ "$#" -eq 0 ]; then
    # echo "Usage: $0 <username> <user_id> <group_name>"
    echo "Usage: $0 <username> <user_id> <group_name>"
    exit 1
else
    username=$1
    user_id=$2
    group_name=$3
fi

# check if user exists
if id "$username" >/dev/null 2>&1
then
    echo "$username exists"
    exit 1
fi

# check if group exists
if ! grep -q $group_name /etc/group
then
    echo "$group_name group does not exist"
    exit 1
fi

echo "create user $username with id $user_id"
useradd -m -s /bin/bash -u "$user_id" "$username"

# also add to group
echo "add user $username to $group_name"
usermod -aG $group_name "$username"

# check if docker group exists, if yes, add user to docker group
# if not, skip
if ! grep -q docker /etc/group
then
    echo "docker group does not exist"
    echo "skip adding user to docker group"
else
    echo "add user $username to docker group"
    usermod -aG docker "$username"
fi

# set password as the same with username@if
echo "$username:$username@if" | chpasswd
echo "user $username created with password $username@if"
