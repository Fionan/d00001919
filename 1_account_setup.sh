#!/bin/bash

# This script allows for creation of Departments Roles and User files in .csv  File format.
# The scripts in this repository should be run in order by file name
# This script will create a menu where users can define Departments and roles and users

# Define the paths to the CSV files
DEPARTMENTS_FILE="Departments.csv"
ROLES_FILE="Roles.csv"
USERS_FILE="Users.csv"

# Check if the CSV files exist, create them if not
if [[ ! -f "$DEPARTMENTS_FILE" ]]; then
    touch "$DEPARTMENTS_FILE"
fi

if [[ ! -f "$ROLES_FILE" ]]; then
    touch "$ROLES_FILE"
fi

if [[ ! -f "$USERS_FILE" ]]; then
    touch "$USERS_FILE"
fi

# Function to read file contents into an array for acessing later
read_file_contents() {
    local file="$1"
    local -n array="$2"
    array=()
    while IFS= read -r line; do
        array+=("$line")
    done < "$file"
}

# Read file contents into arrays
read_file_contents "$DEPARTMENTS_FILE" departments_array
read_file_contents "$ROLES_FILE" roles_array
read_file_contents "$USERS_FILE" users_array

# Function to create a new department menu option for Departments.csv
create_department() {
    read -p "Enter the department name: " department
    if [[ " ${departments_array[*]} " =~ " ${department} " ]]; then
        echo "Department '$department' already exists."
        return
    fi
    echo "Department: $department"
    read -p "Is this information correct? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        echo "$department" >> "$DEPARTMENTS_FILE"
        echo "Department created successfully."
        departments_array+=("$department")
    else
        echo "Department creation cancelled."
    fi
}

# Function to create a new role menu option for Roles.csv creation
create_role() {
    read -p "Enter the role name: " role
    if [[ " ${roles_array[*]} " =~ " ${role} " ]]; then
        echo "Role '$role' already exists."
        return
    fi
    echo "Role: $role"
    read -p "Is this information correct? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        echo "$role" >> "$ROLES_FILE"
        echo "Role created successfully."
        roles_array+=("$role")
    else
        echo "Role creation cancelled."
    fi
}

# Function to create a new user using department and role to generate users.cvs finished file
create_user() {
    read -p "Enter the user name: " user
    
    # Submenu for selecting the department - submenu helps eliminate errors
    echo "Select the department for $user:"
    select department in "${departments_array[@]}" "Cancel"; do
        case "$REPLY" in
            [1-$((${#departments_array[@]}))])
                break
                ;;
            $((${#departments_array[@]} + 1)))
                echo "User creation cancelled."
                return
                ;;
            *)
                echo "Invalid choice. Please try again."
                ;;
        esac
    done
    
    read -p "Enter the role: " role
    # Check if user already exists
    if [[ " ${users_array[*]} " =~ " ${user},${department},${role} " ]]; then
        echo "User '$user' with department '$department' and role '$role' already exists."
        return
    fi
    echo "User: $user, Department: $department, Role: $role"
    read -p "Is this information correct? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        echo "$user,$department,$role" >> "$USERS_FILE"
        echo "User created successfully."
        users_array+=("$user,$department,$role")
    else
        echo "User creation cancelled."
    fi
}

# Function to view file contents
view_file_contents() {
    local file="$1"
    echo "---- File Contents: $file ----"
    cat "$file"
    echo "----------------"
}

# Function to save changes and exit  - Updates the CSV files for future use
save_and_exit() {
    echo "Saving changes and exiting."
    printf "%s\n" "${departments_array[@]}" > "$DEPARTMENTS_FILE"
    printf "%s\n" "${roles_array[@]}" > "$ROLES_FILE"
    printf "%s\n" "${users_array[@]}" > "$USERS_FILE"
    exit
}

# Main menu loop
while true; do
    echo "---- Main Menu ----"
    echo "1. Create new department"
    echo "2. Create new role"
    echo "3. Create new user"
    echo "4. View department file contents"
    echo "5. View role file contents"
    echo "6. View user file contents"
    echo "7. Exit"
    echo "8. Save and exit"

    read -p "Enter your choice (1-8): " choice
    case "$choice" in
        1)
            create_department
            ;;
        2)
            create_role
            ;;
        3)
            create_user
            ;;
        4)
            view_file_contents "$DEPARTMENTS_FILE"
            ;;
        5)
            view_file_contents "$ROLES_FILE"
            ;;
        6)
            view_file_contents "$USERS_FILE"
            ;;
        7)
            echo "Exiting without saving changes."
            exit
            ;;
        8)
            save_and_exit
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
# End of file
