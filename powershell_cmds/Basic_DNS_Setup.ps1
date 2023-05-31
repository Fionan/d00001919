###DNS###

#not needed on AD/DNS one pc only
#Get-WindowsFeature -Name DNS
#Install-WindowsFeature -Name DNS -IncludeManagementTools
#Add-DnsServerPrimaryZone -Name "Mediholidays.local" -ReplicationScope "Forest"

Add-DnsServerResourceRecordA -Name "dhcp" -ZoneName "Mediholidays.local" -IPv4Address "192.168.1.2"

Add-DnsServerResourceRecordA -Name "web" -ZoneName "Mediholidays.local" -IPv4Address "192.168.1.12"

Add-DnsServerResourceRecordA -Name "files" -ZoneName "Mediholidays.local" -IPv4Address "192.168.1.15"

###End of DNS### 
