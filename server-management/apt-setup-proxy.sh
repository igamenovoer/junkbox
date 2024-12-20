#!/bin/bash

# this script setup proxy for apt
# it accepts the proxy (e.g., http://127.0.0.1:7890) as an argument
# if the proxy is not given, raise error
# if the proxy is given, add it to /etc/apt/apt.conf.d/proxy.conf

# am I root?
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <proxy>"
  exit 1
fi

USER_PROXY=$1

# add proxy to apt
echo "Setting up proxy for apt"
echo "Acquire::http::Proxy \"$USER_PROXY\";" >> /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"$USER_PROXY\";" >> /etc/apt/apt.conf.d/proxy.conf

echo "Proxy set to $USER_PROXY, /etc/apt/apt.conf.d/proxy.conf is updated"
cat /etc/apt/apt.conf.d/proxy.conf