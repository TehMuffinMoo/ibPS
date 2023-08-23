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

function Query-CSP {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI Cloud Services Portal

    .DESCRIPTION
        This is a core function used by all cmdlets when querying the CSP (Cloud Services Portal), required when interacting with the BloxOne APIs.

    .PARAMETER Method
        Specify the HTTP Method to use

    .PARAMETER Uri
        Specify the Uri, such as "ipam/record", you can also use the full URL and http parameters must be appended here.

    .PARAMETER Data
        Data to be submitted on POST/PUT/PATCH/DELETE requests

    .Example
        Query-CSP -Method GET -Uri "ipam/subnet?_filter=address==`"10.10.10.10`""

        Query-CSP -Method DELETE -Uri "dns/record/abc16def-a125-423a-3a42-dcv6f6c4dj8x"

    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [String]$Data
    )

    ## Get Stored API Key
    $B1ApiKey = Get-B1APIKey

    ## Set Headers
    $CSPHeaders = @{
        'Authorization' = "Token $B1ApiKey"
        'Content-Type' = 'application/json'
    }

    $ErrorOnEmpty = $true

    ## Allow full API or only endpoint to be specified.
    if ($Uri -notlike "https://csp.infoblox.com/*") {
        $Uri = "https://csp.infoblox.com/api/ddi/v1/"+$Uri
    }
    $Uri = $Uri -replace "\*","``*"
    if ($Debug) {$Uri}
    switch ($Method) {
        'GET' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders
        }
        'POST' {
            if (!($Data)) {
                Write-Host "Error. Data parameter not set."
                break
            }
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
        }
        'PUT' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
        }
        'PATCH' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
        }
        'DELETE' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
            $ErrorOnEmpty = $false
        }
        default {
            Write-Host "Error. Invalid Method: $Method. Accepted request types are GET, POST, PUT, PATCH & DELETE"
        }
    }

    if ($Result) {
        return $Result
    } elseif ($ErrorOnEmpty) {
        Write-Host "Error. No results from API."
    }
}

function Query-NIOS {
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [String]$ApiVersion = "2.12",
      $Creds,
      [String]$Data
    )

    if (!($Creds)) {
        $Creds = Get-NIOSCredentials
    }

    $ErrorOnEmpty = $true
    $WebSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession -Property @{Credentials=$Creds}

    ## Set Headers
    $NIOSHeaders = @{
        'Content-Type' = 'application/json'
    }

    ## Build URL
    $Uri = "https://$Server/wapi/v$ApiVersion/"+$Uri

    switch ($Method) {
        'GET' { 
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -WebSession $WebSession
        }
        'POST' {
            if (!($Data)) {
                Write-Host "Error. Data parameter not set."
                break
            }
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
        }
        'PUT' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
        }
        'PATCH' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
        }
        'DELETE' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
            $ErrorOnEmpty = $false
        }
        default {
            Write-Host "Error. Invalid Method: $Method. Accepted request types are GET, POST, PUT, PATCH & DELETE"
        }
    }

    if ($Result) {
        if ($Result.result -and -not $Result.results) {
            $Result | Add-Member -MemberType NoteProperty -Name "results" -Value $Result.result
        }
        return $Result
    } elseif ($ErrorOnEmpty) {
        Write-Host "Error. No results from API."
    }
}

function Get-B1APIKey {
    <#
    .SYNOPSIS
        Retrieves the stored BloxOneDDI API Key from the local machine, if available.

    .DESCRIPTION
        This function will retrieve the saved BloxOneDDI API Key from the local user/machine if it has previously been stored.

    .PARAMETER NoBreak
        If this is set, the function will not break if the API Key is not found

    .Example
        Get-B1APIKey

    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
      [switch]$NoBreak = $false
    )
    $ApiKey = $ENV:B1APIKey
    if (!$ApiKey) {
        Write-Host "Error. Missing API Key. Store your API Key first using the Store-APIKey Cmdlet and re-run this script." -ForegroundColor Red
        if (!($NoBreak)) {
            break
        }
    }
    return $ApiKey
}

function Store-B1APIKey {
    <#
    .SYNOPSIS
        Stores a new BloxOneDDI API Key

    .DESCRIPTION
        This function will store a new BloxOneDDI API Key for the current user on the local machine. If a previous API Key exists, it will be overwritten.

    .PARAMETER APIKey
        This is the BloxOneDDI API Key retrieves from the Cloud Services Portal

    .PARAMETER Persist
        Using the -Persist switch will save the API Key across powershell sessions. Without using this switch, the API Key will only be stored for the current powershell session.

    .Example
        Set-B1APIKey "mylongapikeyfromcsp" -Persist

    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$APIKey,
      [switch]$Persist
    )
    if ($Persist) {
        [System.Environment]::SetEnvironmentVariable('B1APIKey',$APIKey,[System.EnvironmentVariableTarget]::User)
        $ENV:B1APIKey = $APIKey
        Write-Host "BloxOne API key has been stored permenantly for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
    } else {
        $ENV:B1APIKey = $APIKey
        Write-Host "BloxOne API key has been stored for this session." -ForegroundColor Green
        Write-Host "You can make the API key persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
    }
}

function Get-NIOSCredentials {
    $Base64 = $ENV:NIOSCredentials
    if (!$Base64) {
        Write-Host "Error. Missing NIOS Credentials. Store your Credentials first using the Store-NIOSCredentials Cmdlet and re-run this script." -ForegroundColor Red
        break
    } else {
        $UPCombo = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64))
        $UPSplit = $UPCombo.Split(":")
        $Username = $UPSplit[0]
        $Password = $UPSplit[1] | ConvertTo-SecureString
        [pscredential]$Creds = New-Object System.Management.Automation.PSCredential ($Username, $Password)
        return $Creds
    }
}

function Store-NIOSCredentials {
    param(
      $Credentials,
      [switch]$Persist
    )
    if (!($Credentials)) {
        $Credentials = Get-Credential
    }
    $Username = $Credentials.GetNetworkCredential().UserName
    $Password = $Credentials.Password | ConvertFrom-SecureString
    $UPCombo = "$Username`:$Password"
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($UPCombo)
    $Base64 =[Convert]::ToBase64String($Bytes)

    if ($Persist) {
        [System.Environment]::SetEnvironmentVariable('NIOSCredentials',$Base64,[System.EnvironmentVariableTarget]::User)
        $ENV:NIOSCredentials = $Base64
        Write-Host "Credentials for $Username have been stored permenantly for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
    } else {
        $ENV:NIOSCredentials = $Base64
        Write-Host "Credentials for $Username have been stored for this session." -ForegroundColor Green
        Write-Host "You can make these credentials persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
    }
}

function Get-B1AuditLog {
    param(
      [Int]$Limit = 100,
      [Int]$Offset,
      [string]$Username,
      [string]$ResourceType,
      [string]$Method,
      [int]$ResponseCode,
      [string]$ClientIP,
      [string]$Action,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [switch]$Strict
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Username) {
        $Filters.Add("user_name$MatchType`"$Username`"") | Out-Null
    }
    if ($ResourceType) {
        $Filters.Add("resource_type$MatchType`"$ResourceType`"") | Out-Null
    }
    if ($Method) {
        $Filters.Add("http_method$MatchType`"$Method`"") | Out-Null
    }
    if ($ResponseCode) {
        $Filters.Add("http_code==$ResponseCode") | Out-Null
    }
    if ($ClientIP) {
        $Filters.Add("client_ip$MatchType`"$ClientIP`"") | Out-Null
    }
    if ($Action) {
        $Filters.Add("action$MatchType`"$Action`"") | Out-Null
    }
    if ($Start) {
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("created_at>=`"$StartTime`"") | Out-Null
    }
    if ($End) {
        $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("created_at<=`"$EndTime`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
        
    if ($Limit -and $Filters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs?_limit=$Limit&_offset=$Offset&_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Limit) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs?_limit=$Limit" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Filters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs?_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find any audit logs." -ForegroundColor Red
        break
    }
}

function Get-B1ServiceLog {
    param(
      [string]$OnPremHost,
      [ValidateSet("DNS","DHCP","DFP", "NGC", "NTP","Host","Kube","NetworkMonitor","CDC-OUT","CDC-IN")]
      [string]$Container,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

    $Filters = @()
    if ($OnPremHost) {
        $OPHID = (Get-B1Host -Name $OnPremHost).ophid
        $Filters += "ophid=$OPHID"
    }
    if ($Container) {
        switch ($Container) {
            "DNS" {
                $ContainerName = "ns:dns"
            }
            "DHCP" {
                $ContainerName = "ns-dhcp:dhcp"
            }
            "DFP" {
                $ContainerName = "dfp_coredns_1"
            }
            "NGC" {
                $ContainerName = "ns:niosgridconnector"
            }
            "NTP" {
                $ContainerName = "ntp_ntp"
            }
            "Host" {
                $ContainerName = "host/init.scope"
            }
            "Kube" {
                $ContainerName = "k3s.service"
            }
            "NetworkMonitor" {
                $ContainerName = "host/network-monitor.service"
            }
            "CDC-OUT" {
                $ContainerName = "cdc_siem_out"
            }
            "CDC-IN" {
                $ContainerName = "cdc_rpz_in"
            }
        }
        $Filters += "container_name=$ContainerName"
    }

    if ($Limit) {
        $Filters += "_limit=$Limit"
    }

    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "start=$StartTime"

    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "end=$EndTime"

    $QueryFilters = Combine-Filters2 -Filters $Filters

    $B1OnPremHosts = Get-B1Host -Detailed
    if ($QueryFilters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/atlas-logs/v1/logs$QueryFilters" -Method GET | Select -ExpandProperty logs | Select timestamp,@{Name = 'onpremhost'; Expression = {$ophid = $_.ophid; (@($B1OnPremHosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/atlas-logs/v1/logs" -Method GET | Select -ExpandProperty logs | Select timestamp,@{Name = 'onpremhost'; Expression = {$ophid = $_.ophid; (@($B1OnPremHosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find any audit logs." -ForegroundColor Red
        break
    }
}

function Get-B1SecurityLog {
    param(
      [Int]$Limit = 100,
      [Int]$Offset,
      [string]$Username,
      [string]$Type,
      [string]$App,
      [string]$Domain,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [switch]$Strict,
      [switch]$Raw
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Username) {
        $Filters.Add("userEmail$MatchType`"$Username`"") | Out-Null
    }
    if ($Type) {
        $Filters.Add("security_event_type$MatchType`"$Type`"") | Out-Null
    }
    if ($App) {
        $Filters.Add("app$MatchType`"$App`"") | Out-Null
    }
    if ($Domain) {
        $Filters.Add("domain==$Domain") | Out-Null
    }
    if ($Start) {
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("start_time==`"$StartTime`"") | Out-Null
    }
    if ($End) {
        $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("end_time==`"$EndTime`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
        

    if ($Limit -and $Filters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/security-events/v1/security_events?_limit=$Limit&_offset=$Offset&_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Limit) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/security-events/v1/security_events?_limit=$Limit" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Filters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/security-events/v1/security_events?_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/security-events/v1/security_events" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        if ($Raw) {
            return $Results
        } else {
            $Results.log | ConvertFrom-Json | ConvertFrom-Json
        }
    } else {
        Write-Host "Error. Unable to find any security logs." -ForegroundColor Red
        break
    }
}

function Get-B1DNSLog {
    param(
      [string]$Query,
      [string]$Source,
      [string]$Type,
      [string]$Response,
      [string]$DNSServers,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $OnPremHosts = Get-B1DNSHost

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    $splat = @{
	    "dimensions" = @(
		    "NstarDnsActivity.timestamp",
		    "NstarDnsActivity.qname",
		    "NstarDnsActivity.response",
		    "NstarDnsActivity.query_type",
		    "NstarDnsActivity.dns_view",
		    "NstarDnsActivity.device_ip",
		    "NstarDnsActivity.mac_address",
		    "NstarDnsActivity.dhcp_fingerprint",
		    "NstarDnsActivity.device_name",
		    "NstarDnsActivity.query_nanosec",
            "NstarDnsActivity.site_id"
	    )
	    "timeDimensions" = @(
		    @{
			    "dimension" = "NstarDnsActivity.timestamp"
			    "dateRange" = @(
				    $StartTime,
				    $EndTime
			    )
			    "granularity" = $null
		    }
	    )
	    "filters" = @(
	    )
	    "ungrouped" = $true
	    "offset" = $Offset
	    "limit" = $Limit
    }

    if ($Query) {
        $QuerySplat = @{
            "member" = "NstarDnsActivity.qname"
            "operator" = "contains"
            "values" = @(
                $Query
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Type) {
        $QuerySplat = @{
            "member" = "NstarDnsActivity.query_type"
            "operator" = "equals"
            "values" = @(
                $Type
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Response) {
        $ResponseSplat = @{
            "member" = "NstarDnsActivity.response"
            "operator" = "contains"
            "values" = @(
                $Response
            )
		}
        $splat.filters += $ResponseSplat
    }

    if ($Source) {
        $SourceSplat = @{
            "member" = "NstarDnsActivity.device_ip"
            "operator" = "contains"
            "values" = @(
                $Source
            )
		}
        $splat.filters += $SourceSplat
    }

    if ($DNSServers) {
        $DNSServerArr = @()
        foreach ($DNSServer in $DNSServers) {
          $SiteID = ($OnPremHosts | where {$_.absolute_name -like "*$DNSServer*"}).site_id
          $DNSServerArr += $SiteID
        }
        $DNSServerSplat = @{
            "member" = "NstartDnsActivity.site_id"
            "operator" = "equals"
            "values" = @(
                $DNSServerArr
            )
        }
        $splat.filters += $DNSServerSplat
    }

    $Data = $splat | ConvertTo-Json -Depth 4 -Compress

    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"
    if ($Result.result.data) {
        $Result.result.data | Select @{name="ip";Expression={$_.'NstarDnsActivity.device_ip'}},`
                                     @{name="name";Expression={$_.'NstarDnsActivity.device_name'}},`
                                     @{name="dhcp_fingerprint";Expression={$_.'NstarDnsActivity.dhcp_fingerprint'}},`
                                     @{name="dns_view";Expression={$_.'NstarDnsActivity.dns_view'}},`
                                     @{name="mac_address";Expression={$_.'NstarDnsActivity.mac_address'}},`
                                     @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                     @{name="query_nanosec";Expression={$_.'NstarDnsActivity.query_nanosec'}},`
                                     @{name="query_type";Expression={$_.'NstarDnsActivity.query_type'}},`
                                     @{name="response";Expression={$_.'NstarDnsActivity.response'}},`
                                     @{name="timestamp";Expression={$_.'NstarDnsActivity.timestamp'}},
                                     @{name="dns_server";Expression={$siteId = $_.'NstarDnsActivity.site_id'; (@($OnPremHosts).where({ $_.site_id -eq $siteId })).name}}
    } else {
        Write-Host "Error: No DNS logs returned." -ForegroundColor Red
    }

}

function Get-B1DFPLog {
    param(
      [string]$Query,
      [string]$Source,
      [string]$Type,
      [string]$Response,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [int]$Limit = 100,
      [int]$Offset = 0
    )
    
    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    $splat = @{
    	"measures" = @()
	    "dimensions" = @(
		    "PortunusDnsLogs.timestamp"
		    "PortunusDnsLogs.qname"
		    "PortunusDnsLogs.device_name"
		    "PortunusDnsLogs.qip"
		    "PortunusDnsLogs.network"
		    "PortunusDnsLogs.response"
		    "PortunusDnsLogs.dns_view"
		    "PortunusDnsLogs.query_type"
		    "PortunusDnsLogs.mac_address"
		    "PortunusDnsLogs.dhcp_fingerprint"
		    "PortunusDnsLogs.user"
		    "PortunusDnsLogs.os_version"
		    "PortunusDnsLogs.response_region"
		    "PortunusDnsLogs.response_country"
		    "PortunusDnsLogs.device_region"
		    "PortunusDnsLogs.device_country"
	    )
	    "timeDimensions" = @(
		    @{
			    "dimension" = "PortunusDnsLogs.timestamp"
			    "dateRange" = @(
				    $StartTime
				    $EndTime
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
	    "limit" = $Limit
	    "offset" = $Offset
	    "order" = @{
		    "PortunusDnsLogs.timestamp" = "desc"
	    }
	    "ungrouped" = $true
    }

    if ($Query) {
        $QuerySplat = @{
            "member" = "PortunusDnsLogs.qname"
            "operator" = "contains"
            "values" = @(
                $Query
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Type) {
        $QuerySplat = @{
            "member" = "PortunusDnsLogs.query_type"
            "operator" = "equals"
            "values" = @(
                $Type
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Response) {
        $ResponseSplat = @{
            "member" = "PortunusDnsLogs.response"
            "operator" = "contains"
            "values" = @(
                $Response
            )
		}
        $splat.filters += $ResponseSplat
    }

    if ($Source) {
        $SourceSplat = @{
            "member" = "PortunusDnsLogs.qip"
            "operator" = "contains"
            "values" = @(
                $Source
            )
		}
        $splat.filters += $SourceSplat
    }
    
    
    $Data = $splat | ConvertTo-Json -Depth 4 -Compress

    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"
    if ($Result.result.data) {
        $Result.result.data | Select @{name="timestamp";Expression={$_.'PortunusDnsLogs.timestamp'}},`
                                     @{name="query";Expression={$_.'PortunusDnsLogs.qname'}},`
                                     @{name="device_name";Expression={$_.'PortunusDnsLogs.device_name'}},`
                                     @{name="device_ip";Expression={$_.'PortunusDnsLogs.qip'}},`
                                     @{name="network";Expression={$_.'PortunusDnsLogs.network'}},`
                                     @{name="response";Expression={$_.'PortunusDnsLogs.response'}},`
                                     @{name="dns_view";Expression={$_.'PortunusDnsLogs.dns_view'}},`
                                     @{name="query_type";Expression={$_.'PortunusDnsLogs.query_type'}},`
                                     @{name="mac_address";Expression={$_.'PortunusDnsLogs.mac_address'}},`
                                     @{name="dhcp_fingerprint";Expression={$_.'PortunusDnsLogs.dhcp_fingerprint'}},`
                                     @{name="user";Expression={$_.'PortunusDnsLogs.user'}},`
                                     @{name="os_version";Expression={$_.'PortunusDnsLogs.os_version'}},`
                                     @{name="response_region";Expression={$_.'PortunusDnsLogs.response_region'}},`
                                     @{name="response_country";Expression={$_.'PortunusDnsLogs.response_country'}},`
                                     @{name="device_region";Expression={$_.'PortunusDnsLogs.device_region'}},`
                                     @{name="device_country";Expression={$_.'PortunusDnsLogs.device_country'}}
    } else {
        Write-Host "Error: No DNS logs returned." -ForegroundColor Red
    }

}

function Get-B1DHCPLog {
    param(
      [string]$Hostname,
      [string]$State,
      [string]$IP,
      [System.Object]$DHCPServer,
      [string]$Protocol,
      [string]$MacAddress,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    $DHCPHosts = Get-B1DHCPHost
    function Match-DHCPHost($id) {
        ($DHCPHosts | where {$_.id -eq $id}).name
    }

    $splat = @{
	    "dimensions" = @(
		    "NstarLeaseActivity.timestamp"
		    "NstarLeaseActivity.host_id"
		    "NstarLeaseActivity.protocol"
		    "NstarLeaseActivity.state"
		    "NstarLeaseActivity.lease_ip"
		    "NstarLeaseActivity.mac_address"
		    "NstarLeaseActivity.client_hostname"
		    "NstarLeaseActivity.lease_start"
		    "NstarLeaseActivity.lease_end"
		    "NstarLeaseActivity.dhcp_fingerprint"
	    )
	    "timeDimensions" = @(
		    @{
			    "dimension" = "NstarLeaseActivity.timestamp"
			    "dateRange" = @(
				    $StartTime
				    $EndTime
			    )
			    "granularity" = $null
		    }
	    )
	    "filters" = @()
	    "ungrouped" = $true
	    "offset" = $Offset
	    "limit" = $Limit
	    "order" = @{
		    "NstarLeaseActivity.lease_start" = "desc"
	    }
    }

    if ($Hostname) {
        $HostnameSplat = @{
            "member" = "NstarLeaseActivity.client_hostname"
            "operator" = "contains"
            "values" = @(
                $Hostname
            )
		}
        $splat.filters += $HostnameSplat
    }

    if ($MacAddress) {
        $MacAddressSplat = @{
            "member" = "NstarLeaseActivity.mac_address"
            "operator" = "equals"
            "values" = @(
                $MacAddress
            )
		}
        $splat.filters += $MacAddressSplat
    }

    if ($State) {
        $StateSplat = @{
            "member" = "NstarLeaseActivity.state"
            "operator" = "contains"
            "values" = @(
                $State
            )
		}
        $splat.filters += $StateSplat
    }

    if ($IP) {
        $IPSplat = @{
            "member" = "NstarLeaseActivity.lease_ip"
            "operator" = "contains"
            "values" = @(
                $IP
            )
		}
        $splat.filters += $IPSplat
    }

    if ($Protocol) {
        $ProtocolSplat = @{
            "member" = "NstarLeaseActivity.protocol"
            "operator" = "equals"
            "values" = @(
                $Protocol
            )
		}
        $splat.filters += $ProtocolSplat
    }

    if ($DHCPServer) {
        $DHCPHostIds = @()
        foreach ($DHCPServ in $DHCPServer) {
            $DHCPHostIds += (Get-B1DHCPHost -Name $DHCPServ).id
        }

        if ($DHCPHostIds) {
            $HostIdSplat = @{
                "member" = "NstarLeaseActivity.host_id"
                "operator" = "equals"
                "values" = @(
                    $DHCPHostIds
                )
		    }
            $splat.filters += $HostIdSplat
        } else {
            Write-Host "Error: Unable to find DHCP Host: $DHCPServer" -ForegroundColor Red
            break
        }
    }
    
    $Data = $splat | ConvertTo-Json -Depth 4 -Compress

    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    $Result = Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/cubejs/v1/query?query=$Query"
    if ($Result.result.data) {
        $Result.result.data | Select @{name="timestamp";Expression={$_.'NstarLeaseActivity.timestamp'}},`
                                     @{name="dhcp_server";Expression={Match-DHCPHost($_.'NstarLeaseActivity.host_id')}},`
                                     @{name="protocol";Expression={$_.'NstarLeaseActivity.protocol'}},`
                                     @{name="state";Expression={$_.'NstarLeaseActivity.state'}},`
                                     @{name="lease_ip";Expression={$_.'NstarLeaseActivity.lease_ip'}},`
                                     @{name="mac_address";Expression={$_.'NstarLeaseActivity.mac_address'}},`
                                     @{name="client_hostname";Expression={$_.'NstarLeaseActivity.client_hostname'}},`
                                     @{name="lease_start";Expression={$_.'NstarLeaseActivity.lease_start'}},`
                                     @{name="lease_end";Expression={$_.'NstarLeaseActivity.lease_end'}},`
                                     @{name="dhcp_fingerprint";Expression={$_.'NstarLeaseActivity.dhcp_fingerprint'}}
    } else {
        Write-Host "Error: No DHCP logs returned." -ForegroundColor Red
    }

}

function Get-B1Space {
    param(
      [String]$Name,
      [string]$id,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id$MatchType`"$id`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Uri "ipam/ip_space?_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "ipam/ip_space" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find IPAM space: $Name" -ForegroundColor Red
        break
    }
}

function Get-B1AddressBlock {
    param(
      [String]$Subnet,
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Name,
      [String]$Space,
      [Switch]$IncludeInheritance,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id

    [System.Collections.ArrayList]$Filters = @()
    if ($Subnet) {
        $Filters.Add("address==`"$Subnet`"") | Out-Null
    }
    if ($CIDR) {
        $Filters.Add("cidr==$CIDR") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Space) {
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
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
        Query-CSP -Uri "ipam/address_block$Query" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/address_block" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Get-B1AddressBlockNextAvailable {
    param(
      [Parameter(Mandatory=$true)]
      [String]$ParentAddressBlock,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Parameter(Mandatory=$true)]
      [Int]$SubnetCIDRSize,
      [Int]$SubnetCount = 1
    )

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id

    $ParentAddressBlockCIDRPair = $ParentAddressBlock.Split("/")
    if ($ParentAddressBlockCIDRPair[0] -and $ParentAddressBlockCIDRPair[1]) {
        $Parent = Get-B1AddressBlock -Subnet $ParentAddressBlockCIDRPair[0] -CIDR $ParentAddressBlockCIDRPair[1] -Space $Space
        if ($Parent) {
            Query-CSP -Method "GET" -Uri "$($Parent.id)/nextavailableaddressblock?cidr=$SubnetCIDRSize&count=$SubnetCount" | select -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Write-Host "Unable to find Parent Address Block: $ParentAddressBlock" -ForegroundColor Red
        }
    } else {
        Write-Host "Invalid Parent Address Block format: $ParentAddressBlock. Ensure you enter it as a full IP including the CIDR notation (i.e 10.192.0.0/12)" -ForegroundColor Red
    }
}

function Get-B1Range {
    param(
      [String]$StartAddress,
      [String]$EndAddress,
      [String]$Name,
      [String]$Space,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id

    [System.Collections.ArrayList]$Filters = @()
    if ($StartAddress) {
        $Filters.Add("start==`"$StartAddress`"") | Out-Null
    }
    if ($EndAddress) {
        $Filters.Add("end==`"$EndAddress`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Space) {
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
        Query-CSP -Uri "ipam/range?_filter=$Filter" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/range" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function Remove-B1Range {
    param(
      [Parameter(Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(Mandatory=$true)]
      [String]$EndAddress,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )
    
    $B1Range = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space

    if (($B1Range | measure).Count -gt 1) {
        Write-Host "More than one DHCP Ranges returned. These will not be removed." -ForegroundColor Red
        $B1Range | ft comment,start,end,space,name -AutoSize
    } elseif (($B1Range | measure).Count -eq 1) {
        Write-Host "Removing DHCP Range: $($B1Range.start) - $($B1Range.end).." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $B1Range.id
        if (Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress) {
            Write-Host "Error. Failed to remove DHCP Range: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed DHCP Range: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Green
        }
    } else {
        Write-Host "DHCP Range does not exist: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Gray
    }
}

function Get-B1Address {
    param(
      [String]$Address,
      [String]$State,
      [Switch]$Reserved = $false,
      [Switch]$Fixed = $false
    )

    [System.Collections.ArrayList]$Filters = @()
    if ($Address) {
        $Filters.Add("address==`"$Address`"") | Out-Null
    }
    if ($State) {
        $Filters.Add("state==`"$State`"") | Out-Null
    }
    if ($Filters) {
        $Filter = "_filter="+(Combine-Filters $Filters)
    }
    
    if ($State) {
        [System.Collections.ArrayList]$Filters2 = @()
        if ($Filter) {
            $Filters2.Add($Filter) | Out-Null
        }
        $Filters2.Add("address_state=$State") | Out-Null
        $Filter2 = Combine-Filters2 $Filters2
    }
    if ($Filter2) {
        $Results = Query-CSP -Uri "ipam/address$Filter2" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Filter) {
        $Filter2 = Combine-Filters2 $Filter
        $Results = Query-CSP -Uri "ipam/address$Filter2" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue    
    } else {
        $Results = Query-CSP -Uri "ipam/address" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results -and $Reserved -or $Fixed) {
        if ($Reserved) {
            $Results = $Results | where {$_.usage -contains "IPAM RESERVED"}
        } elseif ($Fixed) {
            $Results = $Results | where {$_.usage -contains "IPAM FIXED"}
        }
    }
    return $Results
}

function Get-B1Subnet {
    param(
      [String]$Subnet,
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Space,
      [String]$Name,
      [string]$id,
      [Switch]$IncludeInheritance,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        if ($SpaceUUID) {
            $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
        }
    }
    if ($Subnet) {
        $Filters.Add("address==`"$Subnet`"") | Out-Null
    }
    if ($CIDR) {
        $Filters.Add("cidr==$CIDR") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
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
        Query-CSP -Uri "ipam/subnet$Query" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/subnet" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}

function New-B1AddressReservation {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Address,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )
    if (!(Get-B1Address -Address $Address -Reserved)) {
        $splat = @{
	        "space" = (Get-B1Space -Name $Space -Strict).id
	        "address" = $Address
	        "comment" = $Description
	        "names" = @(@{
			        "name" = $Name
			        "type" = "user"
	        })
        }
        $splat = ConvertTo-Json($splat) -Depth 2
        $Result = Query-CSP -Method "POST" -Uri "ipam/address" -Data $splat
            
        if (($Result | select -ExpandProperty result).address -eq $Address) {
            Write-Host "Address Reservation created successfully." -ForegroundColor Green
        } else {
            Write-Host "Error. Failed to create Address Reservation $Subnet." -ForegroundColor Red
            break
        }
    } else {
        Write-Host "Address already exists." -ForegroundColor Red
    }
}

function Remove-B1AddressReservation {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Address,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )
    $AddressReservation = Get-B1Address -Address $Address -Reserved
    if ($AddressReservation) {
        $Result = Query-CSP -Method "DELETE" -Uri $AddressReservation.id
            
        if (!($AddressReservation = Get-B1Address -Address $Address -Reserved)) {
            Write-Host "Address Reservation deleted successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to delete Address Reservation." -ForegroundColor Red
            break
        }
    } else {
        Write-Host "Error. Address reservation does not exist." -ForegroundColor Red
    }
}

function New-B1AddressBlock {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [System.Object]$DHCPOptions,
      [String]$DDNSDomain,
      [System.Object]$Tags
      )

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id

    if (Get-B1AddressBlock -Subnet $Subnet -Space $Space -CIDR $CIDR) {
        Write-Host "The Address Block $Subnet/$CIDR already exists." -ForegroundColor Yellow
    } else {
        Write-Host "Creating Address Block $Subnet/$CIDR..." -ForegroundColor Gray

        $splat = @{
            "space" = $SpaceUUID
            "address" = $Subnet
            "cidr" = $CIDR
            "comment" = $Description
            "name" = $Name
            "dhcp_options" = $DHCPOptions
        }

        if ($DDNSDomain) {
            $splat."ddns_domain" = $DDNSDomain
            $DDNSupdateBlock = @{
                ddns_update_block = @{
			        "action" = "override"
			        "value" = @{}
		        }
            }
            $splat.inheritance_sources = $DDNSupdateBlock
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4
        if ($Debug) {$splat}
        #return $splat

        $Result = Query-CSP -Method POST -Uri "ipam/address_block" -Data $splat
        
        if (($Result | select -ExpandProperty result).address -eq $Subnet) {
            Write-Host "Address Block $Subnet/$CIDR created successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create Address Block $Subnet." -ForegroundColor Red
            break
        }
    }
}

function Remove-B1AddressBlock {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Switch]$Recurse,
      [Switch]$NoWarning
    )
        
    $AddressBlock = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space

    if ($Recurse -and -not $NoWarning) {
        Write-Warning "WARNING! -Recurse will remove all child objects that exist within the Address Block: $Subnet/$CIDR. Are you sure you want to do this?" -WarningAction Inquire
        $URI = "$($AddressBlock.id)?_options=recurse=true"
    } else {
        $URI = $AddressBlock.id
    }

    if (($AddressBlock | measure).Count -gt 1) {
        Write-Host "More than one address block returned. These will not be removed." -ForegroundColor Red
        $AddressBlock | ft -AutoSize
    } elseif (($AddressBlock | measure).Count -eq 1) {
        Write-Host "Removing Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr).." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $URI
        if (Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space) {
            Write-Host "Failed to remove Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Green
        }
    } else {
        Write-Host "Address Block does not exist: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Gray
    }
}

function Set-B1AddressBlock {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [String]$Name,
      [System.Object]$DHCPOptions,
      [String]$Description,
      [String]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [System.Object]$Tags
    )

    $AddressBlock = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance

    if ($AddressBlock) {
        $AddressBlockUri = $AddressBlock.id

        $AddressBlockPatch = @{}
        if ($Name) {$AddressBlockPatch.name = $Name}
        if ($Description) {$AddressBlockPatch.comment = $Description}
        if ($DHCPOptions) {$AddressBlockPatch.dhcp_options = $DHCPOptions}

        if ($DHCPLeaseSeconds) {
            $AddressBlock.inheritance_sources.dhcp_config.lease_time.action = "override"
            $AddressBlock.dhcp_config.lease_time = $DHCPLeaseSeconds

            $AddressBlockPatch.inheritance_sources = $AddressBlock.inheritance_sources
            $AddressBlockPatch.dhcp_config = $AddressBlock.dhcp_config
        }

        if ($DDNSDomain) {
            $AddressBlockPatch."ddns_domain" = $DDNSDomain
            $DDNSupdateBlock = @{
                ddns_update_block = @{
			        "action" = "override"
			        "value" = @{}
		        }
            }
            $AddressBlockPatch.inheritance_sources = $DDNSupdateBlock
        }

        if ($Tags) {
            $AddressBlockPatch.tags = $Tags
        }

        if ($AddressBlockPatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $AddressBlockPatch | ConvertTo-Json -Depth 10
            if ($Debug) {$splat}

            $Result = Query-CSP -Method PATCH -Uri "$AddressBlockUri" -Data $splat
        
            if (($Result | select -ExpandProperty result).address -eq $Subnet) {
                Write-Host "Updated Address Block $Subnet/$($AddressBlock.cidr) successfully." -ForegroundColor Green
            } else {
                Write-Host "Failed to update Address Block $Subnet." -ForegroundColor Red
                break
            }
        }

    } else {
        Write-Host "The Address Block $Subnet/$CIDR does not exists." -ForegroundColor Red
    }
}

function New-B1Subnet {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [System.Object]$HAGroup,
      [String]$Description,
      [System.Object]$DHCPOptions,
      [String]$DDNSDomain,
      [System.Object]$Tags
    )

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
    if ($HAGroup) {
        $DHCPHost = (Get-B1HAGroup -Name $HAGroup).id
    }

    if (Get-B1Subnet -Subnet $Subnet -Space $Space -CIDR $CIDR) {
        Write-Host "The subnet $Subnet/$CIDR already exists." -ForegroundColor Yellow
    } else {
        Write-Host "Creating subnet..." -ForegroundColor Gray

        $splat = @{
            "space" = $SpaceUUID
            "address" = $Subnet
            "cidr" = $CIDR
            "comment" = $Description
            "name" = $Name
            "dhcp_host" = $DHCPHost
            "dhcp_options" = $DHCPOptions
        }

        if ($DDNSDomain) {
            $splat."ddns_domain" = $DDNSDomain
            $DDNSupdateBlock = @{
                ddns_update_block = @{
			        "action" = "override"
			        "value" = @{}
		        }
            }
            $splat.inheritance_sources = $DDNSupdateBlock
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "ipam/subnet" -Data $splat
        
        if (($Result | select -ExpandProperty result).address -eq $Subnet) {
            Write-Host "Subnet $Subnet/$CIDR created successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create subnet $Subnet/$CIDR." -ForegroundColor Red
            break
        }
    }
}

function Set-B1Subnet {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [String]$Name,
      [String]$HAGroup,
      [System.Object]$DHCPOptions,
      [String]$Description,
      [String]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [System.Object]$Tags
    )

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
    $BloxSubnet = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance

    if ($BloxSubnet) {
        $BloxSubnetUri = $BloxSubnet.id

        $BloxSubnetPatch = @{}
        if ($Name) {$BloxSubnetPatch.name = $Name}
        if ($Description) {$BloxSubnetPatch.comment = $Description}
        if ($DHCPOptions) {$BloxSubnetPatch.dhcp_options = $DHCPOptions}
        if ($HAGroup) {$BloxSubnetPatch.dhcp_host = (Get-B1HAGroup -Name $HAGroup -Strict).id}

        if ($DHCPLeaseSeconds) {
            $BloxSubnet.inheritance_sources.dhcp_config.lease_time.action = "override"
            $BloxSubnet.dhcp_config.lease_time = $DHCPLeaseSeconds

            $BloxSubnetPatch.inheritance_sources = $BloxSubnet.inheritance_sources
            $BloxSubnetPatch.dhcp_config += $BloxSubnet.dhcp_config | select * -ExcludeProperty abandoned_reclaim_time,abandoned_reclaim_time_v6
        }

        if ($DDNSDomain) {
            $BloxSubnetPatch."ddns_domain" = $DDNSDomain
            $DDNSupdateBlock = @{
                ddns_update_block = @{
			        "action" = "override"
			        "value" = @{}
		        }
            }
            $BloxSubnetPatch.inheritance_sources = $DDNSupdateBlock
        }

        if ($Tags) {
            $BloxSubnetPatch.tags = $Tags
        }

        if ($BloxSubnetPatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $BloxSubnetPatch | ConvertTo-Json -Depth 10
            if ($Debug) {$splat}

            $Result = Query-CSP -Method PATCH -Uri "$BloxSubnetUri" -Data $splat
        
            if (($Result | select -ExpandProperty result).address -eq $Subnet) {
                Write-Host "Updated Subnet $Subnet/$CIDR successfully." -ForegroundColor Green
            } else {
                Write-Host "Failed to update Subnet $Subnet/$CIDR." -ForegroundColor Red
                break
            }
        }

    } else {
        Write-Host "The Subnet $Subnet/$CIDR does not exists." -ForegroundColor Red
    }
}

function Remove-B1Subnet {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )

    $SubnetInfo = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -Name $Name -Strict

    if (($SubnetInfo | measure).Count -gt 1) {
        Write-Host "More than one subnets returned. These will not be removed." -ForegroundColor Red
        $SubnetInfo | ft -AutoSize
    } elseif (($SubnetInfo | measure).Count -eq 1) {
        Write-Host "Removing Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr).." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $($SubnetInfo.id) -Data $null
        if (Get-B1Subnet -Subnet $($SubnetInfo.Address) -CIDR $CIDR -Space $Space) {
            Write-Host "Failed to remove Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr)" -ForegroundColor Green
        }
    } else {
        Write-Host "Subnet does not exist." -ForegroundColor Gray
    }
}

function New-B1Range {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(Mandatory=$true)]
      [String]$EndAddress,
      [Parameter(Mandatory=$true)]
      [string]$Space,
      [String]$Description,
      [String]$HAGroup,
      [System.Object]$Tags
    )

    if (Get-B1Range -StartAddress $StartAddress) {
        Write-Host "DHCP Range already exists." -ForegroundColor Red
    } else {
        Write-Host "Creating DHCP Range..." -ForegroundColor Gray
        $splat = @{
    	    "name" = $Name
	        "comment" = $Description
	        "start" = $StartAddress
	        "end" = $EndAddress
	        "space" = (Get-B1Space -Name $Space -Strict).id
	        "inheritance_sources" = @{
    		    "dhcp_options" = @{
			        "action" = "inherit"
			        "value" = @()
		        }
	        }
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }
        if ($HAGroup) {
            $splat | Add-Member -MemberType NoteProperty -Name "dhcp_host" -Value (Get-B1HAGroup -Name $HAGroup -Strict).id
        }

        $splat = $splat | ConvertTo-Json -Depth 10
        if ($Debug) {$splat}
        $Result = Query-CSP -Method POST -Uri "ipam/range" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.start -eq $StartAddress -and $Result.end -eq $EndAddress) {
            Write-Host "Created DHCP Range Successfully. Start: $StartAddress - End: $EndAddress" -ForegroundColor Green
        } else {
            Write-Host "Failed to create DHCP Range." -ForegroundColor Red
        }
    }
}

function Set-B1Range {
    param(
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$StartAddress,
      [String]$EndAddress,
      [Parameter(Mandatory=$true)]
      [string]$Space,
      [String]$Description,
      [String]$HAGroup,
      [System.Object]$Tags
    )
    $DHCPRange = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space
    if ($DHCPRange) {
        if ($Description) {
            $DHCPRange.comment = $Description
        }
        if ($Tags) {
            if ($DHCPRange.PSObject.Properties.name -match "tags") {
                $DHCPRange.tags = $Tags
            } else {
                $DHCPRange | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
            }
        }
        if ($Name) {
            $DHCPRange.name = $Name
        }
        if ($HAGroup) {
          $DHCPRange.dhcp_host = (Get-B1HAGroup -Name $HAGroup -Strict).id
        }
        $splat = $DHCPRange | select * -ExcludeProperty utilization,utilization_v6,id,inheritance_assigned_hosts,inheritance_parent,parent,protocol,space,inheritance_sources | ConvertTo-Json -Depth 10
        if ($Debug) {$splat}
        $Result = Query-CSP -Method PATCH -Uri $($DHCPRange.id) -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.start -eq $StartAddress) {
            Write-Host "Updated DHCP Range: $Name - $StartAddress - $EndAddress Successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to update DHCP Range: $Name - $StartAddress - $EndAddress" -ForegroundColor Red
        }
    } else {
        Write-Host "Error. DHCP Range does not exist: $Name - $StartAddress - $EndAddress" -ForegroundColor Red
    }
}

function Get-B1HAGroup {
    param(
      [String]$Name,
      [String]$Mode,
      [String]$Id,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$name`"") | Out-Null
    }
    if ($Mode) {
        if ($Mode -eq "active-active" -or $Mode -eq "active-passive") {
            $Filters.Add("mode==`"$Mode`"") | Out-Null
        } else {
            Write-Host "Error: -Mode must be `"active-active`" or `"active-passive`"" -ForegroundColor Red
            break
        }
    }
    if ($Id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "dhcp/ha_group?_filter=$Filter" | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "dhcp/ha_group" | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    } else {
        Write-Host "No DHCP HA Groups found." -ForegroundColor Gray
    }
}

function New-B1HAGroup {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Parameter(Mandatory=$true)]
      [ValidateSet("active-active","active-passive")]
      [String]$Mode,  ## active-active / active-passive
      [Parameter(Mandatory=$true)]
      [String]$PrimaryNode,
      [Parameter(Mandatory=$true)]
      [String]$SecondaryNode,
      [String]$Description
    )

    if (Get-B1HAGroup -Name $Name) {
        Write-Host "HA Group already exists by the name $Name." -ForegroundColor Red
    } else {
        $HostA = "dhcp/host/"+(Get-B1Host -Name $PrimaryNode -BreakOnError).legacy_id
        $HostARole = "active"
        $HostB = "dhcp/host/"+(Get-B1Host -Name $SecondaryNode -BreakOnError).legacy_id
        $HostBRole = "active"
        if ($Mode -eq "active-passive") {
            $HostBRole = "passive"
        }

        $HAHosts = New-Object System.Collections.ArrayList
        $HAHosts.Add(@{"host"="$HostA";"role"="$HostARole";}) | Out-Null
        $HAHosts.Add(@{"host"="$HostB";"role"="$HostBRole";}) | Out-Null

        $splat = @{
            "name" = $Name
            #"ip_space" = (Get-B1Space -Name $Space).id
            "mode" = $Mode
            "comment" = $Description
            "hosts" = $HAHosts
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "dhcp/ha_group" -Data $splat | select -ExpandProperty result
        if ($Result.name -eq $Name) {
            Write-Host "Created DHCP HA Group $Name Successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create DHCP HA Group $Name." -ForegroundColor Red
        }
    }
}

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

function Get-B1Host {
    [CmdletBinding(DefaultParameterSetName="default")]
    param(
      [String]$Name,
      [String]$IP,
      [String]$OPHID,
      [String]$Space,
      [String]$Limit = "10001",
      [ValidateSet("online","pending","degraded","error")]
      [String]$Status,
      [switch]$Detailed,
      [switch]$BreakOnError,
      [switch]$Reduced,
      [switch]$Strict = $false,
      [switch]$NoIPSpace
    )

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
      $Detailed = $true
    }
    if ($Detailed) {
      $APIEndpoint = "detail_hosts"
    } else {
      $APIEndpoint = "hosts"
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($APIEndpoint)?_limit=$($Limit)&_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($APIEndpoint)?_limit=$($Limit)" | Select -ExpandProperty results -ErrorAction SilentlyContinue
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

function Remove-B1Host {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name
    )
    $hostID = (Get-B1Host -Name $Name -Strict -Detailed).id
    if ($hostID) {
        Query-CSP -Method DELETE -Uri "https://csp.infoblox.com/api/infra/v1/hosts/$hostID"
        $hostID = (Get-B1Host -Name $Name -Strict -Detailed).id
        if ($hostID) {
            Write-Host "Error. Failed to delete BloxOneDDI Host $Name" -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted BloxOneDDI Host $Name" -ForegroundColor Green
        }
    } else {
        Write-Host "Error. Unable to find Host ID from name: $Name" -ForegroundColor Red
    }
}

function New-B1Host {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [String]$Description
    )
    if (Get-B1Host -Name $Name -Strict) {
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

    $Result = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/hosts" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
    $Result
    if ($Result.display_name -eq $Name) {
        Write-Host "On-Prem host $Name created successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to create On-Prem host $Name." -ForegroundColor Red
    }
}

function Set-B1Host {
    param(
      [String]$Name,
      [String]$IP,
      [String]$TimeZone,
      [String]$Space,
      [String]$Description,
      [switch]$NoIPSpace,
      [System.Object]$Tags
    )
    if ($IP) {
        if ($NoIPSpace) {
            $OnPremHost = Get-B1Host -IP $IP -NoIPSpace:$NoIPSpace
        } else {
            $OnPremHost = Get-B1Host -IP $IP -Space $Space
        }
        if (!($OnPremHost)) {
            Write-Host "On-Prem Host $IP does not exist." -ForegroundColor Gray
        } else {
          $hostID = $OnPremHost.id
        }
    } elseif ($Name) {
        if ($NoIPSpace) {
            $OnPremHost = Get-B1Host -Name $Name -NoIPSpace:$NoIPSpace
        } else {
            $OnPremHost = Get-B1Host -Name $Name -Space $Space
        }
        if (!($OnPremHost)) {
            Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
        } else {
          $hostID = $OnPremHost.id
        }
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

    $hostID = $hostID.replace("infra/host/","")

    $splat = $OnPremHost | select * -ExcludeProperty configs,created_at | ConvertTo-Json -Depth 10 -Compress
    if ($Debug) {$splat}
    $Results = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/infra/v1/hosts/$hostID" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
    if ($Results.display_name -eq $Name) {
        Write-Host "Updated BloxOneDDI Host Configuration $Name successfuly." -ForegroundColor Green
    } else {
        Write-Host "Failed to update BloxOneDDI Host Configuration on $Name." -ForegroundColor Red
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


function Combine-Filters {
    param(
      [parameter(mandatory=$true)]
      [System.Collections.ArrayList]$Filters
    )
    $combinedFilter = $null
    $FilterCount = $Filters.Count
    foreach ($filter in $Filters) {
        if ($FilterCount -le 1) {
            $combinedFilter += $Filter
        } else {
            $combinedFilter += $Filter+" and "
        }
        $FilterCount = $FilterCount - 1
    }
    $combinedFilter
}

function Combine-Filters2 {
    param(
      [parameter(mandatory=$true)]
      [System.Collections.ArrayList]$Filters
    )
    $combinedFilter = $null
    $FilterCount = $Filters.Count
    foreach ($filter in $Filters) {
        if ($FilterCount -le 1) {
            $combinedFilter += $Filter
        } else {
            $combinedFilter += $Filter+"&"
        }
        $FilterCount = $FilterCount - 1
    }
    $combinedFilter = "?$combinedFilter"
    return $combinedFilter
}

function Match-Type {
    param(
      [parameter(mandatory=$true)]
      [bool]$Strict
    )
	if ($Strict) {
        $MatchType = "=="
    } else {
        $MatchType = "~"
    }
    return $MatchType
}

function Get-ConfigFile {
    param(
      [parameter(mandatory=$true)]
      [string]$path
    )
    $ConfigFile = $path
    $ini = @{}

    Get-Content $ConfigFile | foreach {
      $_.Trim()
    } | where {
      $_ -notmatch '^(;|$)'
    } | foreach {
      if ($_ -match '^\[.*\]$') {
        $section = $_ -replace '\[|\]'
        $ini[$section] = @{}
      } else {
        $key, $value = $_ -split '\s*=\s*', 2
        $ini[$section][$key] = $value
      }
    }

    return $ini
}

function ConvertTo-IPv4MaskString {
  param(
    [parameter(Mandatory=$true)]
    [ValidateRange(0,32)]
    [Int] $MaskBits
  )
  $mask = ([Math]::Pow(2, $MaskBits) - 1) * [Math]::Pow(2, (32 - $MaskBits))
  $bytes = [BitConverter]::GetBytes([UInt32] $mask)
  (($bytes.Count - 1)..0 | ForEach-Object { [String] $bytes[$_] }) -join "."
}

function Test-IPv4MaskString {
  param(
    [parameter(Mandatory=$true)]
    [String] $MaskString
  )
  $validBytes = '0|128|192|224|240|248|252|254|255'
  $maskPattern = ('^((({0})\.0\.0\.0)|'      -f $validBytes) +
         ('(255\.({0})\.0\.0)|'      -f $validBytes) +
         ('(255\.255\.({0})\.0)|'    -f $validBytes) +
         ('(255\.255\.255\.({0})))$' -f $validBytes)
  $MaskString -match $maskPattern
}

function ConvertTo-IPv4MaskBits {
  param(
    [parameter(Mandatory=$true)]
    [ValidateScript({Test-IPv4MaskString $_})]
    [String] $MaskString
  )
  $mask = ([IPAddress] $MaskString).Address
  for ( $bitCount = 0; $mask -ne 0; $bitCount++ ) {
    $mask = $mask -band ($mask - 1)
  }
  $bitCount
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

function Deploy-B1Appliance {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [System.Object]$IP,
      [Parameter(Mandatory=$true)]
      [System.Object]$Netmask,
      [Parameter(Mandatory=$true)]
      [System.Object]$Gateway,
      [Parameter(Mandatory=$true)]
      [System.Object]$DNSServers,
      [Parameter(Mandatory=$true)]
      [System.Object]$NTPServers,
      [Parameter(Mandatory=$true)]
      [System.Object]$DNSSuffix,
      [Parameter(Mandatory=$true)]
      [System.Object]$JoinToken,
      [Parameter(Mandatory=$true)]
      [System.Object]$OVAPath,
      [Parameter(Mandatory=$true)]
      [System.Object]$vCenter,
      [Parameter(Mandatory=$false)]
      [System.Object]$Cluster,
      [Parameter(Mandatory=$true)]
      [System.Object]$Datastore,
      [Parameter(Mandatory=$true)]
      [System.Object]$PortGroup,
      [Parameter(Mandatory=$true)]
      [ValidateSet("vDS","Standard")]
      [String]$PortGroupType,
      [Parameter(Mandatory=$true)]
      $Creds,
      [Switch]$SkipCloudChecks,
      [Switch]$SkipPingChecks,
      [Switch]$SkipPowerOn
    )
	
	Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

    if (Connect-VIServer -Server $vCenter -Credential $Creds) {
        Write-Host "Connected to vCenter $vCenter successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to establish session with vCenter $vCenter." -ForegroundColor Red
        break
    }

    $VMCluster = Get-Cluster $Cluster -ErrorAction SilentlyContinue
	$VMHost = $VMCluster | Get-VMHost -State "Connected" | Select -First 1
    if (!($VMCluster)) {
        Write-Host "Error. Failed to get VM Cluster, please check details and try again." -ForegroundColor Red
        break
    }
    if (!(Get-Datastore $Datastore -ErrorAction SilentlyContinue)) {
        Write-Host "Error. Failed to get VM Datastore, please check details and try again." -ForegroundColor Red
        break
    }
    switch ($PortGroupType) {
        "vDS" {
			$NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $PortGroup
            if (!($NetworkMapping)) {
                Write-Host "Error. Failed to get vDS Port Group, please check details and try again." -ForegroundColor Red
                break
            } else {
				$NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $PortGroup
			}
        }
        "Standard" {
			$NetworkMapping = Get-VirtualSwitch -VMHost $VMHost | Get-VirtualPortGroup -Name $PortGroup
            if (!($NetworkMapping)) {
                Write-Host "Error. Failed to get Virtual Port Group, please check details and try again." -ForegroundColor Red
                break
            } else {

			}
        }
        "Default" {
            Write-Host "Invalid Port Group Type specified. Must be either `"vDS`" or `"Standard`"" -ForegroundColor Red
            break
        }
    }
    if (!(Test-Path $OVAPath)) {
        Write-Host "Error. OVA $OVAPath not found." -ForegroundColor Red
        break
    } else {
        $OVFConfig = Get-OvfConfiguration -Ovf $OVAPath
    }

    if (Get-VM -Name $Name -ErrorAction SilentlyContinue) {
        Write-Host "VM Already exists. Skipping.." -ForegroundColor Yellow
    } else {
        if ($OVFConfig) {
            Write-Host "Generating OVFConfig file for BloxOne Appliance: $Name .." -ForegroundColor Cyan

            $OVFConfig.Common.address.Value = $IP
            $OVFConfig.Common.gateway.Value = $Gateway
            $OVFConfig.Common.netmask.Value = $Netmask
            $OVFConfig.Common.nameserver.Value = $DNSServers
            $OVFConfig.Common.ntp_servers.Value = $NTPServers
            $OVFConfig.Common.jointoken.Value = $JoinToken
            $OVFConfig.Common.search.Value = $DNSSuffix
            $OVFConfig.Common.v4_mode.Value = "static"
            $OVFConfig.NetworkMapping.lan.Value = $NetworkMapping
        
        } else {
            Write-Host "Error. Unable to retrieve OVF Configuration from $OVAPath." -ForegroundColor Red
        }

        if (!($SkipPingChecks)) {
          if ((Test-NetConnection $IP -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
            Write-Host "Error. IP Address already in use." -ForegroundColor Red
            break
          }
        }

        Write-Host "Deploying BloxOne Appliance: $Name .." -ForegroundColor Cyan
        $Result = Import-VApp -OvfConfiguration $OVFConfig -Source $OVAPath -Name $Name -VMHost $VMHost -Datastore (Get-Datastore $Datastore) -ErrorAction SilentlyContinue
    
        if ($Result) {
            Write-Host "Successfully deployed BloxOne Appliance: $Name" -ForegroundColor Green
            if ($Debug) {$Result | ft -AutoSize}
            if (!($SkipPowerOn)) {
              Write-Host "Powering on $Name.." -ForegroundColor Cyan
              $VMStart = Start-VM -VM $Result
              $VMStartCount = 0
              while ((Get-VM -Name $Name).PowerState -ne "PoweredOn") {
                Write-Host "Waiting for VM to start. Elapsed Time: $VMStartCount`s" -ForegroundColor Gray
                Wait-Event -Timeout 10
                $VMStartCount = $VMStartCount + 10
                if ($VMStartCount -gt 120) {
                    Write-Host "Error. VM Failed to start." -ForegroundColor Red
                    break
                }
              }
            }

            if (!($SkipPingChecks)) {
              while (!(Test-NetConnection $IP -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
                $PingStartCount = $PingStartCount + 10
                Write-Host "Waiting for network to become reachable. Elapsed Time: $PingStartCount`s" -ForegroundColor Gray
                Wait-Event -Timeout 10
                if ($PingStartCount -gt 120) {
                    Write-Host "Error. Network Failed to become reachable on $IP." -ForegroundColor Red
                    break
                }
              }
            }

            if (!($SkipCloudChecks)) {
              while (!(Get-B1Host -IP $IP)) {
                $CSPStartCount = $CSPStartCount + 10
                Write-Host "Waiting for BloxOne Appliance to become registered within BloxOne CSP. Elapsed Time: $CSPStartCount`s" -ForegroundColor Gray
                Wait-Event -Timeout 10
                if ($CSPStartCount -gt 120) {
                    Write-Host "Error. VM failed to register with the BloxOne CSP. Please check VM Console for details." -ForegroundColor Red
                    break
                }
              }
            }

            Write-Host "BloxOne Appliance is now available, check the CSP portal for registration of the device" -ForegroundColor Gray

            if (!($SkipCloudChecks)) {
                Get-B1Host -IP $IP | ft display_name,ip_address,host_version -AutoSize
            }
            
        } else {
            Write-Host "Failed to deploy BloxOne Appliance." -ForegroundColor Red
            break
        }

        Disconnect-VIServer * -Confirm:$false -Force
        Write-Host "Disconnected from vCenters." -ForegroundColor Gray
    }
}

$CompositeStateSpaces = @(
    @{
        "Application" = "DFP"
        "FriendlyName" = "DNS Forwarding Proxy"
        "AppType" = "1"
        "Composite" = "9"
        "Service_Type" = "dfp"
    },
    @{
        "Application" = "DNS"
        "FriendlyName" = "DNS"
        "AppType" = "2"
        "Composite" = "12"
        "Service_Type" = "dns"
    },
    @{
        "Application" = "DHCP"
        "FriendlyName" = "DHCP"
        "AppType" = "3"
        "Composite" = "15"
        "Service_Type" = "dhcp"
    },
    @{
        "Application" = "DC"
        "FriendlyName" = "Data Connector"
        "AppType" = "7"
        "Composite" = "24"
        "Service_Type" = "cdc"
    },
    @{
        "Application" = "AnyCast"
        "FriendlyName" = "AnyCast"
        "AppType" = "9"
        "Composite" = "30"
        "Service_Type" = "anycast"
    },
    @{
        "Application" = "NGC"
        "FriendlyName" = "NIOS Grid Connector"
        "AppType" = "10"
        "Composite" = "34"
        "Service_Type" = "orpheus"
    },
    @{
        "Application" = "MSADC"
        "FriendlyName" = "MS AD Collector"
        "AppType" = "12"
        "Composite" = "40"
        "Service_Type" = "msad"
    },
    @{
        "Application" = "AAUTH"
        "FriendlyName" = "Access Authentication"
        "AppType" = "13"
        "Composite" = "43"
        "Service_Type" = "authn"
    },
    @{
        "Application" = "NTP"
        "FriendlyName" = "NTP"
        "AppType" = "20"
        "Composite" = "64"
        "Service_Type" = "ntp"
    }
) | ConvertTo-Json | ConvertFrom-Json

## Ignore SSL
#add-type @"
    #using System.Net;
    #using System.Security.Cryptography.X509Certificates;
    #public class TrustAllCertsPolicy : ICertificatePolicy {
        #public bool CheckValidationResult(
            #ServicePoint srvPoint, X509Certificate certificate,
            #WebRequest request, int certificateProblem) {
            #return true;
        #}
    #}
#"@
#[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

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