#!/bin/bash

# missing argument?
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_dir>"
    exit 1
fi

# this script accepts a directory as an argument
target_dir=$1

# for every user <username>, if there is a directory named target_dir/<username>, change the permissions of the directory to <username>:<username>
# make sure the <username> is an actual user on the system
for username in $(ls $target_dir)
do
    if id "$username" >/dev/null 2>&1
    then
        echo "changing permissions of $target_dir/$username to $username:$username"
        chown -R $username:$username $target_dir/$username
    else
        echo "$username does not exist"
    fi
done