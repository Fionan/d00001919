
## Menu function
function Show-Menu {
    Clear-Host
    Write-Host "=== User Creation Menu ==="
    Write-Host "1. Create User"
    Write-Host "2. Exit"
}
## END of Menu Function


## Create USER
function Create-User {

    # We get the user first name last name and password

    $FirstName = Read-Host "Enter first name:"
    $LastName = Read-Host "Enter last name:"
    $Password = Read-Host "Enter password:"
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

    # A username is created by using first 2 letters of their first name and last 3 letters of surname
    $Username = $FirstName.Substring(0, 2).ToLower() + $LastName.Substring($LastName.Length - 3, 3).ToLower()
    # We will use the user name to create unique pcs for the user pc-<USERNAME>
    $PCName = "pc-$Username"

    # Display the username to the user
    Write-Host "Generated username: $Username"
    Write-Host "Generated PC name: $PCName"


    # User choses if they or admin or manager role
    Write-Host "Select the user's role:"
    Write-Host "1. Admin Staff"
    Write-Host "2. Manager"

    $RoleChoice = Read-Host "Enter the role number (1-2):"

    $Role = ""
    $Groups = @()


    # use a simple switch method to add choice to our group list
    # Ensure these hardcoded values are the same Linux /Windows
    switch ($RoleChoice) {
        "1" {
            $Role = "Admin Staff"
            $Groups += "adminstaff"
        }
        "2" {
            $Role = "Manager"
            $Groups += "managers"
        }
    }

    # Menu for selecting department - we will need to add departments in future as these ar hardcoded values 
    # TO-Do pull this info from AD directly
    Write-Host "Select the user's department:"
    Write-Host "1. Travel Department"
    Write-Host "2. Insurance Department"
    Write-Host "3. Ticketing Department"

    $DepartmentChoice = Read-Host "Enter the department number (1-3):"

    $Department = ""

    # using a 2nd switch method to add department group to our list
    switch ($DepartmentChoice) {
        "1" {
            $Department = "Travel Department"
            $Groups += "traveldepartment"
        }
        "2" {
            $Department = "Insurance Department"
            $Groups += "insurancedepartment"
        }
        "3" {
            $Department = "Ticketing Department"
            $Groups += "ticketingdepartment"
        }
    }
    # We can store values in an array like this for easy legibility
    $UserParams = @{
        'GivenName' = $FirstName
        'Surname' = $LastName
        'SamAccountName' = $Username
        'UserPrincipalName' = "$Username@example.com"
        'Name' = "$FirstName $LastName"
        'AccountPassword' = $SecurePassword
        'Enabled' = $true
        'Description' = $Role
        'Title' = $Role
        'Department' = $Department
    }

    # Create the user using all the parameters from the array
    New-ADUser @UserParams

    Write-Host "User created successfully!"

    # All users will be added to newsletter group on creation
    $Groups += "newsletterstaff"

    $Groups | ForEach-Object {
        Add-ADGroupMember -Identity $_ -Members $Username
    }

    Write-Host "User added to the groups: $($Groups -join ', ')"

    # Create the PC for the user
    $PCParams = @{
        'Name' = $PCName
        'Description' = "PC for $Username"
        'SamAccountName' = $PCName
        'UserPrincipalName' = "$PCName@example.com"
        'Enabled' = $true
        'ManagedBy' = $Username
    }

    New-ADComputer @PCParams

    Write-Host "PC created successfully!"

    # Prompt to continue or exit after user creation
    $continue = Read-Host "Press Enter to continue or 'X' to quit:"
    if ($continue -eq "X") {
        exit
    }
}
## END of Create User


## MAIN LOOP

do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-2):"

    switch ($choice) {
        "1" {
            Create-User
        }
        "2" {
            exit
        }
    }
}
while ($true)

## END of MAIN LOOP
