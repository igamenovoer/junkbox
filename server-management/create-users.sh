# create users and add them to docker group
# Usage: ./create-users.sh <user1> <user2> <user3> ...

# check if user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# check if docker group exists
if ! grep -q docker /etc/group
then
    echo "docker group does not exist"
    echo "create it now"

    # create docker group
    groupadd docker
fi

# create a group named "ifusers"
if ! grep -q ifusers /etc/group
then
    echo "ifusers group does not exist"
    echo "create it now"

    # create ifusers group
    groupadd ifusers
fi

# create users
for user in "$@"
do
    # check if user exists
    if id "$user" >/dev/null 2>&1
    then
        echo "$user exists"
    else
        echo "create user $user"
        useradd -m -s /bin/bash "$user"
        echo "add user $user to docker group"
        usermod -aG docker "$user"

        # also add to ifusers
        usermod -aG ifusers "$user"
        
        # set password as the same with username
        echo "$user:$user" | chpasswd
        echo "user $user created with password $user"
    fi
done