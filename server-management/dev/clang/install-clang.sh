#!/bin/bash

# require root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Install clang
bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"