# Creating a Logon restriction policy

New-GPO -Name "Staff_Login_policy" -comment "For setting logon hours of members of Staff"

#set GPO as variable 

$GPO = Get-GPO -Name "Staff_Login_Policy"

#Set login hours to  allow  based on this table but in Dec
# Sunday: 00000000, 00000000,  00000000,
# Monday: 00000000, 01111111,  10000000,
# Tuesday: 00000000, 01111111,  10000000,
# Wednesday: 00000000, 01111111,  10000000,
# Thursday: 00000000, 01111111,  10000000,
# Friday: 00000000, 01111111,  10000000,
# Saturday: 00000000, 00000000,  00000000,

# 0,0,0 for weekends & 0,127,128 ofr says of the week


$logonhours=@{"Logonhours"= [byte[]]$hours=@(0, 0, 0, 0, 127, 128, 0, 127, 128, 0, 127, 128, 0, 127, 128, 0, 127, 128, 0, 0, 0)}

Set-GPRegistryValue -Guid $GPO.Id -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName "LogonHours" -Type Binary -Value $LogonHours.LogonHours


# Apply to other departments
Set-GPPermissions -Guid $GPO.Id -TargetName insurancedepartment -TargetType Group -PermissionLevel GpoApply
Set-GPPermissions -Guid $GPO.Id -TargetName ticketingdepartment -TargetType Group -PermissionLevel GpoApply