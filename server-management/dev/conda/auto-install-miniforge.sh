#!/bin/bash

# Check if destination folder is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <destination_folder> [pip_mirror]"
    echo "Example: $0 /opt/miniforge [tuna|aliyun]"
    echo "Default pip mirror is aliyun"
    exit 1
fi

# Get destination folder from command line argument
CONDA_INSTALL_DIR="$1"

# Get pip mirror choice, default to aliyun
PIP_MIRROR="${2:-aliyun}"

# prevent interactive prompts
export DEBIAN_FRONTEND=noninteractive

# already installed? skip
if [ -d $CONDA_INSTALL_DIR ]; then
    echo "miniforge is already installed in $CONDA_INSTALL_DIR, skipping ..."
    exit 0
fi

# download the miniconda3 installation file yourself, and put it in the tmp directory
# it will be copied to the container during the build process
url_x64="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-x86_64.sh"
url_aarch64="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-aarch64.sh"

# download miniforge based on architecture
if [ "$(uname -m)" == "aarch64" ]; then
    url="${url_aarch64}"
    echo "Detected aarch64 architecture"
else
    url="${url_x64}"
    echo "Detected x86_64 architecture"
fi

# Extract filename from the URL
CONDA_PACKAGE_NAME=$(basename "$url")

# Create temporary directory for download
TEMP_DIR=$(mktemp -d)
CONDA_DOWNLOAD_DST="$TEMP_DIR/$CONDA_PACKAGE_NAME"

# Download miniforge installer
echo "downloading miniforge installation file ..."
wget -O $CONDA_DOWNLOAD_DST $url --show-progress

# install miniforge unattended
echo "installing miniforge to $CONDA_INSTALL_DIR ..."
bash $CONDA_DOWNLOAD_DST -b -p $CONDA_INSTALL_DIR

# make conda installation accessible to all users
echo "setting permissions for $CONDA_INSTALL_DIR ..."
chmod -R 777 $CONDA_INSTALL_DIR

echo "initializing conda for current user ..."

# conda and pip mirror, for faster python package installation
# save the following content to a variable
read -r -d '' CONDA_TUNA << EOM
auto_activate_base: false
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOM

# tuna pip mirror
read -r -d '' PIP_TUNA << EOM
[global]
index-url=https://pypi.tuna.tsinghua.edu.cn/simple

[install]
trusted-host=pypi.tuna.tsinghua.edu.cn
EOM

# aliyun pip mirror
read -r -d '' PIP_ALIYUN << EOM
[global]
index-url=https://mirrors.aliyun.com/pypi/simple

[install]
trusted-host=mirrors.aliyun.com
EOM

# to use tuna mirror, replace the .condarc file with the pre-configured CONDA_TUNA
echo "setting conda mirror for current user ..."    
echo "$CONDA_TUNA" > ~/.condarc

# to use pip mirror, create a .pip directory and write the selected mirror config to pip.conf
echo "setting pip mirror ($PIP_MIRROR) for current user ..."
mkdir -p ~/.pip
if [ "$PIP_MIRROR" = "tuna" ]; then
    echo "$PIP_TUNA" > ~/.pip/pip.conf
else
    echo "$PIP_ALIYUN" > ~/.pip/pip.conf
fi

echo "initializing conda for current user ..."
$CONDA_INSTALL_DIR/bin/conda init

# Clean up temporary directory
rm -rf $TEMP_DIR
