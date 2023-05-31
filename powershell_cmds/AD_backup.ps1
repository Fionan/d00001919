# Connect to the Samba share with a persistant network mapped "z" drive we will be prompoted for the password
$cred = Get-Credential -Credential "AD_BACKUP_USER"
New-PSDrive –Name "Z" –PSProvider FileSystem –Root "\\files.mediholiday.local\AD_BACKUPS" –Credential $cred –Persist

# creating a back up would be using the wbamin command with 
#wbadmin start backup -backuptarget:Z: -include:c:\*, -allcritical -systemstate

# Create a Sceduled dask to Backup server once per day
$action = New-ScheduledTaskAction -Execute 'wbadmin' -Argument 'start backup -backuptarget:Z: -include:c:\*, -allcritical -systemstate'
$trigger = New-ScheduledTaskTrigger -Daily -At 12:00pm
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "DailyBackup"
