# Create the groups
$groups = @("managers", "adminstaff", "traveldepartment", "insurancedepartment", "ticketingdepartment", "newsletterstaff")

foreach ($group in $groups) {
    New-ADGroup -Name $group -GroupCategory Security -GroupScope Global
}
