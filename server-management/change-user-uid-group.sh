#!/bin/bash

# require root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Usage: $0 <username> <uid> [group_name]
# first argument is username, second argument is uid
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <username> <uid> [group_name]"
    exit 1
else
    username=$1
    uid=$2

    # if group_name is provided, add user to the group
    if [ "$#" -eq 3 ]; then
        group_name=$3

        # check if group exists, if not, exit
        if ! grep -q "$group_name" /etc/group
        then
            echo "Group $group_name does not exist"
            exit 1
        fi
    else
        group_name=""
    fi
fi

# check if user exists, if not, exit
if ! id "$username" >/dev/null 2>&1
then
    echo "User $username does not exist"
    exit 1
fi

# check if uid is valid
if ! [[ "$uid" =~ ^[0-9]+$ ]]
then
    echo "Invalid uid"
    exit 1
fi

# check if the new UID is already in use
# if getent passwd "$uid" > /dev/null 2>&1; then
#     echo "UID $uid is already in use by another user."
#     exit 1
# fi

# assign the new UID to the user
if usermod -u "$uid" "$username"; then
    echo "User $username has been assigned UID $uid"
else
    echo "Error: Failed to assign UID $uid to user $username"
    exit 1
fi

# if group_name is provided, set user primary group to group_name
if [ -n "$group_name" ]; then
    # check if group exists
    if ! grep -q "$group_name" /etc/group
    then
        echo "Group $group_name does not exist"
        exit 1
    fi

    # change the primary group of the user
    usermod -g "$group_name" "$username"
    echo "Primary group of $username has been changed to $group_name"
fi

# change the ownership of the user's home directory
chown -R "$username:$username" "/home/$username"
echo "Ownership of /home/$username has been changed to $username:$username"