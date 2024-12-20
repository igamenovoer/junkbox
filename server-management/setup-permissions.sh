# set permissions for a given user group
# Usage: ./setup-permissions.sh <group>

# check if the group exists
if ! grep -q "$1" /etc/group
then
    echo "$1 group does not exist"
    exit
fi

# grant the group with read write execute access to /data1 and /data2
echo "grant $1 read write execute access to /data1 and /data2"
chgrp -R "$1" /data1
chgrp -R "$1" /data2
chmod -R 770 /data1
chmod -R 770 /data2
echo "permissions set"

# echo "grant ifusers read write execute access to /data1 and /data2"
# chgrp -R ifusers /data1
# chgrp -R ifusers /data2
# chmod -R 770 /data1
# chmod -R 770 /data2

# add username huangzhe to sudo
# usermod -aG sudo huangzhe
