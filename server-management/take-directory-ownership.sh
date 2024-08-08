#!/bin/bash

# this script accepts a directory as an argument
# and change the directory ownership to the current user

# get the directory, set it to target_dir
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi
target_dir=$1

# get my name
MY_NAME=$(whoami)

# change group
sudo chown -R $MY_NAME:$MY_NAME $target_dir

echo "ownership of $target_dir is changed to $MY_NAME"