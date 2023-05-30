###START OF: DHCP#####

Get-WindowsFeature | Where-Object Name -like *dhcp* 
Install-WindowsFeature DHCP -IncludeManagementTools 

Add-DhcpServerv4Scope -Name “OfficeScope" -StartRange 192.168.1.20 -EndRange 192.168.1.150 -SubnetMask 255.255.255.0 

Set-DhcpServerv4OptionValue -DnsDomain ad.Mediholidays.local -DnsServer 192.168.1.2 -Router 192.168.1.2 

Add-DhcpServerInDC -DnsName dhcp.Mediholidays.local

#Create a  mac reservation as we will manually add the servers later
$webservermac = "00-11-22-33-44-55"
$fileservermac = "00-22-44-66-88-aa"
Add-dhcpserverv4reservation –scopeid 192.168.1.0 –ipaddress 192.168.1.10 –name webserver –description "Web server" –clientid $webservermac 
Add-DhcpServerv4Reservation -scopeid 192.168.1.0 -IPAddress 192.168.1.11 -name fileserver -Description "file Server" -ClientId $fileserver



#view the reservations
Get-dhcpserverv4reservation –scopeid 192.168.1.0 




Get-DhcpServerv4ExclusionRange


###END OF: DHCP#### 
