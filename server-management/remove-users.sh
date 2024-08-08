# delete given linux users
# Usage: ./remove-users.sh <user1> <user2> <user3> ...

# check if user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# delete given users
for user in "$@"
do
    # check if user exists
    if id "$user" >/dev/null 2>&1
    then
        echo "delete user $user"
        userdel -r "$user"
    else
        echo "$user does not exist"
    fi
done