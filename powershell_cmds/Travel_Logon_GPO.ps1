

#Insure Group policy is actually installed
Install-WindowsFeature GPMC


# Creating a Logon restriction policy

New-GPO -Name "Travel_Login_policy" -comment "For setting logon hours of members of travel group"

#set GPO as variable 

$GPO = Get-GPO -Name "Travel_Login_Policy"

#Set login hours to  allow  based on this table but in Dec
# Sunday: 00000000, 11111111,  11110000,
# Monday: 00000000, 11111111,  11110000,
# Tuesday: 00000000, 11111111,  11110000,
# Wednesday: 00000000, 11111111,  11110000,
# Thursday: 00000000, 11111111,  11110000,
# Friday: 00000000, 11111111,  11110000,
# Saturday: 00000000, 11111111,  11110000,


# So each day is 0,255,240

$logonhours=@{"Logonhours"= [byte[]]$hours=@(0, 255, 240, 0, 255, 240, 0, 255, 240, 0, 255, 240, 0, 255, 240, 0, 255, 240, 0, 255, 240, 0, 255, 240)}


# Hope this works!!
Set-GPRegistryValue -Guid $GPO.Id -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName "LogonHours" -Type Binary -Value $LogonHours.LogonHours


# Lets create a report   
Get-GPOReport $GPO.id -ReportType XML -Path "C:\Users\Administrator\scripts\Test_report.xml"

# We can view it here:
notepad.exe "C:\Users\Administrator\scripts\Test_report.xml"


# Edit as needed - applypermssion
Set-GPPermissions -Guid $GPO.Id -TargetName traveldepartment -TargetType Group -PermissionLevel GpoApply