#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Stopping Squid service..."
if sudo systemctl is-active --quiet squid; then
    sudo systemctl stop squid
    echo "Squid service stopped."
else
    echo "Squid service is not running or already stopped."
fi

if [ -f /etc/squid/squid.conf.original ]; then
    echo "Restoring original Squid configuration..."
    sudo cp /etc/squid/squid.conf.original /etc/squid/squid.conf
    echo "Original Squid configuration restored from /etc/squid/squid.conf.original."
    # If you wanted to restart squid with its original configuration, you would add:
    # echo "Restarting Squid with original configuration (if it was running before)..."
    # sudo systemctl start squid
    # However, the goal is to "take down the proxy", so we leave it stopped.
else
    echo "Warning: Original Squid configuration backup (/etc/squid/squid.conf.original) not found."
    echo "Skipping restoration. If Squid was not configured by start-proxy.bash, its current configuration remains."
    echo "If Squid was running, it has been stopped."
fi

echo ""
echo "Proxy shutdown process complete."
echo "Squid proxy has been stopped and its configuration (if backed up by start-proxy.bash) has been restored."
echo "Squid package itself has not been uninstalled."
echo ""
echo "To make this script executable, run: chmod +x ~/stop-proxy.bash"
echo "Then run it with: sudo ~/stop-proxy.bash"
