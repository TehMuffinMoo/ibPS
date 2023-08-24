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

foreach($FunctionToImport in @($B1PublicFunctions + $B1PrivateFunctions + $NIOSPublicFunctions + $NIOSPrivateFunctions)) {
  try {
    . $FunctionToImport.fullname
  } catch {
    Write-Error "Failed to import function $($FunctionToImport.fullname)"
  }
}

Export-ModuleMember -Function $(@($B1PublicFunctions + $NIOSPublicFunctions) | Select -ExpandProperty BaseName) -Alias *

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









function Get-B1Applications {
    $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/applications" | select -ExpandProperty results | select -ExpandProperty applications -ErrorAction SilentlyContinue
    
    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No BloxOneDDI Applications found." -ForegroundColor Red
    }
}

function Get-B1Service {
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [Switch]$Detailed,
        [Parameter(Mandatory=$false)]
        [String]$Limit = "10001",
        [Parameter(Mandatory=$false)]
        [Switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Detailed) {
      $ServicesUri = "detail_services"
    } else {
      $ServicesUri = "services"
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($ServicesUri)?_limit=$Limit&_filter=$Filter" | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($ServicesUri)?_limit=$Limit" | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    }
}

function Stop-B1Service {
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [Switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    $B1Service = Get-B1Service -Name $Name -Strict:$Strict
    if ($B1Service.count -gt 1) {
        Write-Host "More than one service returned. Check the name and use -Strict if required." -ForegroundColor Red
        $B1Service | ft name,service_type,@{label='host_id';e={$_.configs.host_id}} -AutoSize
    } elseif ($B1Service) {
        Write-Host "Stopping $($B1Service.name).." -ForegroundColor Cyan
        $B1Service.desired_state = "Stop"
        $splat = $B1Service | ConvertTo-Json -Depth 3 -Compress
        $ServiceId = $($B1Service.id).replace("infra/service/","") ## ID returned from API doesn't match endpoint? /infra/service not /infra/v1/services
        $Results = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/infra/v1/services/$ServiceId" -Data $splat
        if ($Results.result.desired_state -eq "Stop") {
          Write-Host "Service stopped successfully" -ForegroundColor Green
        } else {
          Write-Host "Failed to stop service." -ForegroundColor Red
        }
    }
}

function Start-B1Service {
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [Switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    $B1Service = Get-B1Service -Name $Name -Strict:$Strict
    if ($B1Service.count -gt 1) {
        Write-Host "More than one service returned. Check the name and use -Strict if required." -ForegroundColor Red
        $B1Service | ft name,service_type,@{label='host_id';e={$_.configs.host_id}} -AutoSize
    } elseif ($B1Service) {
        Write-Host "Starting $($B1Service.name).." -ForegroundColor Cyan
        $B1Service.desired_state = "start"
        $splat = $B1Service | ConvertTo-Json -Depth 3 -Compress
        $ServiceId = $($B1Service.id).replace("infra/service/","") ## ID returned from API doesn't match endpoint? /infra/service not /infra/v1/services
        $Results = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/infra/v1/services/$ServiceId" -Data $splat
        if ($Results.result.desired_state -eq "start") {
          Write-Host "Service started successfully" -ForegroundColor Green
        } else {
          Write-Host "Failed to start service." -ForegroundColor Red
        }
    }
}

function New-B1Service {
  [CmdletBinding(DefaultParameterSetName="default")]
  param (
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$true)]
    [String]$OnPremHost,
    [Parameter(Mandatory=$false)]
    [String]$Description = "",
    [Parameter(Mandatory=$false)]
    [Switch]$Strict,
    [Parameter(ParameterSetName="NTP")]
    [Switch]$NTP,
    [Parameter(ParameterSetName="DNS")]
    [Switch]$DNS,
    [Parameter(ParameterSetName="DHCP")]
    [Switch]$DHCP
  )
  $MatchType = Match-Type $Strict
  $B1Host = Get-B1Host -Name $OnPremHost -Detailed
  if ($B1Host) {
    if ($B1Host.count -gt 1) {
      Write-Host "Too many hosts returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $B1Host | ft -AutoSize
    } else {
      if ($NTP) {
        if (Get-B1Service -Name $Name -Strict) {
          Write-Host "Service $Name already exists" -ForegroundColor Yellow
        } else {
          $splat = @{
            "name" = $Name
            "description" = $Description
            "service_type" = "ntp"
            "desired_state" = "start"
            "pool_id" = $($B1Host.pool.pool_id)
            "tags" = @{}
            "interface_labels" = @()
            "destinations" = @()
            "source_interfaces" = @()
          } | ConvertTo-Json -Depth 3
          $NewServiceResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/services" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
          if ($NewServiceResult.id) {
            Write-Host "NTP service created successfully on $OnPremHost" -ForegroundColor Green
            Set-B1NTPServiceConfiguration -Name $Name -UseGlobalNTPConfig
          } else {
            Write-Host "Failed to create NTP service on $OnPremHost" -ForegroundColor Red
          }
        }
      }

      if ($DNS) {
        if (Get-B1Service -Name $Name -Strict) {
          Write-Host "Service $Name already exists" -ForegroundColor Red
        } else {
          $splat = @{
            "name" = $Name
            "description" = $Description
            "service_type" = "dns"
            "desired_state" = "start"
            "pool_id" = $($B1Host.pool.pool_id)
            "tags" = @{}
            "interface_labels" = @()
            "destinations" = @()
            "source_interfaces" = @()
          } | ConvertTo-Json -Depth 3
          $NewServiceResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/services" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
          if ($NewServiceResult.id) {
            Write-Host "DNS service created successfully on $OnPremHost" -ForegroundColor Green
          } else {
            Write-Host "Failed to create DNS service $OnPremHost" -ForegroundColor Green
          }
        }
      }

      if ($DHCP) {
        if (Get-B1Service -Name $Name -Strict) {
          Write-Host "Service $Name already exists" -ForegroundColor Red
        } else {
          $splat = @{
            "name" = $Name
            "description" = $Description
            "service_type" = "dhcp"
            "desired_state" = "start"
            "pool_id" = $($B1Host.pool.pool_id)
            "tags" = @{}
            "interface_labels" = @()
            "destinations" = @()
            "source_interfaces" = @()
          } | ConvertTo-Json -Depth 3
          $NewServiceResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/services" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
          if ($NewServiceResult.id) {
            Write-Host "DHCP service created successfully on $OnPremHost" -ForegroundColor Green
          } else {
            Write-Host "Failed to create DHCP service $OnPremHost" -ForegroundColor Green
          }
        }
      }
    }
  }
}

function Remove-B1Service {
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [Switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    $B1Service = Get-B1Service -Name $Name -Strict:$Strict
    if ($B1Service.count -gt 1) {
        Write-Host "More than one service returned. Check the name and use -Strict if required." -ForegroundColor Red
        $B1Service | ft name,service_type,@{label='host_id';e={$_.configs.host_id}} -AutoSize
    } elseif ($B1Service) {
        Write-Host "Removing $($B1Service.name).." -ForegroundColor Cyan
        $ServiceId = $($B1Service.id).replace("infra/service/","") ## ID returned from API doesn't match endpoint? /infra/service not /infra/v1/services
        $Results = Query-CSP -Method DELETE -Uri "https://csp.infoblox.com/api/infra/v1/services/$ServiceId"
        if (Get-B1Service -Name $Name -Strict:$Strict) {
          Write-Host "Failed to delete service" -ForegroundColor Red
        } else {
          Write-Host "Service deleted successfully." -ForegroundColor Green
        }
    }
}

function Get-B1NTPServiceConfiguration {
  param (
    [Parameter(Mandatory=$false)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [String]$ServiceId,
    [Parameter(Mandatory=$false)]
    [Switch]$Strict
  )

  $MatchType = Match-Type $Strict
  if (!($ServiceId) -and $Name) {
    $B1Service = Get-B1Service -Name "ntp_$($OPH.display_name)" -Strict:$Strict
    $ServiceId = $B1Service.id.replace("infra/service/","")
  }
  if ($B1Service) {
    if ($B1Service.count -gt 1) {
      Write-Host "Too many services returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $ServiceId | ft -AutoSize
    } else {
      $Result = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/ntp/v1/service/config/$ServiceId" | select -ExpandProperty ntp_service -ErrorAction SilentlyContinue
      if ($Result) {
        $Result
      } else {
        Write-Host "Error. Failed to retrieve NTP Configuration for $Name" -ForegroundColor Red
      }
    }
  }
}

function Set-B1NTPServiceConfiguration {
  param (
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [String]$Description = "",
    [Parameter(Mandatory=$false)]
    [Switch]$Strict,
    [Switch]$UseGlobalNTPConfig = $true
  )

  $MatchType = Match-Type $Strict
  $B1Service = Get-B1Service -Name $Name -Strict:$Strict
  if ($B1Service) {
    if ($B1Service.count -gt 1) {
      Write-Host "Too many services returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $B1Service | ft -AutoSize
    } else {
      if ($UseGlobalNTPConfig) {
        $GlobalNTPConfig = Get-B1GlobalNTPConfig
        $ServiceId = $($B1Service.id).replace("infra/service/","")
        $ConfigSplat = @{
          "ntp_config" = $GlobalNTPConfig.ntp_config
        } | ConvertTo-Json -Depth 5 -Compress
        $NewConfigResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/ntp/v1/service/config/$ServiceId" -Data $ConfigSplat | select -ExpandProperty ntp_service -ErrorAction SilentlyContinue
        if ($NewConfigResult.id) {
          Write-Host "Global NTP configuration applied successfully on $($B1Service.name)" -ForegroundColor Green
        } else {
          Write-Host "Failed to apply NTP Configuration on $($B1Service.name)" -ForegroundColor Red
        }
      }
    }
  }
}

function Get-B1BootstrapConfig {
    param(
        [Parameter(Mandatory=$true)]
        [String]$OnPremHost
    )
    $ophids = (Get-B1Host -Name $OnPremHost).ophid
    $Results = @()
    foreach ($ophid in $ophids) {
        $Results += Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/atlas-bootstrap-app/v1/host/$ophid"
    }
    return $Results
}

function Set-B1DNSHost {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$DNSConfigProfile,
        [String]$DNSName
    )
    $DNSHost = Get-B1DNSHost -Name $Name -Strict
    if ($DNSConfigProfile) {
        $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $DNSConfigProfile -Strict).id
    }
    if ($DNSHost) {
        
        $splat = @{
            "inheritance_sources" = @{
		        "kerberos_keys" = @{
			        "action" = "inherit"
		        }
	        }
            "type" = "bloxone_ddi"
            "associated_server" = @{
                "id" = $DNSConfigProfileId
            }
        }

        if ($DNSName) {
            $splat | Add-Member -Name "absolute_name" -Value $DNSName -MemberType NoteProperty
        }

        $splat = $splat | ConvertTo-Json
        if ($debug) {$splat}
        
        $Results = Query-CSP -Method PATCH -Uri $($DNSHost.id) -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue

        if ($Results.name -eq $Name) {
            Write-Host "DNS Host: $Name updated successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to update DNS Host: $Name." -ForegroundColor Red
        }
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

function Get-B1DNSConfigProfile {
    param(
        [String]$Name,
        [switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/server?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }else {
        Query-CSP -Method GET -Uri "dns/server" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DHCPConfigProfile {
    param(
        [String]$Name,
        [switch]$Strict = $false,
        [switch]$IncludeInheritance = $false
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Name) {
        if ($IncludeInheritance) {
            Query-CSP -Method GET -Uri "dhcp/server?_filter=$Filter&_inherit=full" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "dhcp/server?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }else {
        if ($IncludeInheritance) {
            Query-CSP -Method GET -Uri "dhcp/server?_inherit=full" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "dhcp/server" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }
}

function Set-B1DHCPConfigProfile {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Switch]$AddDDNSZones,
      [Switch]$RemoveDDNSZones,
      [System.Object]$DDNSZones,
      [Parameter(Mandatory=$true)]
      [String]$DNSView
    )
    if ($AddDDNSZones -or $RemoveDDNSZones) {
        if ($AddDDNSZones -and $RemoveDDNSZones) {
            Write-Host "Error. You can only specify Add or Remove for DDNS Zones." -ForegroundColor Red
            break
        } else {
            $ToUpdate = @()
            $ConfigProfile = Get-B1DHCPConfigProfile -Name $Name -IncludeInheritance -Strict
            if (!($ConfigProfile) ) {
                Write-Host "Error. Config Profile $Name not found" -ForegroundColor Red
            } else {
                if ($AddDDNSZones) {
                    $ConfigProfileJson = @()
                    foreach ($DDNSZone in $DDNSZones) {
                        $DDNSZone = $DDNSZone.TrimEnd(".")
                        if (("$DDNSZone.") -in $ConfigProfile.ddns_zones.fqdn) {
                            Write-Host "$DDNSZone already exists. Skipping.." -ForegroundColor Yellow
                        } else {
                            $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                            if ($AuthZone) {
                                $splat = @{
                                    "zone" = $AuthZone.id
                                }
                                $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                                $ConfigProfileJson += $splat
                            } else {
                                Write-Host "Error: Authoritative Zone not found." -ForegroundColor Red
                            }
                            $ToUpdate += $DDNSZone
                        }
                    }
                    foreach ($DDNSZone in $ConfigProfile.ddns_zones) {
                        $splat = @{
                            "zone" = $DDNSZone.zone
                        }
                        $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                        $ConfigProfileJson += $splat
                    }
                    if ($ConfigProfile.inheritance_sources.ddns_block.action -ne "override") {
                        Write-Host "Overriding Global DHCP Properties for DHCP Config Profile: $Name.." -ForegroundColor Green
                    }
                    $ConfigProfileSplat = @{
                        "ddns_zones" = $ConfigProfileJson
	                    "ddns_enabled" = $true
	                    "ddns_send_updates" = $true
                        "inheritance_sources" = @{
                            "ddns_block" = @{
                                "action" = "override"
                            }
                        }
                    } | ConvertTo-Json

                    $Result = Query-CSP -Method "PATCH" -Uri "$($ConfigProfile.id)" -Data $ConfigProfileSplat | Select -ExpandProperty result
            
                    if ($Result) {
                        if ($ToUpdate.count -gt 0) {
                            foreach ($DDNSToUpdate in $ToUpdate) {
                                if (("$DDNSToUpdate.") -in $Result.ddns_zones.fqdn) {
                                    Write-Host "$DDNSToUpdate added successfully to DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Green
                                } else {
                                    Write-Host "Failed to add $DDNSToUpdate to DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Red
                                }
                            }
                        } else {
                            Write-Host "Nothing to update." -ForegroundColor Yellow
                        }
                    } else {
                        Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                    }
                } elseif ($RemoveDDNSZones) {
                    $ConfigProfileJson = @()
                    foreach ($ConfigProfileDDNSZone in $ConfigProfile.ddns_zones) {
                        if (($ConfigProfileDDNSZone.fqdn.TrimEnd(".")) -notin $DDNSZones) {
                            $splat = @{
                                "zone" = $ConfigProfileDDNSZone.zone
                            }
                            $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                            $ConfigProfileJson += $splat
                        } else {
                            $ToUpdate += $ConfigProfileDDNSZone.fqdn
                        }
                    }
                    $ConfigProfileSplat = @{
                        "ddns_zones" = $ConfigProfileJson
                    } | ConvertTo-Json

                    $Result = Query-CSP -Method "PATCH" -Uri "$($ConfigProfile.id)" -Data $ConfigProfileSplat | Select -ExpandProperty result

                    if ($Result) {
                        if ($ToUpdate.count -gt 0) {
                            foreach ($DDNSToUpdate in $ToUpdate) {
                                if (("$DDNSToUpdate.") -notin $Result.ddns_zones.fqdn) {
                                    Write-Host "$DDNSToUpdate removed successfully from DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Green
                                } else {
                                    Write-Host "Failed to remove $DDNSToUpdate from DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Red
                                }
                            }
                        } else {
                            Write-Host "Nothing to update." -ForegroundColor Yellow
                        }
                    } else {
                        Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                    }

                }
            }
        }
    }
}

function New-B1DHCPConfigProfile {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [System.Object]$DHCPOptions = @(),
      [System.Object]$DDNSZones
    )
    $ConfigProfile = Get-B1DHCPConfigProfile -Name $Name -Strict -IncludeInheritance
    if ($ConfigProfile) {
        Write-Host "The DHCP Config Profile: $Name already exists." -ForegroundColor Yellow
    } else {
        Write-Host "Creating DHCP Config Profile: $Name..." -ForegroundColor Gray

        $splat = @{
            "name" = $Name
            "comment" = $Description
            "dhcp_options" = $DHCPOptions
            "dhcp_options_v6" = @()
            "inheritance_sources" = @{
                "dhcp_options" = @{
	                "action" = "inherit"
	                "value" = @()
                }
                "dhcp_options_v6" = @{
	                "action" = "inherit"
	                "value" = @()
                }
                "ddns_block" = @{
	                "action" = "override"
                }
                "ddns_hostname_block" = @{
	                "action" = "inherit"
                }
                "ddns_update_on_renew" = @{
	                "action" = "inherit"
                }
                "ddns_conflict_resolution_mode" = @{
	                "action" = "inherit"
                }
                "ddns_client_update" = @{
	                "action" = "inherit"
                }
                "hostname_rewrite_block" = @{
	                "action" = "inherit"
                }
            }
        }

        if ($DDNSZones) {
            $splat.inheritance_sources.ddns_block.action = "override"
	        $splat.dhcp_config = @{}
	        $splat.ddns_enabled = $true
	        $splat.ddns_send_updates = $true
            
            $ConfigProfileJson = @()
            foreach ($DDNSZone in $DDNSZones) {
                $DDNSZone = $DDNSZone.TrimEnd(".")
                $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                if ($AuthZone) {
                    $AuthZoneSplat = @{
                        "zone" = $AuthZone.id
                    }
                    $AuthZoneSplat = $AuthZoneSplat | ConvertTo-Json | ConvertFrom-Json
                    $ConfigProfileJson += $AuthZoneSplat
                } else {
                    Write-Host "Error: Authoritative Zone not found." -ForegroundColor Red
                }
                $ToUpdate += $DDNSZone
            }
	        $splat.ddns_zones = $ConfigProfileJson
        }
        
        $splat = $splat | ConvertTo-Json -Depth 4
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "dhcp/server" -Data $splat
        
        if (($Result | select -ExpandProperty result).name -eq $Name) {
            Write-Host "DHCP Config Profile: $Name created successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create DHCP Config Profile: $Name" -ForegroundColor Red
            break
        }
    }
}

function Apply-B1HostDNSConfigProfile {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $Name -Strict).id
    if (!$DNSConfigProfileId) {
        Write-Host "Failed to get DNS Config Profile." -ForegroundColor Red
    }
    
    foreach ($DNSHost in $Hosts) {
        $DNSHostId = (Get-B1DNSHost -Name $DNSHost).id

        $splat = @{
            "server" = $DNSConfigProfileId
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DNSHostId" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $DNSConfigProfileId) {
            Write-Host "DNS Config Profile `"$Name`" has been successfully applied to $DNSHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to apply DNS Config Profile `"$Name`" to $DNSHost" -ForegroundColor Red
        }
    }
}

function Remove-B1HostDNSConfigProfile {
    param(
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $Name -Strict).id
    if (!$DNSConfigProfileId) {
        Write-Host "Failed to get DNS Config Profile." -ForegroundColor Red
    }
    
    foreach ($DNSHost in $Hosts) {
        $DNSHostId = (Get-B1DNSHost -Name $DNSHost).id

        $splat = @{
            "server" = $null
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DNSHostId" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $null) {
            Write-Host "DNS Config Profiles have been successfully removed from $DNSHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to remove DNS Config Profiles from $DNSHost" -ForegroundColor Red
        }
    }
}

function Apply-B1HostDHCPConfigProfile {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DHCPConfigProfileId = (Get-B1DHCPConfigProfile -Name $Name -Strict).id
    if (!$DHCPConfigProfileId) {
        Write-Host "Failed to get DHCP Config Profile." -ForegroundColor Red
    }
    
    foreach ($DHCPHost in $Hosts) {
        $DHCPHostId = (Get-B1DHCPHost -Name $DHCPHost).id

        $splat = @{
            "server" = $DHCPConfigProfileId
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DHCPHostId" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $DHCPConfigProfileId) {
            Write-Host "DHCP Config Profile `"$Name`" has been successfully applied to $DHCPHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to apply DHCP Config Profile `"$Name`" to $DHCPHost" -ForegroundColor Red
        }
    }
}

function Remove-B1HostDHCPConfigProfile {
    param(
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DHCPConfigProfileId = (Get-B1DHCPConfigProfile -Name $Name).id
    if (!$DHCPConfigProfileId) {
        Write-Host "Failed to get DHCP Config Profile: $Name." -ForegroundColor Red
        break
    }
    
    foreach ($DHCPHost in $Hosts) {
        $DHCPHostId = (Get-B1DHCPHost -Name $DHCPHost).id

        $splat = @{
            "server" = $null
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DHCPHostId" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $null) {
            Write-Host "DHCP Config Profiles have been successfully removed from $DHCPHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to remove DHCP Config Profiles from $DHCPHost" -ForegroundColor Red
        }
    }
}

function Get-B1DHCPHost {
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($IP) {
        $Filters.Add("address$MatchType`"$IP`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/host?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/host" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DNSHost {
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($IP) {
        $Filters.Add("address$MatchType`"$IP`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/host?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/host" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1Tag {
    param(
        [String]$Name,
        [ValidateSet("active","revoked")]
        [String]$Status,
        [switch]$Strict
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("key$MatchType`"$Name`"") | Out-Null
    }
    if ($Status) {
        $Filters.Add("status$MatchType`"$Status`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/atlas-tagging/v2/tags?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/atlas-tagging/v2/tags" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DNSView {
    param(
        [String]$Name,
        [switch]$Strict
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "dns/view?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "dns/view" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find DNS View: $Name" -ForegroundColor Red
        break
    }
}

function Get-B1DNSACL {
    param(
        [String]$Name,
        [switch]$Strict
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/acl?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/acl" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1ForwardZone {
    param(
      [String]$FQDN,
      [bool]$Disabled,
      [switch]$Strict = $false,
      [String]$View
    )
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/forward_zone?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/forward_zone" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1AuthoritativeZone {
    param(
      [String]$FQDN,
      [bool]$Disabled,
      [Switch]$Strict = $false,
      [String]$View
    )
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/auth_zone?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/auth_zone" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DelegatedZone {
    param(
      [String]$FQDN,
      [bool]$Disabled,
      [Switch]$Strict = $false,
      [String]$View
    )
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/delegation?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/delegation" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DHCPOptionCode {
    param(
        [String]$Name,
        [int]$Code,
        [String]$Source,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Code) {
        $Filters.Add("code$MatchType$Code") | Out-Null
    }
    if ($Source) {
        $Filters.Add("source$MatchType`"$Source`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/option_code?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/option_code" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DHCPOptionGroup {
    param(
        [String]$Name,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/option_group?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/option_group" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DHCPOptionSpace {
    param(
        [String]$Name,
        [String]$Protocol,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Protocol) {
        $Filters.Add("protocol$MatchType`"$Protocol`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/option_space?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/option_space" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1AuthoritativeNSG {
    param(
        [String]$Name,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/auth_nsg?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/auth_nsg" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1ForwardNSG {
    param(
        [String]$Name,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/forward_nsg?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/forward_nsg" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Set-B1ForwardNSG {
    param(
        [String]$Name,
        [Switch]$AddHosts,
        [Switch]$RemoveHosts,
        [System.Object]$Hosts,
        [Switch]$Strict = $true
    )
	$MatchType = Match-Type $Strict
    $NSG = Get-B1ForwardNSG -Name $Name -Strict:$Strict
    if ($NSG) {
      $Update = $false
      if ($AddHosts -and $RemoveHosts) {
        Write-Host "Error. -AddHosts and -RemoveHosts are mutually exclusive." -ForegroundColor Red
      } else {
        if ($Hosts) {
          if ($AddHosts) {
            foreach ($B1Host in $Hosts) {
              $DNSHostId = (Get-B1DNSHost -Name $B1Host -Strict:$Strict).id
              if ($DNSHostId) {
                if ($DNSHostId -notin $NSG.hosts) {
                  $Update = $true
                  Write-Host "Adding $B1Host to $($NSG.name)" -ForegroundColor Cyan
                  $NSG.hosts += $DNSHostId
                } else {
                  Write-Host "$B1Host is already in forward NSG: $($NSG.name)" -ForegroundColor Yellow
                }
              } else {
                Write-Host "Error. DNS Host $B1Host not found." -ForegroundColor Red
              }
            }
            if ($Update) {
              $splat = $NSG | select * -ExcludeProperty id | ConvertTo-Json -Depth 5 -Compress
              $Results = Query-CSP -Method PATCH -Uri $NSG.id -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
              if ($Results.id -eq $NSG.id) {
                Write-Host "Successfully updated Forward NSG: $($NSG.name)" -ForegroundColor Green
              } else {
                Write-Host "Error. Failed to update Forward NSG: $($NSG.name)" -ForegroundColor Red
              }
            }
          } elseif ($RemoveHosts) {
            foreach ($B1Host in $Hosts) {
              $DNSHostId = (Get-B1DNSHost -Name $B1Host -Strict:$Strict).id
              if ($DNSHostId) {
                if ($DNSHostId -in $NSG.hosts) {
                  $Update = $true
                  Write-Host "Removing $B1Host from $($NSG.name)" -ForegroundColor Cyan
                  $NSG.hosts = $NSG.hosts | where {$_ -ne $DNSHostId}
                } else {
                  Write-Host "$B1Host is not in forward NSG: $($NSG.name)" -ForegroundColor Yellow
                }
              } else {
                Write-Host "Error. DNS Host $B1Host not found." -ForegroundColor Red
              }
            }
            if ($Update) {
              $splat = $NSG | select * -ExcludeProperty id | ConvertTo-Json -Depth 5 -Compress
              $Results = Query-CSP -Method PATCH -Uri $NSG.id -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
              if ($Results.id -eq $NSG.id) {
                Write-Host "Successfully updated Forward NSG: $($NSG.name)" -ForegroundColor Green
              } else {
                Write-Host "Error. Failed to update Forward NSG: $($NSG.name)" -ForegroundColor Red
              }
            }
          } else {
            Write-Host "Error. -AddHosts or -RemoveHosts was not specified." -ForegroundColor Red
          }
        }
      }
    }
}

function Get-B1FixedAddress {
    param(
        [String]$IP = $null,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($IP) {
        $Filters.Add("address==`"$IP`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/fixed_address?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/fixed_address" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1DHCPLease {
    [CmdletBinding(DefaultParameterSetName="st")]
    param (
        [Switch][parameter(ParameterSetName="htree")] $Range,
        [String][parameter(ParameterSetName="htree", Mandatory=$true)] $RangeStart,
        [String][parameter(ParameterSetName="htree")] $RangeEnd,
        [String][parameter(ParameterSetName="htree")] $Limit = 1000,
        [String][parameter(ParameterSetName="std")] $Address,
        [String][parameter(ParameterSetName="std")] $MACAddress,
        [String][parameter(ParameterSetName="std")] $Hostname,
        [String][parameter(ParameterSetName="std")] $HAGroup,
        [String][parameter(ParameterSetName="std")] $DHCPServer,
        [String]$Space = "Global",
        [switch]$Strict
    )
    $MatchType = Match-Type $Strict

    if ($Range) {
        $B1Range = Get-B1Range -StartAddress $RangeStart -EndAddress $RangeEnd
        if ($Range) {
            Query-CSP -Method GET -Uri "ipam/htree?_limit=$Limit&view=SPACE&state=used&node=$($B1Range.id)" | Select -ExpandProperty results -ErrorAction SilentlyContinue | Select -ExpandProperty dhcp_info -ErrorAction SilentlyContinue
        } else {
          Write-Host "Error. Range not found." -ForegroundColor Red
        }
    } else {
        $HAGroups = Get-B1HAGroup
        $DHCPHosts = Get-B1DHCPHost
        [System.Collections.ArrayList]$Filters = @()
        if ($Address) {
            $Filters.Add("address==`"$Address`"") | Out-Null
        }
        if ($MACAddress) {
            $Filters.Add("client_id==`"$MACAddress`"") | Out-Null
        }
        if ($Hostname) {
            $Filters.Add("hostname$MatchType`"$Hostname`"") | Out-Null
        }
        if ($HAGroup) {
            $HAGroupId = ($HAGroups | where {$_.name -eq $HAGroup}).id
            $Filters.Add("ha_group==`"$HAGroupId`"") | Out-Null
        }
        if ($DHCPServer) {
            $DHCPHostId = (Get-B1DHCPHost -Name $DHCPServer -Strict:$Strict).id
            $Filters.Add("host==`"$DHCPHostId`"") | Out-Null
        }
        if ($Space) {
            $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
            $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
        }


        if ($Filters) {
            $Filter = Combine-Filters $Filters
            $Query = "?_filter=$Filter"
            Query-CSP -Method GET -Uri "dhcp/lease?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select @{Name = 'ha_group_name'; Expression = {$ha_group = $_.ha_group; (@($HAGroups).where({ $_.id -eq $ha_group })).name }},@{Name = 'dhcp_server'; Expression = {$dhcpserver = $_.host; (@($DHCPHosts).where({ $_.id -eq $dhcpserver })).name }},*
        } else {
            Query-CSP -Method GET -Uri "dhcp/lease" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select @{Name = 'ha_group_name'; Expression = {$ha_group = $_.ha_group; (@($HAGroups).where({ $_.id -eq $ha_group })).name }},@{Name = 'dhcp_server'; Expression = {$dhcpserver = $_.host; (@($DHCPHosts).where({ $_.id -eq $dhcpserver })).name }},*
        }
    }
}

function Get-B1DNSUsage {
    param(
        [String]$Address,
        [String]$Space,
        [Switch]$ParseDetails
    )
    [System.Collections.ArrayList]$Filters = @()
    if ($Address) {
        $Filters.Add("address==`'$Address`'") | Out-Null
    }
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }
    if ($Filters) {
        $QueryFilter = Combine-Filters $Filters
        if ($ParseDetails) {
          $AuthZones = Get-B1AuthoritativeZone
          $Spaces = Get-B1Space
          $Views = Get-B1DNSView
          Query-CSP -Method GET -Uri "ipam/dns_usage?_filter=$QueryFilter" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select address,name,type,absolute_name,@{Name = 'zone'; Expression = {$authzone = $_.zone; (@($AuthZones).where({ $_.id -eq $authzone })).fqdn }},@{Name = 'space'; Expression = {$ipamspace = $_.space; (@($Spaces).where({ $_.id -eq $ipamspace })).name }},@{Name = 'view'; Expression = {$dnsview = $_.view; (@($Views).where({ $_.id -eq $dnsview })).name }},* -ErrorAction SilentlyContinue
        } else {
          Query-CSP -Method GET -Uri "ipam/dns_usage?_filter=$QueryFilter" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select address,name,type,absolute_name,zone,space,* -ErrorAction SilentlyContinue
        }
    } else {
        if ($ParseDetails) {
          $AuthZones = Get-B1AuthoritativeZone
          $Spaces = Get-B1Space
          $Views = Get-B1DNSView
          Query-CSP -Method GET -Uri "ipam/dns_usage" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select address,name,type,absolute_name,@{Name = 'zone'; Expression = {$authzone = $_.zone; (@($AuthZones).where({ $_.id -eq $authzone })).fqdn }},@{Name = 'space'; Expression = {$ipamspace = $_.space; (@($Spaces).where({ $_.id -eq $ipamspace })).name }},@{Name = 'view'; Expression = {$dnsview = $_.view; (@($Views).where({ $_.id -eq $dnsview })).name }},* -ErrorAction SilentlyContinue
        } else {
          Query-CSP -Method GET -Uri "ipam/dns_usage" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select address,name,type,absolute_name,zone,space,* -ErrorAction SilentlyContinue
        }
    }
}

function Get-B1Record {
    param(
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [String]$Name,
      [String]$Zone,
      [String]$rdata,
      [String]$FQDN,
      [String]$Source,
      [String]$View,
      [switch]$Strict = $false,
      [switch]$IncludeInheritance = $false
    )

    $SupportedRecords = "A","CNAME","PTR","NS","TXT","SOA","SRV"
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Type) {
        if ($Type -in $SupportedRecords) {
            $Filters.Add("type==`"$Type`"") | Out-Null
        } else {
            Write-Host "Invalid type specified. The following record types are supported: $SupportedRecords" -ForegroundColor Red
            break
        }
    }
    if ($Name) {
        $Filters.Add("name_in_zone$MatchType`"$Name`"") | Out-Null
    }
    if ($rdata) {
        $Filters.Add("dns_rdata$MatchType`"$rdata`"") | Out-Null
    }
    if ($FQDN) {
        if ($Strict) {
            if (!($FQDN.EndsWith("."))) {
                $FQDN = "$FQDN."
            }
        }
        $Filters.Add("absolute_name_spec$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Zone) {
        if ($Strict) {
            if (!($Zone.EndsWith("."))) {
                $Zone = "$Zone."
            }
        }
        $Filters.Add("absolute_zone_name$MatchType`"$Zone`"") | Out-Null
    }
    
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        if ($IncludeInheritance) {
            $Query = "?_filter=$Filter&_inherit=full"
        } else {
            $Query = "?_filter=$Filter"
        }
    } else {
        if ($IncludeInheritance) {
            $Query = "?_inherit=full"
        }
    }

    if ($Query) {
        $Result = Query-CSP -Method GET -Uri "dns/record$Query" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Result = Query-CSP -Method GET -Uri "dns/record" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($View) {
        $Result = $Result | where {$_.view_name -eq $View}
    }
    if ($Source) {
        $Result = $Result | where {$_.source -contains $Source}
    }
    $Result
}

function New-B1Record {
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Zone,
      [Parameter(Mandatory=$true)]
      [String]$rdata,
      [Parameter(Mandatory=$true)]
      [String]$view,
      [int]$TTL,
      [string]$Description,
      [bool]$CreatePTR = $true,
      [int]$Priority,
      [int]$Weight,
      [int]$Port,
      [switch]$SkipExistsErrors = $false,
      [switch]$IgnoreExists = $false
    )
    
    $SupportedRecords = "A","CNAME","PTR","TXT","SRV"
    ## To be added: "NS","SOA"
    if (!($Type -in $SupportedRecords)) {
        Write-Host "Invalid type specified. The following record types are supported: $SupportedRecords" -ForegroundColor Red
        break
    }

    if ($view) {
        $viewId = (Get-B1DNSView -Name $view -Strict).id
    }

    $TTLAction = "inherit"
    $FQDN = $Name+"."+$Zone
    $Record = Get-B1Record -Name $Name -View $view -Strict | where {$_.absolute_zone_name -match "^$($Zone)"}
    if ($Record -and -not $IgnoreExists) {
        if (!$SkipExistsErrors -and !$Debug) {Write-Host "DNS Record $($Name).$($Zone) already exists." -ForegroundColor Yellow}
        return $false
    } else {
        $AuthZoneId = (Get-B1AuthoritativeZone -FQDN $Zone -Strict -View $view).id
        if (!($AuthZoneId)) {
            Write-Host "Error. Authorative Zone not found." -ForegroundColor Red
        } else {
            switch ($Type) {
                "A" {
                    if (!(Get-B1Record -Name $Name -rdata $rdata -Strict | where {$_.absolute_zone_name -match "^$($Zone)"})) {
                        if ([bool]($rdata -as [ipaddress])) {
                            $rdataSplat = @{
	                            "address" = $rdata
	                        }
                            $Options = @{
		                            "create_ptr" = $CreatePTR
		                            "check_rmz" = $false
	                        }
                        } else {
                            Write-Host "Error. Invalid IP Address." -ForegroundColor Red
                            break
                        }
                    } else {
                        Write-Host "DNS Record $($Name).$($Zone) already exists." -ForegroundColor Yellow
                    }
                }
                "CNAME" {
                    if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}(\.)?$)") {
                        if (!($rdata.EndsWith("."))) {
                            $rdata = "$rdata."
                        }
                        $rdataSplat = @{
	                        "cname" = $rdata
	                    }
                    } else {
                        Write-Host "Error. CNAME must be an FQDN: $rdata" -ForegroundColor Red
                        break
                    }
                }
                "TXT" {
                    $rdataSplat = @{
                        "text" = $rdata
	                }
                }
                "PTR" {
                    $rdataSplat = @{
                        "dname" = $rdata
	                }
                }
                "SRV" {
                    if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") {
                        if ($Priority -and $Weight -and $Port) {
                            $rdataSplat = @{
		                        "priority" = $Priority
		                        "weight" = $Weight
		                        "port" = $Port
		                        "target" = $rdata
	                        }
                        } else {
                            Write-Host "Error. When creating SRV records, -Priority, -Weight & -Port parameters are all required." -ForegroundColor Red
                            break
                        }
                    } else {
                        Write-Host "Error. SRV target must be an FQDN: $rdata" -ForegroundColor Red
                        break
                    }
                }
                default {
                    Write-Host "Error. Invalid record type: $Type" -ForegroundColor Red
                    Write-Host "Please use a supported record type: $SupportedRecords" -ForegroundColor Gray
                    break
                }
            }
            if ($rdataSplat) {
                Write-Host "Creating $Type Record for $FQDN.." -ForegroundColor Gray
            
                if ($TTL) {
                    $TTLAction = "override"
                }
                $splat = @{
	                "name_in_zone" = $Name
	                "zone" = $AuthZoneId
	                "type" = $Type
	                "rdata" = $rdataSplat
	                "inheritance_sources" = @{
		                "ttl" = @{
			                "action" = $TTLAction
		                }
	                }
                }
                if ($Options) {
                    $splat | Add-Member -Name "options" -Value $Options -MemberType NoteProperty
                }               
                if ($TTL) {
                    $splat | Add-Member -Name "ttl" -Value $TTL -MemberType NoteProperty
                }
                if ($viewId) {
                    #$splat | Add-Member -Name "view" -Value $viewId -MemberType NoteProperty
                }
                if ($Description) {
                    $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
                }

                $splat = $splat | ConvertTo-Json
                if ($Debug) {$splat}
                $Result = Query-CSP -Method POST -Uri "dns/record" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
                if ($Debug) {$Result}
                if ($Result.dns_rdata -match $rdata) {
                    Write-Host "DNS $Type Record has been successfully created for $FQDN." -ForegroundColor Green
                    #return $Result
                } else {
                    Write-Host "Failed to create DNS $Type Record for $FQDN." -ForegroundColor Red
                }

            }
        }
    }

}

function Set-B1Record {
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Zone,
      [Parameter(Mandatory=$true)]
      [String]$rdata,
      [Parameter(Mandatory=$true)]
      [String]$view,
      [String]$CurrentRDATA,
      [int]$TTL,
      [string]$Description,
      [int]$Priority,
      [int]$Weight,
      [int]$Port
    )
    
    if ($view) {
        $viewId = (Get-B1DNSView -Name $view -Strict).id
    }

    $TTLAction = "inherit"
    $FQDN = $Name+"."+$Zone
    $Record = Get-B1Record -Name $Name -View $view -Zone "$Zone" -rdata $CurrentRDATA
    if (!($Record)) {
        Write-Host "Error. Record doesn't exist." -ForegroundColor Red
        break
    } else {
        switch ($Type) {
            "A" {
                if ([bool]($rdata -as [ipaddress])) {
                    $rdataSplat = @{
                        "address" = $rdata
                    }
                } else {
                    Write-Host "Error. Invalid IP Address." -ForegroundColor Red
                    break
                }
            }
            "CNAME" {
                if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}(\.)?$)") {
                  if (!($rdata.EndsWith("."))) {
                    $rdata = "$rdata."
                  }
                  $rdataSplat = @{
	                "cname" = $rdata
	              }
                } else {
                  Write-Host "Error. CNAME must be an FQDN: $rdata" -ForegroundColor Red
                  break
                }
            }
            "TXT" {
                $rdataSplat = @{
                    "text" = $rdata
                }
            }
            "PTR" {
                $rdataSplat = @{
                    "dname" = $rdata
                }
            }
            "SRV" {
                if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") {
                    if ($Priority -and $Weight -and $Port) {
                        $rdataSplat = @{
		                    "priority" = $Priority
		                    "weight" = $Weight
		                    "port" = $Port
		                    "target" = $rdata
	                    }
                    } else {
                        Write-Host "Error. When updating SRV records, -Priority, -Weight & -Port parameters are all required." -ForegroundColor Red
                        break
                    }
                } else {
                    Write-Host "Error. SRV target must be an FQDN: $rdata" -ForegroundColor Red
                    break
                }
            }
            default {
                Write-Host "Error. Invalid record type: $Type" -ForegroundColor Red
                Write-Host "Please use a supported record type: $SupportedRecords" -ForegroundColor Gray
                break
            }
        }

        if ($rdataSplat) {
            Write-Host "Updating $Type Record for $FQDN.." -ForegroundColor Gray
            
            if ($TTL) {
                $TTLAction = "override"
                $Record.inheritance_sources
            }
            $splat = @{
                "name_in_zone" = $Name
	            "rdata" = $rdataSplat
	            "inheritance_sources" = @{
		            "ttl" = @{
			            "action" = $TTLAction
		            }
	            }
            }
            if ($Options) {
                $splat | Add-Member -Name "options" -Value $Options -MemberType NoteProperty
            }               
            if ($TTL) {
                $splat | Add-Member -Name "ttl" -Value $TTL -MemberType NoteProperty
            }
            if ($Description) {
                $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
            }
            
            $splat = $splat | ConvertTo-Json
            if ($Debug) {$splat}
            $Result = Query-CSP -Method PATCH -Uri $($Record.id) -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
            if ($Debug) {$Result}
            if ($Result.dns_rdata -match $rdata) {
                Write-Host "DNS $Type Record has been successfully updated for $FQDN." -ForegroundColor Green
            } else {
                Write-Host "Failed to update DNS $Type Record for $FQDN." -ForegroundColor Red
            }

        }
    }
}

function Remove-B1Record {
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [String]$Name,
      [String]$Zone,
      [Parameter(Mandatory=$true)]
      [String]$View,
      [String]$rdata,
      [String]$FQDN,
      [Switch]$Strict = $false
    )

    if (!(($Name -and $Zone) -or $FQDN)) {
        Write-Host "Error. You must specify either -Name & -Zone or -FQDN" -ForegroundColor Red
        break
    }
    
    $Record = Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict:$Strict

    if (($Record | measure).Count -gt 1) {
        Write-Host "More than one record returned. These will not be removed." -ForegroundColor Red
        $Record | ft -AutoSize
    } elseif (($Record | measure).Count -eq 1) {
        Write-Host "Removing record: $FQDN$Name.$Zone.." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $Record.id
        if (Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict:$Strict) {
            Write-Host "Failed to remove DNS record: $FQDN$Name.$Zone" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed DNS record: $FQDN$Name.$Zone" -ForegroundColor Green
        }
    } else {
        Write-Host "DNS record does not exist: $FQDN$Name.$Zone" -ForegroundColor Gray
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

function New-B1AuthoritativeZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [System.Object]$DNSHosts,
      [System.Object]$AuthNSGs,
      [String]$DNSACL,
      [String]$Description
    )

    if (Get-B1AuthoritativeZone -FQDN $FQDN -View $View -Strict) {
        Write-Host "The $FQDN Zone already exists in DNS." -ForegroundColor Red
    } else {

        $ViewUUID = (Get-B1DNSView -Name $View -Strict).id

        $splat = @{
	        "fqdn" = $FQDN
	        "disabled" = $false
	        "view" = $ViewUUID
            "primary_type" = "cloud"
        }

        if ($DNSHosts -or $AuthNSGs) {
            if ($DNSHosts) {
                $B1Hosts = New-Object System.Collections.ArrayList
                foreach ($DNSHost in $DNSHosts) {
                    $B1Hosts.Add(@{"host"=(Get-B1DNSHost -Name $DNSHost).id;}) | Out-Null
                }
                $splat | Add-Member -Name "internal_secondaries" -Value $B1Hosts -MemberType NoteProperty
            }

            if ($AuthNSGs) {
                $B1AuthNSGs = @()
                foreach ($AuthNSG in $AuthNSGs) {
                    $B1AuthNSGs += (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                }
                $splat | Add-Member -Name "nsgs" -Value $B1AuthNSGs -MemberType NoteProperty
            }

            if ($DNSACL) {
                $DNSACLID = (Get-B1DNSACL -Name $DNSACL).id
                if ($DNSACLID) {
                    $UpdateACL = @(@{
			                    "element" = "acl"
			                    "acl" = $DNSACLID
	                })
                    $splat | Add-Member -Name "update_acl" -Value $UpdateACL -MemberType NoteProperty
                } else {
                    Write-Host "Error. DNS ACL not found." -ForegroundColor Red
                    break
                }
            }

            if ($Description) {
                $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
            }

        } else {
            Write-Host "Error. DNSHosts or AuthNSGs must be specified." -ForegroundColor Red
            break
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "dns/auth_zone" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue

        if ($Result) {
            Write-Host "Created Authorative DNS Zone $FQDN successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create Authorative DNS Zone $FQDN." -ForegroundColor Red
        }
    }
}

function New-B1ForwardZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [Parameter(Mandatory=$true)]
      $Forwarders,
      $DNSHosts,
      [String]$Description
    )

    if (Get-B1ForwardZone -FQDN $FQDN -View $View) {
        Write-Host "The $FQDN Zone already exists in DNS." -ForegroundColor Red
    } else {

        $ViewUUID = (Get-B1DNSView -Name $View -Strict).id

        if ($Forwarders.GetType().Name -eq "Object[]") {
            $ExternalHosts = New-Object System.Collections.ArrayList
            foreach ($Forwarder in $Forwarders) {
                $ExternalHosts.Add(@{"address"=$Forwarder;"fqdn"=$Forwarder;}) | Out-Null
            }
        } elseif ($Forwarders.GetType().Name -eq "ArrayList") {
            $ExternalHosts = $Forwarders
        } else {
            Write-Host "Error. Invalid data submitted in -ExternalHosts" -ForegroundColor Red
            break
        }

        $splat = @{
	        "fqdn" = $FQDN
	        "disabled" = $false
            "forward_only" = $true
	        "external_forwarders" = $ExternalHosts
	        "view" = $ViewUUID
        }

        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add((Get-B1DNSHost -Name $DNSHost).id) | Out-Null
            }
            $splat | Add-Member -Name "hosts" -Value $B1Hosts -MemberType NoteProperty
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "dns/forward_zone" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue

        if ($Result) {
            Write-Host "Created Forward DNS Zone $FQDN successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create Forward DNS Zone $FQDN." -ForegroundColor Red
        }
    }
}


function Set-B1ForwardZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [String]$Forwarders,
      [System.Object]$DNSHosts,
      [String]$DNSServerGroups
    )

    $ForwardZone = Get-B1ForwardZone -FQDN $FQDN

    if ($ForwardZone) {
        $ForwardZoneUri = $ForwardZone.id

        $ForwardZonePatch = @{}

        if ($Forwarders) {
            if ($Forwarders.GetType().Name -eq "Object[]") {
                $ExternalHosts = New-Object System.Collections.ArrayList
                foreach ($Forwarder in $Forwarders) {
                    $ExternalHosts.Add(@{"address"=$Forwarder;"fqdn"=$Forwarder;}) | Out-Null
                }
            } elseif ($Forwarders.GetType().Name -eq "ArrayList") {
                $ExternalHosts = $Forwarders
            }
        }
                
        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add((Get-B1DNSHost -Name $DNSHost).id) | Out-Null
            }
        }

        if ($DNSServerGroups) {
            $B1ForwardNSGs = @()
            foreach ($DNSServerGroup in $DNSServerGroups) {
                $B1ForwardNSGs += (Get-B1ForwardNSG -Name $DNSServerGroup).id
            }
        }

        if ($ExternalHosts) {$ForwardZonePatch.external_forwarders = $ExternalHosts}
        if ($B1Hosts) {$ForwardZonePatch.hosts = $B1Hosts}
        if ($DNSServerGroups) {
            $ForwardZonePatch.nsgs = $B1ForwardNSGs
            $ForwardZonePatch.external_forwarders = @()
            $ForwardZonePatch.hosts = @()
        }

        if ($ForwardZonePatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $ForwardZonePatch | ConvertTo-Json -Depth 10
            if ($Debug) {$splat}

            $Result = Query-CSP -Method PATCH -Uri "$ForwardZoneUri" -Data $splat
        
            if (($Result | select -ExpandProperty result).fqdn -like "$FQDN*") {
                Write-Host "Updated Forward DNS Zone successfully." -ForegroundColor Green
            } else {
                Write-Host "Failed to update Forward DNS Zone." -ForegroundColor Red
                break
            }
        }

    } else {
        Write-Host "The Forward Zone $FQDN does not exist." -ForegroundColor Red
    }
}

function Set-B1AuthoritativeZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [System.Object]$DNSHosts,
      [System.Object]$AddAuthNSGs,
      [System.Object]$RemoveAuthNSGs,
      [String]$Description
    )

    $AuthZone = Get-B1AuthoritativeZone -FQDN $FQDN -View $View -Strict
    
    if ($AuthZone) {
        $AuthZoneUri = $AuthZone.id
        $AuthZonePatch = @{}

        if ($DNSHosts -or $AddAuthNSGs -or $RemoveAuthNSGs) {
            if ($DNSHosts) {
                $B1Hosts = New-Object System.Collections.ArrayList
                foreach ($DNSHost in $DNSHosts) {
                    $B1Hosts.Add(@{"host"=(Get-B1DNSHost -Name $DNSHost).id;}) | Out-Null
                }
                $AuthZonePatch.internal_secondaries = $B1Hosts
            }

            if ($AddAuthNSGs) {
                $B1AuthNSGs = @()
                if ($AuthZone.nsgs -gt 0) {
                    $B1AuthNSGs += $AuthZone.nsgs
                }
                foreach ($AuthNSG in $AddAuthNSGs) {
                    $B1AuthNSGs += (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                }
                $AuthZonePatch.nsgs = @()
                $AuthZonePatch.nsgs += $B1AuthNSGs | select -Unique
            }

            if ($RemoveAuthNSGs) {
                $B1AuthNSGs = @()
                if ($AuthZone.nsgs -gt 0) {
                    $B1AuthNSGs += $AuthZone.nsgs
                }
                foreach ($AuthNSG in $RemoveAuthNSGs) {
                    $AuthNSGid = (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                    $B1AuthNSGs = $B1AuthNSGs | where {$_ -ne $AuthNSGid}
                }
                $AuthZonePatch.nsgs = @()
                $AuthZonePatch.nsgs += $B1AuthNSGs | select -Unique
            }

        }
        if ($Description) {
            $AuthZonePatch.comment = $Description
        }
        
        if ($AuthZonePatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $AuthZonePatch | ConvertTo-Json -Depth 10
            $Result = Query-CSP -Method PATCH -Uri "$AuthZoneUri" -Data $splat
            if (($Result | select -ExpandProperty result).fqdn -like "$FQDN*") {
              Write-Host "Updated Authoritative DNS Zone: $FQDN successfully." -ForegroundColor Green
            } else {
              Write-Host "Failed to update Authoritative DNS Zone: $FQDN." -ForegroundColor Red
              break
            }
        }
        if ($Debug) {$splat}
       
    } else {
        Write-Host "The Authoritative Zone $FQDN does not exist." -ForegroundColor Red
    }
}

function Remove-B1AuthoritativeZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View
    )
    $Zone = Get-B1AuthoritativeZone -FQDN $FQDN -Strict -View $View
    if ($Zone) {
        Query-CSP -Method "DELETE" -Uri "$($Zone.id)"
        if (Get-B1AuthoritativeZone -FQDN $FQDN -Strict -View $View) {
            Write-Host "Error. Failed to delete Authoritative Zone $FQDN." -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted Authoritative Zone $FQDN." -ForegroundColor Green
        }
    } else {
        Write-Host "Zone $FQDN does not exist." -ForegroundColor Yellow
    }
}

function Get-B1DHCPGlobalConfig {
    $Result = Query-CSP -Method "GET" -Uri "dhcp/global" | Select -ExpandProperty result -ErrorAction SilentlyContinue
    return $Result
}

function Set-B1DHCPGlobalConfig {
    param(
      [Switch]$AddDDNSZones,
      [Switch]$RemoveDDNSZones,
      [System.Object]$DDNSZones,
      [Parameter(Mandatory=$true)]
      [String]$DNSView
    )

    if ($AddDDNSZones -or $RemoveDDNSZones) {
        if ($AddDDNSZones -and $RemoveDDNSZones) {
            Write-Host "Error. You can only specify Add or Remove for DDNS Zones." -ForegroundColor Red
            break
        } else {
            $ToUpdate = @()
            if ($AddDDNSZones) {
                $GlobalConfig = Get-B1DHCPGlobalConfig
                $GlobalConfigJson = @()
                foreach ($DDNSZone in $DDNSZones) {
                    $DDNSZone = $DDNSZone.TrimEnd(".")
                    if (("$DDNSZone.") -in $GlobalConfig.ddns_zones.fqdn) {
                        Write-Host "$DDNSZone already exists. Skipping.." -ForegroundColor Yellow
                    } else {
                        $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                        if ($AuthZone) {
                            $splat = @{
                                "zone" = $AuthZone.id
                            }
                            $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                            $GlobalConfigJson += $splat
                        } else {
                            Write-Host "Error: Authoritative Zone not found." -ForegroundColor Red
                        }
                        $ToUpdate += $DDNSZone
                    }
                }
                foreach ($DDNSZone in $GlobalConfig.ddns_zones) {
                    $splat = @{
                        "zone" = $DDNSZone.zone
                    }
                    $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                    $GlobalConfigJson += $splat
                }
                $GlobalConfigSplat = @{
                    "ddns_zones" = $GlobalConfigJson
                } | ConvertTo-Json

                $Result = Query-CSP -Method "PATCH" -Uri "$($GlobalConfig.id)" -Data $GlobalConfigSplat | Select -ExpandProperty result
            
                if ($Result) {
                    if ($ToUpdate.count -gt 0) {
                        foreach ($DDNSToUpdate in $ToUpdate) {
                            if (("$DDNSToUpdate.") -in $Result.ddns_zones.fqdn) {
                                Write-Host "$DDNSToUpdate added successfully to DDNS Global Config." -ForegroundColor Green
                            } else {
                                Write-Host "Failed to add $DDNSToUpdate to DDNS Global Config." -ForegroundColor Red
                            }
                        }
                    } else {
                        Write-Host "Nothing to update." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                }
            } elseif ($RemoveDDNSZones) {
                $GlobalConfig = Get-B1DHCPGlobalConfig
                $GlobalConfigJson = @()
                foreach ($GlobalDDNSZone in $GlobalConfig.ddns_zones) {
                    if (($GlobalDDNSZone.fqdn.TrimEnd(".")) -notin $DDNSZones) {
                        $splat = @{
                            "zone" = $GlobalDDNSZone.zone
                        }
                        $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                        $GlobalConfigJson += $splat
                    } else {
                        $ToUpdate += $GlobalDDNSZone.fqdn
                    }
                }
                $GlobalConfigSplat = @{
                    "ddns_zones" = $GlobalConfigJson
                } | ConvertTo-Json

                $Result = Query-CSP -Method "PATCH" -Uri "$($GlobalConfig.id)" -Data $GlobalConfigSplat | Select -ExpandProperty result

                if ($Result) {
                    if ($ToUpdate.count -gt 0) {
                        foreach ($DDNSToUpdate in $ToUpdate) {
                            if (("$DDNSToUpdate.") -notin $Result.ddns_zones.fqdn) {
                                Write-Host "$DDNSToUpdate removed successfully from DDNS Global Config." -ForegroundColor Green
                            } else {
                                Write-Host "Failed to remove $DDNSToUpdate from DDNS Global Config." -ForegroundColor Red
                            }
                        }
                    } else {
                        Write-Host "Nothing to update." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                }

            }
        }
    }
}

function Get-B1SecurityPolicy {
    param(
      [String]$Name,
      [Switch]$Strict
    )

	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/atcfw/v1/security_policies?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/atcfw/v1/security_policies" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1HealthCheck {
    param(
      [Switch]$ApplicationHealth,
      [String]$OnPremHost
    )

    if ($ApplicationHealth) {
        $Hosts = Get-B1Host -Name $OnPremHost -Detailed
        $B1HealthStatus = @()
        foreach ($B1Host in $Hosts) {
            $B1AppStatus = @()
            foreach ($B1App in $B1Host.services) {
                $B1AppData = @{
                    "Host" = $B1Host.display_name
                    "Application" = ($CompositeStateSpaces | where {$_.Service_Type -eq $B1App.service_type}).Application
                    "Friendly Name" = ($CompositeStateSpaces | where {$_.Service_Type -eq $B1App.service_type}).FriendlyName
                    "Status" = $B1App.status.status
                }
                $B1AppStatus += $B1AppData
            }
            $B1HealthStatus += @{
                "Host" = $B1Host.display_name
                "DNS" = $($Status = ($B1AppStatus | where {$_.Application -eq "DNS"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "DFP" = $($Status = ($B1AppStatus | where {$_.Application -eq "DFP"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "DHCP" = $($Status = ($B1AppStatus | where {$_.Application -eq "DHCP"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "NTP" = $($Status = ($B1AppStatus | where {$_.Application -eq "NTP"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "DC" = $($Status = ($B1AppStatus | where {$_.Application -eq "DC"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
            }
        }
        ($B1HealthStatus | ConvertTo-Json | ConvertFrom-Json) | select Host,DNS,DHCP,NTP,DFP,DC
    }
}

function Get-B1GlobalNTPConfig {
  $Result = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/ntp/v1/account/config"
  if ($Result) {
    $Result | select -ExpandProperty account_config
  } else {
    Write-Host "Error. No Global NTP Configuration defined." -ForegroundColor Red
  }
}

function Get-B1TopMetrics {
    [CmdletBinding(DefaultParameterSetName="default")]
    param (
        [switch][parameter(ParameterSetName="topQueries")] $TopQueries,
        [string][parameter(ParameterSetName="topQueries", Mandatory=$true)][ValidateSet("NXDOMAIN","NXRRSET","DNS","DFP")] $QueryType,
        [switch][parameter(ParameterSetName="topClients")] $TopClients,
        [string][parameter(ParameterSetName="topClients")][ValidateSet("DNS","DFP")] $TopClientLogType,
        [int]$TopCount = "20",
        [datetime]$Start = (Get-Date).AddDays(-1),
        [datetime]$End = (Get-Date)
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartDate = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndDate = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    if ($TopQueries) {
        switch ($QueryType) {
            "NXDOMAIN" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "NstarDnsActivity.response"
			                "operator" = "equals"
			                "values" = @(
				                "NXDOMAIN"
			                )
		                }
                     )
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}} | Sort queryCount
                $DNSClients
                break
            }
            "NXRRSET" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "NstarDnsActivity.response"
			                "operator" = "equals"
			                "values" = @(
				                "NXRRSET"
			                )
		                }
                     )
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}} | Sort queryCount
                $DNSClients
                break
            }
            "DNS" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                #"filters" = @(
		                #@{
			                #"member" = "NstarDnsActivity.response"
			                #"operator" = "equals"
			                #"values" = @(
				                #"NXDOMAIN"
			                #)
		                #}
                     #)
	                "limit" = $TopCount
                }
                $splat | ConvertTo-Json -Depth 4
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}} | Sort queryCount
                $DNSClients
                break
            }
            "DFP" {
                $splat = @{
	                "measures" = @(
		                "PortunusDnsLogs.qnameCount"
	                )
	                "dimensions" = @(
		                "PortunusDnsLogs.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "PortunusDnsLogs.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "PortunusDnsLogs.type"
			                "operator" = "equals"
			                "values" = @(
				                "1"
			                )
		                }
	                )
	                "limit" = $TopCount
	                "ungrouped" = $false
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"
                $TopQueriesLog = $Result.result.data | Select @{name="query";Expression={$_.'PortunusDnsLogs.qname'}},`
                                             @{name="queryCount";Expression={$_.'PortunusDnsLogs.qnameCount'}}
                $TopQueriesLog
                break
            }
            default {
                Write-Host "Error. Permitted QueryType options are: NXDOMAIN, NXRRSET, DFP" -ForegroundColor Red
                break
            }
        }
    }
    if ($TopClients) {
        switch ($TopClientLogType) {
            "DNS" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.device_ip"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                "filters" = @()
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select @{name="device_ip";Expression={$_.'NstarDnsActivity.device_ip'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}},`
                                             @{name="licenseUsage";Expression={[math]::Round(($_.'NstarDnsActivity.total_count')/9000 + 0.5)}} | Sort queryCount
                $DNSClients
                break
            }
            "DFP" {
                $splat = @{
	                "measures" = @(
		                "PortunusAggUserDevices.deviceCount"
	                )
	                "dimensions" = @(
		                "PortunusAggUserDevices.device_name"
	                )
	                "timeDimensions" = @(
                        @{
			                "dimension" = "PortunusAggUserDevices.timestamp"
			                "dateRange" = @(
				                $StartDate,
				                $EndDate
			                )
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "PortunusAggUserDevices.type"
			                "operator" = "equals"
			                "values" = @(
				                "1"
			                )
		                }
	                )
	                "limit" = $TopCount
	                "ungrouped" = $false
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"

                $DFPClients = $Result.result.data | Select @{name="device_name";Expression={$_.'PortunusAggUserDevices.device_name'}},`
                                             @{name="count";Expression={$_.'PortunusAggUserDevices.deviceCount'}} | Sort count
                $DFPClients
            }
            default {
                Write-Host "Error. Permitted TopClientLogType options are: DNS, DFP" -ForegroundColor Red
                break
            }
        }
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

function Start-B1Export {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Switch]$DNSConfig,
      [Switch]$DNSData,
      [Switch]$NTPData,
      [Switch]$IPAMData,
      [Switch]$KeyData,
      [Switch]$ThreatDefense,
      [Switch]$Bootstrap,
      [Switch]$OnPremHosts,
      [Switch]$Redirects,
      [Switch]$Tags,
      [Switch]$BackupAll
    )

    $splat = @{
        "name" = $Name
        "description" = $Description
        "export_format" = "json"
        "error_handling_id" = "1"
    }

    $dataTypes = New-Object System.Collections.ArrayList

    if ($DNSConfig -or $BackupAll) {
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/authzones.v1.dnsconfig.bulk.infoblox.com") | Out-Null
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/forwardzones.v1.dnsconfig.bulk.infoblox.com") | Out-Null
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/servers.v1.dnsconfig.bulk.infoblox.com") | Out-Null
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/views.v1.dnsconfig.bulk.infoblox.com") | Out-Null
    }
    if ($DNSData -or $BackupAll) {
        $dataTypes.Add("dnsdata.bulk.infoblox.com/v1/records.v1.dnsdata.bulk.infoblox.com") | Out-Null
    }
    if ($NTPData -or $BackupAll) {
        $dataTypes.Add("ntp.bulk.infoblox.com/v1alpha1/ntpserviceconfigs.v1alpha1.ntp.bulk.infoblox.com") | Out-Null
    }
    if ($IPAMData -or $BackupAll) {
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/addressblocks.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/addresses.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/fixedaddresses.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/hagroups.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/hardwarefilters.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/ipspaces.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optioncodes.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optionfilters.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optiongroups.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optionspaces.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/ranges.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/servers.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/subnets.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
    }
    if ($KeyData -or $BackupAll) {
        $dataTypes.Add("keys.bulk.infoblox.com/v1/tsigkeys.v1.keys.bulk.infoblox.com") | Out-Null
    }
    if ($ThreatDefense -or $BackupAll) {
        $dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/applicationfilters.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/b1endpoints.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/categoryfilters.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/customdomains.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/endpointgroups.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/externalsubnets.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/internaldomains.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/securitypolicies.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
    }
    if ($Bootstrap -or $BackupAll) {
        $dataTypes.Add("bootstrap.bulk.infoblox.com/v1alpha1/hostconfigs.v1alpha1.bootstrap.bulk.infoblox.com") | Out-Null
    }
    if ($OnPremHosts -or $BackupAll) {
        $dataTypes.Add("onprem.bulk.infoblox.com/v1alpha1/hosts.v1alpha1.onprem.bulk.infoblox.com") | Out-Null
    }
    if ($Redirects -or $BackupAll) {
        $dataTypes.Add("redirect.bulk.infoblox.com/v1alpha1/customredirects.v1alpha1.redirect.bulk.infoblox.com") | Out-Null
    }
    if ($Tags -or $BackupAll) {
        $dataTypes.Add("tagging.bulk.infoblox.com/v1alpha1/tags.v1alpha1.tagging.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("tagging.bulk.infoblox.com/v1alpha1/values.v1alpha1.tagging.bulk.infoblox.com") | Out-Null
    }
    if ($dataTypes) {
        $splat | Add-Member -Name "data_types" -Value $dataTypes -MemberType NoteProperty
    }
    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}
    $Export = Query-CSP -Method "POST" -Uri "https://csp.infoblox.com/bulk/v1/export" -Data $splat

    if ($Export.success.message -eq "Export pending") {
        Write-Host "Data Export initalised successfully." -ForegroundColor Green
    } else {
        Write-Host "Data Export failed to initialise." -ForegroundColor Red
    }

}

function Get-B1Export {
    param(
        [Parameter(Mandatory=$true)]
        [string]$data_ref,
        [Parameter(Mandatory=$true)]
        [string]$filePath
    )
    $B1Export = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/bulk/v1/storage?data_ref=$data_ref&direction=download"
    if ($B1Export.result.url) {
        $JSON = Invoke-RestMethod -Uri $B1Export.result.url
        $JSON.data | ConvertTo-Json -Depth 15 | Out-File $filePath -Force -Encoding utf8
    }
}

function Get-B1BulkOperation {
    param(
        [string]$id
    )
    if ($id) {
        Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/bulk/v1/operation/$id"
    } else {
        Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/bulk/v1/operation"
    }
}

function Search-B1 {
    param(
        [Parameter(Mandatory=$true)]
        [string]$query
    )
    ## Get Stored API Key
    $B1ApiKey = Get-B1APIKey

    ## Set Headers
    $CSPHeaders = @{
        'Authorization' = "Token $B1ApiKey"
        'Content-Type' = 'application/json'
    }

    $Body = @{
      "query"=$query
    } | ConvertTo-Json | % { [System.Text.RegularExpressions.Regex]::Unescape($_)}
    $Results = Invoke-WebRequest -Uri "https://csp.infoblox.com/atlas-search-api/v1/search" -Method "POST" -Headers $CSPHeaders -Body $Body -UseBasicParsing
    $Results | ConvertFrom-Json
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

function Reboot-B1OnPremHost {
  param(
    [parameter(Mandatory=$true)]
               [String]$OnPremHost,
               [Switch]$NoWarning
  )

  $OPH = Get-B1Host -Name $OnPremHost
  if ($OPH.id) {
    $splat = @{
      "ophid" = $OPH.ophid
      "cmd" = @{
        "name" = "reboot"
      }
    }
    if (!($NoWarning)) {
        Write-Warning "WARNING! Are you sure you want to reboot this host? $OnPremHost" -WarningAction Inquire
    }
    Write-Host "Rebooting $OnPremHost.." -ForegroundColor Yellow
    $splat = $splat | ConvertTo-Json
    Query-CSP -Method POST -Uri "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/privilegedtask" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
  } else {
    Write-Host "On Prem Host $OnPremHost not found" -ForegroundColor Red
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

Export-ModuleMember -Function * -Alias *