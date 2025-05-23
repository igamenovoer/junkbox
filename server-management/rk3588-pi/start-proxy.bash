#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Squid
echo "Installing Squid..."
sudo apt-get install -y squid

# Backup the original Squid configuration file
echo "Backing up original Squid configuration..."
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.original

# Create new Squid configuration
echo "Configuring Squid..."
sudo tee /etc/squid/squid.conf > /dev/null <<EOF
# ACL for local network
acl localnet src 192.168.1.0/24

# Ports allowed
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT

# Access rules
http_access allow localhost manager
http_access deny manager

# Deny requests to ports not in Safe_ports. This is a primary security filter.
http_access deny !Safe_ports

# Allow localnet/localhost to use CONNECT to any port in Safe_ports.
# This is intended to allow Clash Verge's latency check (e.g., CONNECT to port 80).
http_access allow localnet CONNECT Safe_ports
http_access allow localhost CONNECT Safe_ports

# Deny CONNECT requests to non-SSL ports if not already allowed above.
http_access deny CONNECT !SSL_ports

# Allow general HTTP/S traffic for localnet and localhost (for non-CONNECT requests).
http_access allow localnet
http_access allow localhost

# Deny all other traffic
http_access deny all

# Squid listening port
http_port 3128

# Coredump directory
coredump_dir /var/spool/squid

# Refresh patterns
refresh_pattern ^ftp:       1440    20%    10080
refresh_pattern ^gopher:    1440    0%     1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%     0
refresh_pattern .           0     20%    4320
EOF

# Restart Squid service
echo "Restarting Squid service..."
sudo systemctl restart squid

echo ""
echo "Proxy server setup complete."
echo "Squid is listening on port 3128 on IP 192.168.1.35."
echo ""
echo "To use this proxy on other machines in the 192.168.1.xxx network:"
echo "1. Open your browser's network/proxy settings."
echo "2. Configure the HTTP and HTTPS (SSL) proxy to:"
echo "   Address/Host: 192.168.1.35"
echo "   Port: 3128"
echo "3. Ensure 'Use this proxy server for all protocols' is checked if available, or configure for both HTTP and HTTPS."
echo "4. Save the settings."
echo ""
echo "To make this script executable, run: chmod +x /tmp/start-proxy.bash"
echo "Then run it with: sudo /tmp/start-proxy.bash"
