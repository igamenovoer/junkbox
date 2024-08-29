#!/bin/bash

# create users and add them to docker group
# Usage: ./create-users.sh <user1> <user2> <user3> ...

# check if user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get userlist
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <user1> <user2> <user3> ..."
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

# create a group named "ifusers"
if ! grep -q ifusers /etc/group
then
    echo "ifusers group does not exist"
    echo "create it now"

    # create ifusers group
    groupadd ifusers
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

        # also add to ifusers
        usermod -aG ifusers "$user"
        
        # set password as the same with username@if
        echo "$user:$user@if" | chpasswd
        echo "user $user created with password $user"
    fi
done