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

# Ensure SSH configuration allows password login and X forwarding
echo "Configuring SSH settings..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#X11Forwarding yes/X11Forwarding yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create .ssh directory for admin user
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh
chown admin:admin /home/admin/.ssh

# Generate SSH key for admin user with passphrase "admin"
echo "Generating SSH key for admin user..."
su - admin -c "ssh-keygen -t rsa -b 4096 -f /home/admin/.ssh/id_rsa -N 'admin'"

# Add the public key to authorized_keys
su - admin -c "cat /home/admin/.ssh/id_rsa.pub >> /home/admin/.ssh/authorized_keys"
su - admin -c "chmod 600 /home/admin/.ssh/authorized_keys"

# Print the public and private key of admin user
echo "Admin user's public SSH key:"
cat /home/admin/.ssh/id_rsa.pub
echo ""
echo "Admin user's private SSH key:"
cat /home/admin/.ssh/id_rsa

echo "admin user created successfully with SSH access and SSH key, user name and password are admin:admin"
