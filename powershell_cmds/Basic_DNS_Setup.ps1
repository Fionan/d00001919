###DNS###

#not needed on AD/DNS one pc only
#Get-WindowsFeature -Name DNS
#Install-WindowsFeature -Name DNS -IncludeManagementTools
#Add-DnsServerPrimaryZone -Name "Mediholidays.local" -ReplicationScope "Forest"

Add-DnsServerResourceRecordA -Name "dhcp" -ZoneName "Mediholidays.local" -IPv4Address "192.168.1.2"


###End of DNS### 
