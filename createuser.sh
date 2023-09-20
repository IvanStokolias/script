#!/bin/bash

#Check if the script is run by root

if [ "$EUID" != 0 ]
  then echo "Please run as root"
exit 1
fi

#Asks for a username
while true; do
echo "Username: "
read username
if [[ -z "$username" ]]; then
echo "You did not introduced yourself, try again!"
else
   break
fi
done

#Checks if user already exists
  if id "$username" &>/dev/null; then
    echo "user "$username" already exists!"
   exit 1
fi

#Asks for a password
echo "Password"
read -s password
echo

#Checks if password was pasted
if [[ -z "$password" ]]; then
echo  "You did not set a password for a user $username"
exit 1
fi

#Creates the user with a group and home directory
useradd -m -s /bin/bash "$username"

#sets password for the user
echo -e "$password\n$password" | passwd "$username"

#Creates a sudoers file
sudoers_file="/etc/sudoers.d/$username"
if [ ! -f "$sudoers_file" ]; then
echo "$username ALL=(ALL:ALL) NOPASSWD: ALL" | tee "$sudoers_file"
chmod 440 "$sudoers_file"
echo "Sudoers file '$sudoers_file' created"
else
echo "Sudoers file '$sudoers_file' already exists"
fi

echo "User '$username' successfully created with a home directory, password, and sudo permissions"
