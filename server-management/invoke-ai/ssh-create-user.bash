#!/bin/bash

# create ssh user
# Check if ssh group exists, create if not
if ! getent group ssh > /dev/null; then
    echo "Creating ssh group..."
    groupadd ssh
fi

# Create admin user with root privileges
echo "Creating admin user with root privileges..."
useradd -m -s /bin/bash -G sudo,ssh admin

# Set password for admin user
echo "Setting password for admin user..."
echo "admin:admin" | chpasswd

# Set password for root user
echo "Setting password for root user..."
echo "root:root" | chpasswd

# Ensure SSH configuration allows password login, X forwarding, and root login
echo "Configuring SSH settings..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#X11Forwarding yes/X11Forwarding yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Make sure root login is explicitly enabled
if ! grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
fi

# Create .ssh directory for admin user
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh
chown admin:admin /home/admin/.ssh

# Create .ssh directory for root user
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Generate SSH key for admin user with passphrase "admin"
echo "Generating SSH key for admin user..."
su - admin -c "ssh-keygen -t rsa -b 4096 -f /home/admin/.ssh/id_rsa -N 'admin'"

# Generate SSH key for root user with passphrase "root"
echo "Generating SSH key for root user..."
ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N 'root'

# Add the public key to authorized_keys for admin
su - admin -c "cat /home/admin/.ssh/id_rsa.pub >> /home/admin/.ssh/authorized_keys"
su - admin -c "chmod 600 /home/admin/.ssh/authorized_keys"

# Add the public key to authorized_keys for root
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Restart SSH service in Docker container
echo "Restarting SSH service in Docker container..."
pkill sshd || true
/usr/sbin/sshd

# Print the public and private key of admin user
echo "Admin user's public SSH key:"
cat /home/admin/.ssh/id_rsa.pub
echo ""
echo "Admin user's private SSH key:"
cat /home/admin/.ssh/id_rsa

# Print the public and private key of root user
echo "Root user's public SSH key:"
cat /root/.ssh/id_rsa.pub
echo ""
echo "Root user's private SSH key:"
cat /root/.ssh/id_rsa

echo "admin user created successfully with SSH access and SSH key, user name and password are admin:admin"
echo "root user configured successfully with SSH access and SSH key, password is root"
echo "SSH has been configured to allow direct root login in Docker container"
