#!/bin/bash


#
# This file takes the Departments Roles and Users files and updates them to their respective groups
# PLEASE NOTE: we need to create the groups Manually first
# Define the paths to the CSV files
# Fionan obrien 26/05/2023
#
# Notes: warning message & sanity checks added 28/08/2023



# Display a warning message
echo "WARNING: This script assumes that all security groups have been manually created."
echo "Please ensure that the required security groups exist before running this script."
echo

# Prompt the user to continue or exit
read -p "Do you want to continue? (y/n): " choice

# Check the user's choice
if [[ $choice != "y" && $choice != "Y" ]]; then
    echo "Script execution aborted. Exiting..."
    exit 0
fi



### BEGIN ####


# Define the path to the CSV file
CSV_FILE="Users.csv"

# Read the CSV file line by line
while IFS=, read -r fullname department role; do
    # Extract the first name and surname
    firstname=$(echo "$fullname" | awk '{print $1}')
    surname=$(echo "$fullname" | awk '{print $2}')

    # Generate the username based on the first 2 letters of the firstname and last 3 letters of the surname
    username="${firstname:0:2}${surname: -3}"

    # Check if the user already exists
    #  If the users exists we can replace them
    if id "$username" &>/dev/null; then
        read -p "User '$username' already exists. Do you want to replace it? (y/n): " replace_user
        if [[ "$replace_user" != "y" ]]; then
            echo "Skipping user creation for '$username'."
            continue
        fi

        # Remove the existing user and home directory
        sudo userdel -r "$username"
    fi

    # Create the user account
    sudo useradd -m -c "$fullname" -s /bin/bash "$username"

    # Check if the user creation was successful
    if [[ $? -eq 0 ]]; then
        echo "User '$username' created successfully."
    else
        echo "Failed to create user '$username'."
        continue
    fi

    # Add the user to the appropriate group based on department
    sudo usermod -aG "$department" "$username"

    # Add the user to the appropriate group based on role
    sudo usermod -aG "$role" "$username"

    echo "User '$username' added to department '$department' and role '$role'."

done < "$CSV_FILE"
