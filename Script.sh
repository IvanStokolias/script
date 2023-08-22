#!/bin/bash

# Check if script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Read a non-empty input
read_non_empty() {
    local input
    while true; do
        read -p "$1: " input
        if [[ -n "$input" ]]; then
            echo "$input"
            break
        else
            echo "Please enter a valid input"
        fi
    done
}

# Create a new user
create_user() {
    local username="$1"
    local password="$2"
    local salt="$3"

    if id "$username" &>/dev/null; then
        echo "User $username already exists"
        exit 1
    fi

    useradd -m -d "/home/$username" -s "/bin/bash" "$username"
    groupadd "$username"

    hashed_password=$(perl -e "print crypt('$password', '\$1\$$salt')")
    usermod -p "$hashed_password" "$username"
}

# Create sudoers file
create_sudoers_file() {
    local username="$1"
    local sudoers_file="/etc/sudoers.d/$username"

    if [[ ! -f "$sudoers_file" ]]; then
        echo "$username ALL=(ALL) NOPASSWD:ALL" | tee "$sudoers_file" > /dev/null
        echo "Sudoers file created for user $username"
    else
        echo "Sudoers file already exists for user $username"
    fi
}

# Main script execution
main() {
    check_root
    username=$(read_non_empty "Enter username")
    password=$(read_non_empty "Enter password")
    
    if [[ -z "$password" ]]; then
        echo "Password is blank. Please set password for user $username manually."
        exit 1
    fi
    
    salt=$(read_non_empty "Enter salt (up to 8 characters)")
    create_user "$username" "$password" "$salt"
    create_sudoers_file "$username"
    
    echo "User $username created successfully"
}

main
