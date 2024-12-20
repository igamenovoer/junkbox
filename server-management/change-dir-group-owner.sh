#!/bin/bash

# require root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# change the owner of a directory and sub dirs to a group
# Usage: ./change-dir-group-owner.sh <dir> <group>

# get dir and group
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dir> <group>"
    exit 1
else
    dirname=$1
    group=$2
fi

# if the directory does not exist, exit
if [ ! -d $dirname ]; then
    echo "Directory $dirname does not exist"
    exit 1
fi

# if group does not exist, exit
if ! grep -q $group /etc/group
then
    echo "Group $group does not exist"
    exit 1
fi

# change the owner of the directory and sub dirs
echo "Changing owner of $dirname to $group"
chown -R :$group $dirname

# allow read/write/execute for the group
echo "Changing permission of $dirname to 775"
chmod -R 775 $dirname

# set the setgid bit so new files inherit the group
echo "Setting setgid bit on $dirname"
find $dirname -type d -exec chmod g+s {} +

echo "Done"