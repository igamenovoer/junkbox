#!/bin/bash

# if we log in via ssh, this script sets the proxy to the ssh client's proxy
# suppose the client is is ssh_client_ip, then the proxy is set to ssh_client_ip:port, where port is input via command line argument
# if no port is provided, then the proxy is not set

# This script must be sourced to work properly
# Usage: source $0 <port>

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script must be sourced to work properly"
    echo "Usage: source ${0} <port>"
    exit 1
fi

# check if port argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: source ${0} <port>"
    echo "Sets HTTP/HTTPS proxy to SSH client's IP and specified port"
    return 1
fi

port=$1

# find out ssh client's ip
ssh_client_ip=$(echo $SSH_CLIENT | awk '{print $1}')

# set proxy to ssh client's proxy
export http_proxy=http://$ssh_client_ip:$port
export https_proxy=http://$ssh_client_ip:$port

echo "Proxy set to $ssh_client_ip:$port"