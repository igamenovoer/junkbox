#!/bin/bash

# Check if sudo is installed, install it if not
if ! command -v sudo &> /dev/null; then
    echo "sudo not found, installing..."
    apt-get update
    apt-get install -y sudo
fi

# install ssh server
apt-get update
apt-get install -y openssh-server

# Configure SSH
mkdir -p /var/run/sshd
# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# Start SSH service directly (no systemd in container)
echo "Starting SSH service..."
/usr/sbin/sshd -D &

# Check if SSH is running
echo "SSH service status:"
ps aux | grep sshd | grep -v grep
echo "SSH should be running on port 22"

# add ssh startup to docker-entrypoint.sh
# Insert the ssh startup command as the first line in docker-entrypoint.sh if not already there
DOCKER_ENTRYPOINT_SH="/opt/invokeai/docker-entrypoint.sh"
if ! grep -q "/usr/sbin/sshd -D &" $DOCKER_ENTRYPOINT_SH; then
    sed -i '1i /usr/sbin/sshd -D &' $DOCKER_ENTRYPOINT_SH
    echo "Added SSH startup command to docker-entrypoint.sh"
else
    echo "SSH startup command already exists in docker-entrypoint.sh"
fi
