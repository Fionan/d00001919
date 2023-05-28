#!/bin/bash

# This script reads the roles and departments from the respective CSV files and creates groups based on the entries. It provides feedback on the success or failure of group creation for each role and department.

# Define the path to the CSV files
ROLES_CSV="Roles.csv"
DEPARTMENTS_CSV="Departments.csv"

# Read the roles from the Roles.csv file and create groups
while IFS= read -r role; do
    # Check if the role is empty
    if [[ -z "$role" ]]; then
        echo "Invalid entry in the Roles.csv file. Skipping."
        continue
    fi

    # Create the group for the role
    sudo groupadd "$role"

    # Check if the group creation was successful
    if [[ $? -eq 0 ]]; then
        echo "Group '$role' created successfully."
    else
        echo "Failed to create group '$role'."
    fi

done < "$ROLES_CSV"

# Read the departments from the Departments.csv file and create groups
while IFS= read -r department; do
    # Check if the department is empty
    if [[ -z "$department" ]]; then
        echo "Invalid entry in the Departments.csv file. Skipping."
        continue
    fi

    # Create the group for the department
    sudo groupadd "$department"

    # Check if the group creation was successful
    if [[ $? -eq 0 ]]; then
        echo "Group '$department' created successfully."
    else
        echo "Failed to create group '$department'."
    fi

done < "$DEPARTMENTS_CSV"
