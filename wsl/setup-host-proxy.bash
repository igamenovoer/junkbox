#! /bin/bash

host_ip=$(ip route show | grep -i 'default via' | awk '{print $3}')
host_port=30080

export http_proxy=http://$host_ip:$host_port
export https_proxy=http://$host_ip:$host_port
