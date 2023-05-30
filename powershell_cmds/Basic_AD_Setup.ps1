#add domain services
#Add-WindowsFeature ad-domain-services

# promote this server to domain controller
#Install-ADDSForest -DomainName "Mediholidays.local"


# Create the parent OU
New-ADOrganizationalUnit -Name "office" -Path "DC=Mediholidays,DC=local"

# Create the first child OU
New-ADOrganizationalUnit -Name "accounts" -Path "OU=Office,DC=Mediholidays,DC=local"

# Create the second child OU
New-ADOrganizationalUnit -Name "admin" -Path "OU=accounts,OU=Office,DC=Mediholidays,DC=local"
New-ADOrganizationalUnit -Name "manager" -Path "OU=accounts,OU=Office,DC=Mediholidays,DC=local"


# Create the first child OU
New-ADOrganizationalUnit -Name "computers" -Path "OU=Office,DC=Mediholidays,DC=local"
New-ADOrganizationalUnit -Name "client computers" -Path "OU=computers,OU=Office,DC=Mediholidays,DC=local"
New-ADOrganizationalUnit -Name "servers" -Path "OU=computers,OU=Office,DC=Mediholidays,DC=local"


# Create the first child OU
New-ADOrganizationalUnit -Name "groups" -Path "OU=Office,DC=Mediholidays,DC=local"


#View the domain controller layout
Import-Module ActiveDirectory
Get-ADOrganizationalUnit -Filter * | Format-Table Name,DistinguishedName 
