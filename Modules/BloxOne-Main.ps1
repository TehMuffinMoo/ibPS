<#
.SYNOPSIS
   BloxOne REST API for PowerShell
.DESCRIPTION
   A collection of PowerShell Cmdlets to interact with the InfoBlox BloxOne DDI REST API located at https://csp.infoblox.com/apidocs
   Also supports some limited Cmdlets for InfoBlox NIOS (Grid).
.NOTES
   Work in progress, some cmdlets are limited in their nature.
.AUTHOR
   Mat Cox
.VERSION
   v0.7
.CHANGELOG
   v0.1 - 17/05/2022 - Initial commit
   v0.2 - 18/05/2022 - Addition of a number of new Cmdlets, still developing..
   v0.3 - 26/05/2022 - Bug fixes, addition of Set-B1Subnet & Set-B1AddressBlock
   v0.4 - 30/05/2022 - Added hard dependency to check API key for BloxOne is stored.
   v0.5 - 06/07/2022 - Various changes, cleanup, update cmdlet docs, etc.
   v0.6 - 26/07/2022 - Finally a new release.. lots of changes :)
   v0.7 - 24/10/2022 - I guess it's that time again
   v0.8 - 20/04/2023 - Definitely in need of a new version no.
.CMDLETS

  # Most Get-* cmdlets implement a -Strict parameter which applies strict name checking. Where possible, the default is to perform wildcard lookups on submitted parameters.

  Query-CSP -Method GET/POST/PUT/PATCH/DELETE -Uri URI -Data JSON
    This is a core function for interacting with the REST API of CSP

  Query-NIOS -Method GET/POST/PUT/PATCH/DELETE -Uri URI -Data JSON
    This is a core function for interacting with the REST API of NIOS

  Store-B1APIKey -APIKey "longapikeystringgoeshere"
    Stores API Key for BloxOne within environment variables

  Get-B1APIKey
    Retrieves stored API Key for BloxOne
    
  Get-ibPSVersion
    Gets the ibPS Module Version
  
  Store-NIOSCredentials -Credentials ${CredentialObject -Persist
    Stores NIOS Credentials encrypted, can be run without -Credentials parameter for it to prompt instead. The optional -Persist parameter will persist the credentials for that user on that machine. This requires a restart of the powershell session before credentials can be used.

  Get-NIOSCredentials
    Retrieves stored NIOS Credentials for BloxOne

  Get-B1AuditLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -Method "POST" -Action "Create" -ClientIP "1.2.3.4" -ResponseCode "200"
    Retrieves a listing of all audit logs, optionally limiting the number of results by using an offset or the various filters.

  Get-B1ServiceLog -OnPremHost "bloxoneddihost1.mydomain.corp" -Container "DNS" -Start (Get-Date).AddHours(-2)
    Retrieves service related logs. Container options include DNS, DHCP, NTP, DFP, Host, Kube & NetworkMonitor.

  Get-B1SecurityLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -App "nginx" -Type "nginx.access" -Domain "prod.mydomain.corp"
    Retrieves CSP security logs, optionally limiting the number of results by using an offset or the various filters.

  Get-B1DNSLog -Source "10.177.18.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 100 -Offset 0
    Retrieves all DNS logs from BloxOneDDI with various filter options.

  Get-B1DFPLog -Source "10.177.18.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 100 -Offset 0
    Retrieves all DNS Forwarding Proxy logs from BloxOneDDI with various filter options.
  
  Get-B1DHCPLog -Hostname "dhcpclient.mydomain.corp" -State "Assignments" -IP "10.10.10.100" -Protocol "IPv4 Address" -DHCPServer "bloxoneddihost1.mydomain.corp" -Start (Get-Date).AddHours(-24) -End (Get-Date) -Limit 100 -Offset 0
    Retrieves all DHCP logs from BloxOneDDI with various filter options.

  Get-B1Space -Name "Global"
    Retrieves a listing of all BloxOne Spaces or a single result when using -Name

  Get-B1AddressBlock -Subnet "10.10.100.0/12" -Space "Global"
    Retrieves a listing of all BloxOne Address Blocks, optionally filtering by Subnet and Space.

  Get-B1AddressBlockNextAvailable -ParentAddressBlock 10.0.0.0/8 -Space Global -SubnetCIDRSize 24 -SubnetCount 5
    Retrieves X number of next available address blocks for creation

  Get-B1Subnet -Subnet "10.10.100.0"
    Retrieves a listing of all BloxOne Subnets or a single result when using -Subnet. The subnet should be used without the CIDR suffix.

  Get-B1Range -StartAddress "10.10.100.200" -EndAddress "10.10.100.250"
    Retrieves a listing of all DHCP Ranges, optionally filtering by using the -StartAddress or -EndAddress parameter.
  
  Get-B1Address -Address "10.0.0.1" -Reserved -Fixed
    Retrieves a list of addresses from IPAM, optionally filtering by -Address or the -Reserved & -Fixed flags.

  Get-B1HAGroup -Name "MyHAGroup"
    Retrieves a listing of all DHCP HA Groups, or a single result when using the optional -Name parameter.

  Get-B1OnPremHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10" (WILL BE DEPRECATED AUGUST 2023 - Use Get-B1Host instead)
    Retrieves a listing of all registered On-Prem hosts within BloxOne, optionally filtering by using the -Name or -IP parameters. A bespoke switch exists (-BreakOnError) which breaks out of the script upon errors.
  
  Get-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10" -OPHID "OnPremHostID" -Space "Global" -Limit "100" -Status "degraded" -Detailed
    Retrieves a listing of all registered On-Prem hosts within BloxOne, optionally filtering by using the -Name or -IP parameters. A bespoke switch exists (-BreakOnError) which breaks out of the script upon errors.
    Using -Detailed returns service health information and allows returning more than 101 results, which is configurable via the -Limit parameter.
  
  Get-B1BootstrapConfig -Name "bloxoneddihost1.mydomain.corp"
    Retrieves On Prem Host bootstrap config (Network/NTP/etc.)

  Get-B1DNSConfigProfile -Name "Edge Profile"
    Retrieves a lsiting of all DNS Configuration Profiles, optionally filtering by using the -Name parameter.

  Get-B1DHCPConfigProfile -Name "Edge Profile"
    Retrieves a lsiting of all DHCP Configuration Profiles, optionally filtering by using the -Name parameter.

  Get-B1DHCPHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"
    Retrieves a listing of all BloxOne appliances with DHCP Enabled, optionally filtering by using the -Name or -IP parameters.

  Get-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"
    Retrieves a listing of all BloxOne appliances with DNS Enabled, optionally filtering by using the -Name or -IP parameters.

  Get-B1Tag -Name "siteCode"
    Retrieves a listing of all BloxOne Tags, optionally filtering by using the -Name parameter.

  Get-B1DNSView -Name "Global"
    Retrieves a listing of all BloxOne DNS Views, optionally filtering by using the -Name parameter.

  Get-B1DNSACL -Name "Secure_Subnets"
    Retrieves a listing of all BloxOne DNS ACLs, optionally filtering by using the -Name parameter.

  Get-B1ForwardZone -FQDN "prod.mydomain.corp"
    Retrieves a listing of all BloxOne Forward DNS Zones, optionally filtering by using the -FQDN parameter.

  Get-B1AuthoritativeZone -FQDN "prod.mydomain.corp"
    Retrieves a listing of all BloxOne Authorative DNS Zones, optionally filtering by using the -FQDN parameter.

  Get-B1DelegatedZone -FQDN "prod.mydomain.corp"
    Retrieves a listing of all BloxOne Delegated DNS Zones, optionally filtering by using the -FQDN parameter.

  Get-B1DHCPOptionCode -Name "routers"
    Retrieves a listing of all DHCP option codes, optionally filtering by using the -Name parameter.

  Get-B1DHCPOptionGroup -Name "Printers Group"
    Retrieves a listing of all DHCP option groups, optionally filtering by using the -Name parameter.

  Get-B1DHCPOptionSpace -Name "Printers Space"
    Retrieves a listing of all DHCP option spaces, optionally filtering by using the -Name parameter.

  Get-B1DHCPGlobalConfig
    Gets the Global DHCP configuration of BloxOneDDI

  Get-B1Record -Type A -Name "ns2" -rdata "10.10" -Zone "prod" | ft name_in_zone,absolute_zone_name,dns_rdata,ttl,type
    Retrieves a listing of all DNS records, optionally filtering by -Type and -rdata parameters.
  
  Get-B1AuthoritativeNSG -Name "Data Centre"
    Retrieves a listing of all Authorative Name Server Groups, optionally filtering by the -Name parameter.
  
  Get-B1ForwardNSG -Name "Azure Wire IP"
    Retrieves a listing of all Forward Name Server Groups, optionally filtering by the -Name parameter.

  Get-B1DHCPLease -Address "10.10.50.222" -MACAddress "01:02:ab:cd:ef:34:56" -Hostname "workstation1.prod.mydomain.corp" -Space "Global"
    Retrieves a listing of all DHCP Leases, optionally filtering by Address/MAC/Hostname/etc.

  Get-B1DNSUsage -Address "10.10.50.222" -Space "Global"
    A useful command to return any records associated with a particular IP.
  
  Get-B1HealthCheck -ApplicationHealth
    Retrieves health for on-prem hosts
  
  Get-B1Applications
    Retrieves a list of supported service types
  
  Get-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
    Retrieves a list of deployed BloxOneDDI Services
  
  Start-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
    Starts a BloxOneDDI Service

  Stop-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
    Stops a BloxOneDDI Service
  
  Get-B1GlobalNTPConfig
    Gets the global NTP Configuration defined within BloxOneDDI
  
  Get-B1NTPServiceConfiguration
    Retrieves the NTP Configuration for an NTP Service
  
  Get-B1TopMetrics -TopQueries DFP -TopCount 50 -Start (Get-Date).AddDays(-1)
    Query top metric templates. -TopQueries can be used with the -QueryType parameter and -TopClients can be used with the -TopClientLogType parameter.

  Get-NIOSDelegatedZone -Server "NIOSipOrHostname" -Creds "CredentialObjectForNIOS" -FQDN "dev.mydomain.corp"
    Retrieves a listing of all Delegated DNS Zones within InfoBlox NIOS (Grid), optionally filtering by using the -FQDN parameter.

  Get-NIOSAuthorativeZone -Server "NIOSipOrHostname" -Creds "CredentialObjectForNIOS" -FQDN "dev.mydomain.corp"
    Retrieves a listing of all Authorative DNS Zones within InfoBlox NIOS (Grid), optionally filtering by using the -FQDN parameter.

  Get-NIOSForwardZone -Server "NIOSipOrHostname" -Creds "CredentialObjectForNIOS" -FQDN "dev.mydomain.corp"
    Retrieves a listing of all Forward DNS Zones within InfoBlox NIOS (Grid), optionally filtering by using the -FQDN parameter.

  New-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Host "bloxoneddihost1.mydomain.corp" -NTP -DNS -DHCP
    Deploys a new BloxOneDDI Service

  New-NIOSDelegatedZone -Server "NIOSipOrHostname" -Creds "CredentialObjectForNIOS" -FQDN "dev.mydomain.corp" -View "default" -Hosts @(@{"address"="10.10.50.222";"name"="bloxoneddihost2.dev.mydomain.corp";}))
    Creates a new Delegated DNS Zone within InfoBlox NIOS (Grid) and assigns delegate nameservers using the -Hosts parameter. This parameter accepts an array where each item contains a key/value pair for "address" and "name".

  New-B1AuthoritativeZone -FQDN "prod.mydomain.corp" -View "Global" -DNSHosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp" -Description "Prod Zone"
    Creates a new Authorative DNS Zone within BloxOne.
  
  New-B1ForwardZone -FQDN "prod.mydomain.corp" -View "Global" -Forwarders "10.10.10.20","10.20.10.20" -DNSHosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp" -Description "Prod Zone"
    Creates a new Forward DNS Zone within BloxOne.

  New-B1Subnet -Subnet "10.10.100.0" -CIDR "24" -Space "Global" -Name "Prod Subnet" -HAGroup "MyHAGroup" -Description "Prod Subnet" -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";})
    Creates a new subnet within BloxOne, with the option of attaching it to a DHCP HA Group and specifying one or more DHCP options to be applied at a subnet level. -DHCPOptions accepts an array and option codes can be found using the Get-B1DHCPOptionCode Cmdlet.

  New-B1AddressBlock -Subnet "10.30.0.0" -CIDR "20" -Space "Global" -Name "Test" -Description "Test Subnet" -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.30.2.10,10.30.2.11";})
    Creates a new Address Block within BloxOne, with the option of specifying one or more DHCP options to be applied at a Address Block level. -DHCPOptions accepts an array and option codes can be found using the Get-B1DHCPOptionCode Cmdlet.

  New-B1HAGroup -Name "MyHAGroup" -Space "Global" -Mode "active-passive" -PrimaryNode "bloxoneddihost1.mydomain.corp" -SecondaryNode "bloxoneddihost2.mydomain.corp" -Description "DHCP HA Group"
    Creates a new DHCP HA Group within BloxOne. Modes can include "active-active" or "active-passive". In Active/Passive, the -SecondaryNode parameter becomes the passive node.

  New-B1OnPremHost -Name "bloxoneddihost3.mydomain.corp" -Space "Global" -Description "Infra Node A" (WILL BE DEPRECATED AUGUST 2023 - Use New-B1Host instead)
    Creates an On-Prem host within BloxOne and returns the API Key used for registration of the appliance.
  
  New-B1Host -Name -Name "bloxoneddihost3.mydomain.corp" -Space "Global" -Description "Infra Node A"
    Creates a host within BloxOne.

  New-B1Range -Name "Client Range" -StartAddress "10.250.20.20" -EndAddress "10.250.20.100" -Space "Global" -Description "Range for Client IPs"
    Creates a new DHCP range within a configured subnet. The appropriate subnet is identified by the Start/End addresses used.

  New-B1AddressReservation -Address "10.0.0.1" -Name "MyReservedHost" -Description "My Reserved Host" -Space "Global"
    Creates an IP Reservation within IPAM. This is not a DHCP Reservation, see fixed addresses for that.
  
  New-B1DHCPConfigProfile -Name "Profile Name" -Description "Profile Description" -DHCPOptions @() -DDNSZones "prod.mydomain.corp","100.10.in-addr.arpa"
    Creates a new DHCP Config Profile, optionally specifying DHCP Options & permitted DDNS Zones.

  New-B1Record -Type "A" -Name "myrecord" -Zone "prod.mydomain.corp" -rdata "10.1.1.10" -TTL "60" -CreatePTR $false -Description "My Server"
    Creates a new DNS record. Use the -TTL parameter to override the TTL of the parent DNS Zone and -CreatePTR can be set to $false if you don't want PTRs automatically creating.
  
  New-NIOSRecord -Type "A" -Name "myrecord" -Zone "prod.mydomain.corp" -rdata "10.1.1.10" -Description "My Server"
    Creates a new DNS record. Use the -TTL parameter to override the TTL of the parent DNS Zone and -CreatePTR can be set to $false if you don't want PTRs automatically creating.

  Remove-B1Record -Type "A" -Name "myrecord" -Zone "prod.mydomain.corp"
    Removes a DNS record.

  Remove-B1AuthoritativeZone -Type "A" -Name "myrecord" -Zone "prod.mydomain.corp"
    Removes a DNS record.

  Remove-B1AddressReservation -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
    Removes an IP Reservation from IPAM. This is not a DHCP Reservation, see fixed addresses for that.

  Remove-B1AddressBlock -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
    Removes an Address Block from IPAM.

  Remove-B1Subnet -Address "10.0.0.1" -Space "Global"
    Removes a Subnet from IPAM.

  Remove-B1OnPremHost -Name "bloxoneddihost1.mydomain.corp" (WILL BE DEPRECATED AUGUST 2023 - Use New-B1Host instead)
    Removes an On-Prem host from within BloxOne.
  
  Remove-B1Host -Name "bloxoneddihost1.mydomain.corp"
    Removes a host from within BloxOne.

  Remove-B1DNSConfigProfile -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    Used to remove DNS Configuration Profiles from BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.

  Remove-B1DHCPConfigProfile -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    Used to remove DHCP Configuration Profiles from BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.
  
  Remove-B1Range -Start "10.250.20.20" -End "10.250.20.100"
    Used to remove a DHCP Range

  Set-B1OnPremHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.10" -TimeZone "Europe/London" -Space "Global" (WILL BE DEPRECATED AUGUST 2023 - Use Set-B1Host instead)
    Newly registered devices are given a random name which is updated when using the -IP and -Name parameters together. -IP is used to reference the object, -Name is used as the updated DNS Name. TimeZone and Space can also be configured using this cmdlet.

  Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"
    Newly registered devices are given a random name which is updated when using the -IP and -Name parameters together. -IP is used to reference the object, -Name is used as the updated DNS Name. TimeZone and Space can also be configured using this cmdlet.

  Set-B1AddressBlock -Subnet "10.10.100.0" -Name "MySupernet" -Space "Global" -Description "Comment for description" -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name   "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";})
    Used to update settings on an existing Address Block.

  Set-B1Subnet -Subnet "10.10.10.0" -Name "MySubnet" -Space "Global" -Description "Comment for description" -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "router").id;"option_value"="10.10.10.1";})
    Used to update settings on an existing BloxOne Subnet.
  
  Set-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 -Description -Tags @{"siteCOde"="12345"}
    Used to update settings associated with a DHCP Range

  Set-B1Record -Type "A" -Name "test" -Zone "app1.prod.mydomain.corp" -rdata "10.10.100.225" -TTL "60" -Description "My App"
    Used to update the configuration of an existing DNS record.

  Set-B1ForwardZone -FQDN "azurecr.io" -View "default" -Forwarders "10.10.10.10","10.20.20.20" -DNSHosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    Used to set DNS Forwarders / Hosts on an existing Forward Zone. -DNSServerGroups can optionally be used to apply a server group, but this will overwrite any existing Forwarders or DNS Hosts. (Generally desirable as they would be in the Group!)

  Set-B1AuthoritativeZone -FQDN "prod.mydomain.corp" -View "default" -DNSHosts "bloxoneddihost1.prod.mydomain.corp","bloxoneddihost2.prod.mydomain.corp" -AuthNSGs "Data Centre" -Description "Production DNS Zone"
    Used to change the configuration of an existing Authoritative DNS Zone.

  Set-B1ForwardNSG -Name "InfoBlox DTC" -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    Used to change the configuration of an existing Forward Name Server Group. Primary use case is for adding/removing hosts from the group using -AddHosts or -RemoveHosts respectively.

  Set-B1NTPServiceConfiguration -Name "ntp_bloxoneddihost1.mydomain.corp" -UseGlobalNTPConfig
    Used to set the NTP configuration for a particular service
  
  Set-B1DHCPConfigProfile -AddDDNSZones -DDNSZones "prod.mydomain.corp","100.10.in-addr.arpa" -DNSView "default"
    Used for setting global DHCP configuration. Primarily for Adding/Removing internal DDNS Zones. -RemoveDDNSZones can be used to remove zones instead.

  Set-B1DHCPGlobalConfig -AddDDNSZones -DDNSZones "prod.mydomain.corp","dev.mydomain.corp" -DNSView "default"
    Used for setting global DHCP configuration. Primarily for Adding/Removing internal DDNS Zones. -RemoveDDNSZones can be used to remove zones instead.
	
  Enable-B1OnPremHostApplication -Name "bloxoneddihost1.mydomain.corp" -DNS -DHCP -NTP
    Allows you to enable BloxOne On-Prem Host Applications using the DNS/DHCP/NTP switches

  Disable-B1OnPremHostApplication -Name "bloxoneddihost1.mydomain.corp" -DNS -DHCP -NTP
    Allows you to Disable BloxOne On-Prem Host Applications using the DNS/DHCP/NTP switches
  
  Apply-B1HostDNSConfigProfile -Name "Edge Profile" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    Used to add DNS Configuration Profiles to BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.

  Apply-B1HostDHCPConfigProfile -Name "Edge Profile" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    Used to add DHCP Configuration Profiles to BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.
  
  Set-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -DNSConfigProfile "Data Centre" -DNSName "bloxoneddihost1.mydomain.corp"
    Used to configure the DNS Config Profile and Critically the DNS Server Name.

  Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -DNSConfig -DNSData -IPAMData -KeyData -ThreatDefense -Bootstrap -OnPremHosts -Redirects -Tags
    Used to start a configuration export job. Can optionally also use -BackupAll instead of specifying all parameters.

  Get-B1Export -data_ref "BloxOne Backup-1ed34a08-6806-4c17-9f94-6645521c0e23.json" -filepath "C:\temp\configuration.json"
    Used to save a configuration export job to disk. data_ref can be found by running Get-B1BulkOperation

  Get-B1BulkOperation -id "1ed34a08-6806-4c17-9f94-6645521c0e23"
    Used to list all export/import operations, optionally filtering by id.
  
  Search-B1 -Query "search term"
    Used to perform a global search of the BloxOneDDI Cloud Services Portal

  Migrate-NIOSSubzoneToBloxOne -Server "10.100.10.10" -Subzone "dev.mydomain.corp" -View "default" -Confirm:$false
    Used to migrate DNS Subzone data from InfoBlox NIOS to InfoBlox BloxOne.

  Deploy-B1Appliance -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.100.10" -Netmask "255.255.255.0" -Gateway "10.10.100.1" -DNSServers "10.30.10.10,10.30.10.10" -NTPServers "time.mydomain.corp" -DNSSuffix "prod.mydomain.corp" -JoinToken "JoinTokenGoesHere" -OVAPath .\BloxOne_OnPrem_VMWare_v3.1.0-4.3.10.ova -vCenter "vcenter.mydomain.corp" -Cluster "CLUSTER-001" -Datastore "DATASTORE-001" -PortGroup "PORTGROUP" -PortGroupType "VDS"
    Used to deploy the BloxOne Virtual Appliance. Requires VMware PowerCLI to be installed. All parameters are mandatory. -PortGroupType can be Standard or VDS.
	
  #################################################
  ############ Miscellaneous Functions ############
  #################################################
  
  Combine-Filters -Filters "action~`"create`"","user_name~`"my.name@domain.com`""
    Used to combine a series of filters for the BloxOne API.
	
  Get-ConfigFile -path "path"
    Convert an .ini file into a PSObject
	
  ConvertTo-IPv4MaskString -MaskBits "24"
    Used to convert CIDR to subnet mask. I.e /24 will return 255.255.255.0
	
  Test-IPv4MaskString -MaskString "255.255.255.0"
	Tests if subnet mask is valid. Returns boolean.

  ConvertTo-IPv4MaskBits -MaskString "255.255.255.0"
    Used to convert subnet mask to CIDR. I.e 255.255.255.0 will return /24
  

#>

## Supported Applications for Deployment to On-Premise hosts
$SupportedApplications = "DHCP","DNS","NTP"
## Enable Debug Logging (Mainly @splat outputs)
$Debug = $false

## Import Functions
$B1PublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneDDI\*.ps1"
$B1PrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneDDI\Private\*.ps1"
$NIOSPublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\*.ps1"
$NIOSPrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\Private\*.ps1"
$AdditionalFunctionsToImport = "Get-ibPSVersion"

foreach($FunctionToImport in @($B1PublicFunctions + $B1PrivateFunctions + $NIOSPublicFunctions + $NIOSPrivateFunctions)) {
  try {
    . $FunctionToImport.fullname
  } catch {
    Write-Error "Failed to import function $($FunctionToImport.fullname)"
  }
}

Export-ModuleMember -Function ($(@($B1PublicFunctions + $NIOSPublicFunctions) | Select -ExpandProperty BaseName) + $AdditionalFunctionsToImport) -Alias *

function Get-B1OnPremHost {
    param(
      [String]$Name,
      [String]$IP,
      [String]$OPHID,
      [String]$Space,
      [String]$Status,
      [switch]$BreakOnError,
      [switch]$Reduced,
      [switch]$Strict = $false,
      [switch]$NoIPSpace
    )
    DeprecationNotice -Date "01/08/23" -Command "Get-B1OnPremHost" -AlternateCommand "Get-B1Host"
	$MatchType = Match-Type $Strict

    if ($Space) {$IPSpace = (Get-B1Space -Name $Space -Strict).id}

    [System.Collections.ArrayList]$Filters = @()
    if ($IP) {
        $Filters.Add("ip_address$MatchType`"$IP`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("display_name$MatchType`"$Name`"") | Out-Null
    }
    if ($OPHID) {
        $Filters.Add("ophid$MatchType`"$OPHID`"") | Out-Null
    }
    if ($Space) {
        $Filters.Add("ip_space==`"$IPSpace`"") | Out-Null
    }
    if ($Status) {
        $Filters.Add("composite_status==`"$Status`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts?_filter=$Filter" | Select -ExpandProperty result -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts" | Select -ExpandProperty result -ErrorAction SilentlyContinue
    } 
    
    if ($Results) {
        if ($NoIPSpace) {
            $Results = $Results | where {!($_.ip_space)}
        }
        if ($Reduced) {
            return $Results | Select display_name,ip_address,description,host_subtype,host_version,mac_address,nat_ip,last_seen,updated_at
        } else {            
            return $Results
        }
    } else {
        if ($Name) {
            if ($BreakOnError) {
                Write-Host "Error. No On-Prem Host(s) found matching $Name." -ForegroundColor Red
            }
        } else {
            Write-Host "No On-Prem Host(s) found." -ForegroundColor Gray
        }
        if ($BreakOnError) {
            break
        }
    }
}

function New-B1OnPremHost {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [String]$Description
    )
    DeprecationNotice -Date "01/08/23" -Command "New-B1OnPremHost" -AlternateCommand "New-B1Host"
    if (Get-B1OnPremHost -Name $Name) {
        Write-Host "$Name already exists as an On-Prem host." -ForegroundColor Red
        break
    }

    $splat = @{
        "display_name" = $Name
        "ip_space" = (Get-B1Space -Name $Space -Strict).id
        "description" = $Description
    }

    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}

    $Result = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
    $Result
    if ($Result.display_name -eq $Name) {
        Write-Host "On-Prem host $Name created successfully." -ForegroundColor Green
        $RegistrationAPIKey = $Result.api_key
        Write-Host "The following API Key should be used to register this BloxOne Appliance: $RegistrationAPIKey" -ForegroundColor Gray
    } else {
        Write-Host "Failed to create On-Prem host $Name." -ForegroundColor Red
    }
}

function Remove-B1OnPremHost {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name
    )
    DeprecationNotice -Date "01/08/23" -Command "Remove-B1OnPremHost" -AlternateCommand "Remove-B1Host"
    $hostID = (Get-B1OnPremHost -Name $Name).id
    if ($hostID) {
        Query-CSP -Method DELETE -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts/$hostID"
        $hostID = (Get-B1OnPremHost -Name $Name).id
        if ($hostID) {
            Write-Host "Error. Failed to delete On-Prem host $Name" -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted on-prem host" -ForegroundColor Green
        }
    } else {
        Write-Host "Error. Unable to find Host ID from name: $Name" -ForegroundColor Red
    }
}

function Set-B1OnPremHost {
    param(
      [String]$Name,
      [String]$IP,
      [String]$TimeZone,
      [String]$Space,
      [String]$Description,
      [switch]$NoIPSpace,
      [System.Object]$Tags
    )
    DeprecationNotice -Date "01/08/23" -Command "Set-B1OnPremHost" -AlternateCommand "Set-B1Host"
    if ($IP) {
        if ($NoIPSpace) {
            $OnPremHost = Get-B1OnPremHost -IP $IP -NoIPSpace:$NoIPSpace
        } else {
            $OnPremHost = Get-B1OnPremHost -IP $IP -Space $Space
        }
        if (!($OnPremHost)) {
            Write-Host "On-Prem Host $IP does not exist." -ForegroundColor Gray
        }
        $hostID = $OnPremHost.id
    } elseif ($Name) {
        if ($NoIPSpace) {
            $OnPremHost = Get-B1OnPremHost -Name $Name -NoIPSpace:$NoIPSpace
        } else {
            $OnPremHost = Get-B1OnPremHost -Name $Name -Space $Space
        }
        if (!($OnPremHost)) {
            Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
        }
        $hostID = $OnPremHost.id
    }
    $OnPremHost.display_name = $Name
    if ($TimeZone) {$OnPremHost.timezone = $TimeZone}
    if ($Space) {
        if ($OnPremHost.ip_space) {
            $OnPremHost.ip_space = (Get-B1Space -Name $Space -Strict).id
        } else {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "ip_space" -Value (Get-B1Space -Name $Space -Strict).id
        }
    }
    if ($Description) {
        if ($OnPremHost.description) {
            $OnPremHost.description = $Description
        } else {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "description" -Value $Description
        }
    }
    if ($Tags) {
        if ($OnPremHost.tags) {
            $OnPremHost.tags = $Tags
        } else {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }
    }

    $splat = $OnPremHost | ConvertTo-Json -Depth 10
    if ($Debug) {$splat}

    $Results = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts/$hostID" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
    if ($Results.display_name -eq $Name) {
        Write-Host "Updated On-Prem Host Configuration $Name successfuly." -ForegroundColor Green
    } else {
        Write-Host "Failed to update On-Prem Host Configuration on $Name." -ForegroundColor Red
    }

}

function Enable-B1OnPremHostApplication {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Switch]$DNS,
      [Switch]$DHCP,
      [Switch]$NTP
    )
    DeprecationNotice -Date "01/08/23" -Command "Enable-B1OnPremHostApplication" -AlternateCommand "New-B1Service"
    $OnPremHost = Get-B1OnPremHost -Name $Name
    if (!($OnPremHost)) {
        Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
    } else {
        $hostID = $OnPremHost.id
        $AppList = New-Object System.Collections.ArrayList
        if ($DNS -or $DHCP -or $NTP) {
            if ($DHCP) {
                if (($OnPremHost.applications | where {$_.application_type -eq "3"}).disabled -ne "0") {
                    Write-Host "DHCP will be enabled." -ForegroundColor Gray
                    $AppList.Add(@{"disabled"="0";"application_type"="3";"state"=@{"state_space"="13";"desired_state"="1"}}) | Out-Null
                } else {
                    Write-Host "DHCP is already enabled." -ForegroundColor Yellow
                }
            }
            if ($DNS) {
                if (($OnPremHost.applications | where {$_.application_type -eq "2"}).disabled -ne "0") {
                    Write-Host "DNS will be enabled." -ForegroundColor Gray
                    $AppList.Add(@{"disabled"="0";"application_type"="2";"state"=@{"state_space"="10";"desired_state"="1"}}) | Out-Null
                } else {
                    Write-Host "DNS is already enabled." -ForegroundColor Yellow
                }
            }
            if ($NTP) {
                if (($OnPremHost.applications | where {$_.application_type -eq "20"}).disabled -ne "0") {
                    Write-Host "NTP will be enabled." -ForegroundColor Gray
                    $AppList.Add(@{"disabled"="0";"application_type"="20";"state"=@{"state_space"="62";"desired_state"="1"}}) | Out-Null
                } else {
                    Write-Host "NTP is already enabled." -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "No application specified to deploy." -ForegroundColor Gray
        }

        if (!($OnPremHost.applications)) {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "applications" -Value $AppList
        } else {
            $OnPremHost.applications = $AppList
        }
        $splat = $OnPremHost | ConvertTo-Json -Depth 10
        if ($Debug) {$splat}
        $Result = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts/$hostID" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Debug) {$Result}

        if ($Result.display_name -eq $Name) {
            Write-Host "Enabled applications on BloxOne On-Prem Host $Name successfuly." -ForegroundColor Green
        } else {
            Write-Host "Failed to update On-Prem Host $Name." -ForegroundColor Red
        }
    }
}

function Disable-B1OnPremHostApplication {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Switch]$DNS,
      [Switch]$DHCP,
      [Switch]$NTP
    )
    DeprecationNotice -Date "01/08/23" -Command "Disable-B1OnPremHostApplication" -AlternateCommand "Remove-B1Service"
    $OnPremHost = Get-B1OnPremHost -Name $Name
    if (!($OnPremHost)) {
        Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
    } else {
        $hostID = $OnPremHost.id
        $AppList = New-Object System.Collections.ArrayList
        if ($DNS -or $DHCP -or $NTP) {
            if ($DHCP) {
                if (($OnPremHost.applications | where {$_.application_type -eq "3"}).disabled -eq "0") {
                    Write-Host "DHCP will be disabled." -ForegroundColor Gray
                    $AppList.Add(@{"disabled"="1";"application_type"="3";"state"=@{"state_space"="13";"desired_state"="0"}}) | Out-Null
                } else {
                    Write-Host "DHCP is already disabled." -ForegroundColor Yellow
                }
            }
            if ($DNS) {
                if (($OnPremHost.applications | where {$_.application_type -eq "2"}).disabled -eq "0") {
                    Write-Host "DNS will be disabled." -ForegroundColor Gray
                    $AppList.Add(@{"disabled"="1";"application_type"="2";"state"=@{"state_space"="10";"desired_state"="0"}}) | Out-Null
                } else {
                    Write-Host "DNS is already disabled." -ForegroundColor Yellow
                }
            }
            if ($NTP) {
                if (($OnPremHost.applications | where {$_.application_type -eq "20"}).disabled -eq "0") {
                    Write-Host "NTP will be disabled." -ForegroundColor Gray
                    $AppList.Add(@{"disabled"="1";"application_type"="20";"state"=@{"state_space"="62";"desired_state"="0"}}) | Out-Null
                } else {
                    Write-Host "NTP is already disabled." -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "No application specified to disable." -ForegroundColor Gray
        }

        $OnPremHost.applications = $AppList
        $splat = $OnPremHost | ConvertTo-Json -Depth 10
        if ($Debug) {$splat}
        $Result = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/host_app/v1/on_prem_hosts/$hostID" -Data $splat | select -ExpandProperty result
        if ($Debug) {$Result}

        if ($Result.display_name -eq $Name) {
            Write-Host "Disabled applications on BloxOne On-Prem Host $Name successfuly." -ForegroundColor Green
        } else {
            Write-Host "Failed to update On-Prem Host $Name." -ForegroundColor Red
        }
    }
}



function New-NIOSRecord {
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [String]$rdata,
      [Parameter(Mandatory=$true)]
      [String]$view,
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Description
    )
    
    $SupportedRecords = "A"
    if (!($Type -in $SupportedRecords)) {
        Write-Host "Invalid type specified. The following record types are supported: $SupportedRecords" -ForegroundColor Red
        break
    }

    switch ($Type) {
      "A" {
        $splat = @{
            "ipv4addr" = $rdata
            "name" = $FQDN
            "view" = $view
            "comment" = $Description
        }
      }
    }

    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}

    $Result = Query-NIOS -Method POST -Server $Server -Uri "record:$Type" -Data $splat

    if ($Result) {
        Write-Host "Created DNS Record $FQDN successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to create DNS Record $FQDN." -ForegroundColor Red
    }

}

function Get-NIOSDelegatedZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      $Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated?_return_as_object=1" -Creds $Creds | select -ExpandProperty results | where {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated?_return_as_object=1" -Creds $Creds | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-NIOSAuthorativeZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      $Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_auth?_return_as_object=1" -Creds $Creds | select -ExpandProperty results | where {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_auth?_return_as_object=1" -Creds $Creds | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-NIOSForwardZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      $Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_forward?_return_as_object=1" -Creds $Creds | select -ExpandProperty results | where {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_forward?_return_as_object=1" -Creds $Creds | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function New-NIOSDelegatedZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [System.Object]$Hosts,
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      $Creds
    )
    if (Get-NIOSDelegatedZone -Server $Server -Creds $Creds -FQDN $FQDN) {
        Write-Host "Error. Delegated zone already exists." -ForegroundColor Red
    } else {
        Write-Host "Creating delegated DNS Zone $FQDN.." -ForegroundColor Cyan

        $splat = @{
            "fqdn" = $FQDN
            "delegate_to" = $Hosts
        }
        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        try {
            $Result = Query-NIOS -Method POST -Server $Server -Uri "zone_delegated?_return_as_object=1" -Creds $Creds -Data $splat
            $Successful = $true
            if ($Debug) {$Result}
        } catch {
            Write-Host "Failed to create NIOS DNS Zone Delegation." -ForegroundColor Red
            $Successful = $false
        } finally {
            if ($Successful) {
                Write-Host "NIOS DNS Zone Delegation created successfully for $FQDN." -ForegroundColor Green
            }
        }
    }
}

function Migrate-NIOSSubzoneToBloxOne {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Subzone,
      [Parameter(Mandatory=$true)]
      [String]$View,
      [switch]$Confirm = $true,
      [switch]$IncludeDHCP = $false,
      [switch]$Test = $false,
      [switch]$CreateZones = $false,
      [System.Object]$DNSHosts,
      [System.Object]$AuthNSGs,
      $Creds
    )

    $Export = @()

    if (!(Get-NIOSAuthorativeZone -Server $Server -Creds $Creds -FQDN $Subzone)) {
        Write-Host "Error. Authorative zone does not exist in NIOS." -ForegroundColor Red
    } else {
        Write-Host "Obtaining list of records from $Subzone..." -ForegroundColor Cyan
        $SubzoneData = Query-NIOS -Method GET -Server $Server -Uri "allrecords?zone=$Subzone&_return_as_object=1&_return_fields%2B=creator" -Creds $Creds | Select -ExpandProperty results -ErrorAction SilentlyContinue

        if (!$IncludeDHCP) {
            $SubzoneData = $SubzoneData | where {$_.Creator -eq "STATIC"}
        }

        $UnsupportedRecords = $SubzoneData | where {$_.type -eq "UNSUPPORTED"}
        if ($UnsupportedRecords) {
            Write-Host "Unsupported records found. These may need to be re-created in BloxOne." -ForegroundColor Red
            $UnsupportedRecords | ft name,zone,type,comment,view -AutoSize
        }
        $SubzoneData = $SubzoneData | where {$_.type -ne "UNSUPPORTED"}

        foreach ($SubzoneItem in $SubzoneData) {
            if ($SubzoneItem.type -eq "record:host_ipv4addr") {
                $SubzoneItem.type = "record:host"
            }
            if ($Debug) {Write-Host "$($SubzoneItem.type)?name=$($SubzoneItem.name+"."+$SubzoneItem.zone)&_return_as_object=1"}

            $ReturnData = Query-NIOS -Method GET -Server $Server -Uri "$($SubzoneItem.type)?name=$($SubzoneItem.name+"."+$SubzoneItem.zone)&_return_as_object=1" -Creds $Creds | Select -ExpandProperty results -ErrorAction SilentlyContinue | Select -First 1 -ErrorAction SilentlyContinue

            switch ($SubzoneItem.type) {
                "record:host" {
                    $HostData = $ReturnData.ipv4addrs.ipv4addr
                }
                "record:a" {
                    $HostData = $ReturnData.ipv4addr
                }
                "record:cname" {
                    $HostData = $ReturnData.canonical+"."
                }
                "record:srv" {
                    $HostData = "$($ReturnData.target):$($ReturnData.port):$($ReturnData.priority):$($ReturnData.weight)"
                }
            }

            $splat = @{
                "Type" = $SubzoneItem.type
                "Name" = $SubzoneItem.name
                "Data" = $HostData
            }

            $Export += $splat
        }
        Write-Host "The following records are ready to copy." -ForegroundColor Green
        $Export | ConvertTo-Json | ConvertFrom-Json | ft -AutoSize
    }

    if ($Confirm -and -not $Test) {
        Write-Host "Review Information" -ForegroundColor Yellow
        Write-Warning "Are you sure you want to continue with copying this DNS Zone to BloxOne?" -WarningAction Inquire
    }

    if (!(Get-B1AuthoritativeZone -FQDN $Subzone -View $View)) {
        if ($CreateZones) {
            if ($DNSHosts -or $AuthNSGs) {
                New-B1AuthoritativeZone -FQDN $Subzone -View $View -DNSHosts $DNSHosts -AuthNSGs $AuthNSGs
                Wait-Event -Timeout 10
            } else {
                Write-Host "Error. You must specify -DNSHosts or -AuthNSGs when -CreateZones is $true" -ForegroundColor Red
                break
            }
        } else {
            Write-Host "Error. Authorative Zone $Subzone not found in BloxOne." -ForegroundColor Red
            break
        }
    }

    if (!($Test)) {
        Write-Host "Syncing $($Subzone) to BloxOneDDI in View $View.." -ForegroundColor Yellow
        foreach ($ExportedItem in $Export) {
            switch ($ExportedItem.type) {
                "record:host" {
                    $CreateResult = New-B1Record -Type "A" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $View -CreatePTR:$true -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $View." -ForegroundColor Green }
                }
                "record:a" {
                    $CreateResult = New-B1Record -Type "A" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $View -CreatePTR:$true -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $View." -ForegroundColor Green }
                }
                "record:cname" {
                    $CreateResult = New-B1Record -Type "CNAME" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $View -CreatePTR:$false -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $View." -ForegroundColor Green }
                }
                "record:srv" {
                    $ExportedData = $ExportedItem.data.split(":")
                    $CreateResult = New-B1Record -Type "SRV" -Name $ExportedItem.Name -Zone $Subzone -rdata $ExportedData[0] -Port $ExportedData[1] -Priority $ExportedData[2] -Weight $ExportedData[3] -view $View -CreatePTR:$false -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $View." -ForegroundColor Green }
                }
            }
        }
        Write-Host "Completed Syncing $($Subzone) to BloxOneDDI in View $View.." -ForegroundColor Green
    }
}









function Start-B1DiagnosticTask {
  param(
    [parameter(Mandatory=$true)]
               [String]$OnPremHost,
    [parameter(ParameterSetName="traceroute",
               Mandatory=$true)]
               [Switch]$Traceroute,
    [parameter(ParameterSetName="traceroute",
               Mandatory=$true)]
               [String]$Target,
    [parameter(ParameterSetName="traceroute",
               Mandatory=$false)]
               [String]$Port,
    [parameter(ParameterSetName="dnstest",
               Mandatory=$true)]
               [Switch]$DNSTest,
    [parameter(ParameterSetName="dnstest",
               Mandatory=$true)]
               [String]$FQDN,
    [parameter(ParameterSetName="ntptest",
               Mandatory=$true)]
               [Switch]$NTPTest,
    [parameter(ParameterSetName="dnsconf",
               Mandatory=$true)]
               [Switch]$DNSConfiguration,
    [parameter(ParameterSetName="dhcpconf",
               Mandatory=$true)]
               [Switch]$DHCPConfiguration,
    [parameter(Mandatory=$false)]
               [Switch]$WaitForOutput = $true
  )

  $OPH = Get-B1Host -Name $OnPremHost

  if ($OPH.ophid) {
    if ($Traceroute) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "traceroute"
          "args" = @{
            "target" = $Target
            "port" = $Port
          }
        }
      }
    }

    if ($DNSTest) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "dns_test"
          "args" = @{
            "domain_name" = $FQDN
          }
        }
      }
    }

    if ($NTPTest) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "ntp_test"
        }
      }
    }


    if ($DNSConfiguration) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "dns_conf"
        }
      }
    }

    if ($DHCPConfiguration) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "dhcp_conf"
        }
      }
    }

    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}
    $Result = Query-CSP -Method POST -Uri "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
    if ($Result) {
      if ($WaitForOutput) {
        while ((Get-B1DiagnosticTask -id $Result.id).status -eq "InProgress") {
          Write-Host "Waiting for task to complete on $OnPremHost.." -ForegroundColor Yellow
          Wait-Event -Timeout 5
        }
        if ($DNSConfiguration) {
          $Job = Get-B1DiagnosticTask -id $Result.id -Download
        } elseif ($DHCPConfiguration) {
          $Job = Get-B1DiagnosticTask -id $Result.id -Download | select -ExpandProperty Dhcp4 -ErrorAction SilentlyContinue
        } else {
          $Job = Get-B1DiagnosticTask -id $Result.id
        }
        if ($Job) {
          return $Job
        } else {
          Write-Host "Job failed on $OnPremHost." -ForegroundColor Red
        }
      } else {
        return $Result
      }
    }
  }
}

function Get-B1DiagnosticTask {
  param(
    [Parameter(Mandatory=$true)]
    [String]$id,
    [Switch]$download
  )

  if ($download) {
    $URI = "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task/$($id)/download"
    $Result = Query-CSP -Method GET -Uri $URI
  } else {
    $URI = "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task/$($id)"
    $Result = Query-CSP -Method GET -Uri $URI | Select -ExpandProperty result -ErrorAction SilentlyContinue
  }


  if ($Result) {
    return $Result
  }
}

function DeprecationNotice {
  param (
    $Date,
    $Command,
    $AlternateCommand
  )
  $ParsedDate = [datetime]::parseexact($Date, 'dd/MM/yy', $null)
  if ($ParsedDate -gt (Get-Date)) {
    Write-Host "Cmdlet Deprecation Notice! $Command will be deprecated on $Date. Please switch to using $AlternateCommand before this date." -ForegroundColor Yellow
  } else {
    Write-Host "Cmdlet was deprecated on $Date. $Command will likely no longer work. Please switch to using $AlternateCommand instead." -ForegroundColor Red
  }
}

function Get-ibPSVersion {
  (Get-Module -ListAvailable -Name ibPS).Version.ToString()
}