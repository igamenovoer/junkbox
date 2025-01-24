#! /bin/bash

# download kernel source code

# download kernel source code
kernel_version="5.15.167.4"
download_url="https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-${kernel_version}.tar.gz"

# create tmp dir if not exists
if [ ! -d "./tmp" ]; then
  echo "Creating tmp directory"
  mkdir -p ./tmp
fi

# download kernel source
echo "Downloading kernel source from ${download_url}"
wget -P ./tmp "${download_url}"

# extract kernel source
echo "Extracting kernel source"
tar xf "./tmp/linux-msft-wsl-${kernel_version}.tar.gz" -C ./tmp

