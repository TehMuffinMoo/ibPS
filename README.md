
<h1 align="center">
  <br>
  <!--<a href=""><img src="" alt="Markdownify" width="200"></a>-->
  <br>
  InfoBlox BloxOneDDI & BloxOne Threat Defense Powershell Module
  <br>
</h1>

<h4 align="center">A series of PowerShell Cmdlets used to interact with the InfoBlox BloxOne APIs.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#cmdlets">Cmdlets</a> •
  <a href="#resources">Resources</a> •
  <a href="#license">License</a>
</p>

## Key Features

* Automate end-to-end deployments of BloxOne
* Create, Edit & Remove objects from BloxOne Cloud (Records, Subnets, Ranges, Zones, HAGroups, etc.)
* Apply DNS/DHCP Configuration Policies to On-Prem hosts
* Deploy VMware BloxOne Appliances
* Deploy / Configure / Manage Hosts & Services
* Query DNS/DHCP/Host/Audit/Security logs
* Interact with the TIDE API
* Automate the world!

## Limitations

* Cmdlets have not yet been created for all BloxOne API endpoints. This is still being actively developed with the aim to have most, if not all api endpoints integrated eventually.
* A [PowerShell module already exists for InfoBlox NIOS](https://www.powershellgallery.com/packages/Posh-IBWAPI/3.2.2) and so limited Cmdlets will be built into this module. Any NIOS cmdlets built in are primarily for the purpose of migration to BloxOneDDI and may be deprecated.

## How To Use

To clone and run this PowerShell Module, you'll be best off with Git. This can be downloaded/extracted and run locally without an issue, but Git is preferred as updates to the Modules can be received with far less effort.

### Loading ibPS Module
You can either load the cmdlets directly, or Import/Install it as a PowerShell Module.

#### Installing with Install.ps1 (Preferred and persistent)
```bash
# Clone this repository on Windows
$ git clone https://github.com/TehMuffinMoo/ibPS/

# Go into the repository
$ cd ibPS/

# Install Module
. .\Install.ps1

# Non-Interactive Install Module
. .\Install.ps1 -Selection i
```

#### Explicitly Import Module
```bash
# You can import the module directly by using;
Import-Module -Name ".\Modules\ibPS\BloxOne-Main.psm1" -DisableNameChecking
```

#### Explicitly Import Functions
```bash
# You can load the functions directly by using;
. .\Modules\BloxOne-Main.ps1
```

### Authentication
#### BloxOne API Key
In order to authenticate against the BloxOne CSP (Cloud Services Portal), you must first set your API Key. You can do this for either your current powershell session or save the API Key as persistent for your current user.

##### Persistent
To store your API Key permenantly for your user, you can specify the <b>-Persist</b> option as shown below.
```powershell
Store-B1CSPAPIKey -ApiKey "<ApiKeyFromCSP>" -Persist
```

##### Single Session
Alternatively, you can simply store your API Key for the current powershell session only.
```powershell
Store-B1CSPAPIKey -ApiKey "<ApiKeyFromCSP>"
```

## BloxOne Cmdlets
All Cmdlets are listed below.

```
# Most Get-* cmdlets implement a -Strict parameter which applies strict name checking. Where possible, the default is to perform wildcard lookups on submitted parameters.

Store-B1CSPAPIKey -APIKey "longapikeystringgoeshere" -Persist
  Stores API Key for BloxOne within environment variables. Using -Persist will persist those credentials for that user on that machine.

Get-B1CSPAPIKey
  Retrieves the stored API Key for ibPS to communicate with the BloxOne Cloud

Get-B1CSPUrl
  Retrieves the currently set CSP URL for ibPS to communicate with the BloxOne Cloud

Set-B1CSPUrl -Region EU
  Updates the CSP URL to a new region
  
Get-ibPSVersion
  Gets the ibPS Module Version
  
Get-B1AuditLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -Method "POST" -Action "Create" -ClientIP "1.2.3.4" -ResponseCode "200"
  Retrieves a listing of all audit logs, optionally limiting the number of results by using an offset or the various filters.

Get-B1ServiceLog -OnPremHost "bloxoneddihost1.mydomain.corp" -Container "DNS" -Start (Get-Date).AddHours(-2)
  Retrieves service related logs. Container options include DNS, DHCP, NTP, DFP, Host, Kube & NetworkMonitor.

Get-B1SecurityLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -App "nginx" -Type "nginx.access" -Domain "prod.mydomain.corp"
  Retrieves CSP security logs, optionally limiting the number of results by using an offset or the various filters.

Get-B1DNSLog -Source "10.177.18.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 100 -Offset 0
  Retrieves all DNS logs from BloxOneDDI with various filter options.

Get-B1DNSEvent -Start (Get-Date).AddDays(-7) -AppName iCloud -FeedName Public_DOH -ThreatIndicator mask.icloud.com -Response NXDOMAIN
  Retrieves DNS queries which have triggered an event based on a security policy

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
  
Get-B1FixedAddress -IP 10.10.100.12
  Retrieves a list of DHCP Fixed Addresses
  
Get-B1AuthoritativeNSG -Name "Data Centre"
  Retrieves a listing of all Authorative Name Server Groups, optionally filtering by the -Name parameter.
  
Get-B1ForwardNSG -Name "Azure Wire IP"
  Retrieves a listing of all Forward Name Server Groups, optionally filtering by the -Name parameter.

Get-B1DHCPLease -Address "10.10.50.222" -MACAddress "01:02:ab:cd:ef:34:56" -Hostname "workstation1.prod.mydomain.corp" -Space "Global"
  Retrieves a listing of all DHCP Leases, optionally filtering by Address/MAC/Hostname/etc.

Get-B1DNSUsage -Address "10.10.50.222" -Space "Global"
  A useful command to return any records associated with a particular IP.

Get-B1DFP -Name "My DFP" -Strict
  Query a list of DNS Forwarding Proxies and its resolver configuration
  
Get-B1HealthCheck -ApplicationHealth
  Retrieves health for on-prem hosts
  
Get-B1Applications
  Retrieves a list of supported service types

Get-B1APIKey -Name "servicekeyname" -CreatedBy "user@domain.corp"
  Retrieves a list of API Keys configured within the BloxOne Cloud

Get-B1UserAPIKey
  Retrieves a list of interactive API Keys configured for your user within the BloxOne Cloud

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

Get-B1TDTideFeeds
  Query a list of TIDE Feeds (Custom RPZ)

Get-B1TDTideInfoRank -Domain "amazonaws.com" -Strict
  Queries the InfoRank list

Get-B1TDTideThreatClass -id "Bot"
  Queries a list of TIDE Threat Classes

Get-B1TDTideThreatClassDefaultTTL
  Queries the default TTL of TIDE Threat Classes

Get-B1TDTideThreatCounts
  Queries a list of threat counts, optionally choosing -Historical

Get-B1TDTideThreatEnrichment -Type Mandiant -Indicator "amazon.com"
  Queries the TIDE Threat Enrichment API

Get-B1TDTideThreatProperty -Name "CamelCase" -ThreatLevel 100
  Queries a list of threat properties from the TIDE API

Get-B1TDTideThreats -Hostname eicar.co
  Queries a list of threats from the TIDE API

Get-B1TDTideDataProfile -Name "My Profile"
  Query a list of TIDE Data Profiles with the option to filter by Name
  
Get-B1TDLookalikeDomains -Domain microsoft.com
  Query a list of lookalike domains (API Endpoint: /lookalike_domains)
  
Get-B1TDLookalikes -Domain google.com -Reason "phishing"
  Query a list of lookalike domains (API Endpoint: /lookalikes)

Get-B1TDLookalikeTargets
  Query a list of lookalike target domains (Global Lookalike Target List)

Get-B1TDLookalikeTargetCandidates
  Query a list of lookalike target candidates (Global Lookalike Candidates List)

Get-B1TDDossierSupportedFeedback
  Query a list of supported feedback types for Dossier

Get-B1TDDossierSupportedSources -Target ip
  Query a list of supported sources for Dossier

Get-B1TDDossierSupportedTargets -Source mandiant
  Query a list of supported indicator types for Dossier

Get-B1TDDossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Results
  Query a Dossier lookup job

Start-B1TDDossierLookup -Type host -Value eicar.co
  Starts a Dossier lookup job

New-B1TDTideDataProfile -Name "My Profile" -Description "My TIDE Data Profile" -RPZFeed "my-rpz-feed" -DefaultTTL $false
  Creates a new TIDE Data Profile

New-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Host "bloxoneddihost1.mydomain.corp" -NTP -DNS -DHCP
  Deploys a new BloxOneDDI Service

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
  
New-B1FixedAddress -IP "10.10.1.10" -Name "New fixed address" -Description "Description for new fixed address" -MatchType mac -MatchValue "ab:cd:ef:ab:cd:12" -Space Global -Tags @{"environment"="production"}
  Retrieves a list of DHCP Fixed Addresses

New-B1APIKey -Name "serviceapikey" -Type Service -UserName "svc-account-name"
  Creates a new API Key in the BloxOne Cloud and returns the key

Remove-B1Record -Type "A" -Name "myrecord" -Zone "prod.mydomain.corp"
  Removes a DNS record.
  
Remove-B1FixedAddress -IP 10.12.2.200 -Space Global
  Removes a fixed address

Remove-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default"
  Removes an authoritative dns zone
  
Remove-B1ForwardZone -FQDN "myforwardzone.mycompany.corp" -View "default"
  Removes a forward dns zone

Remove-B1AddressReservation -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
  Removes an IP Reservation from IPAM. This is not a DHCP Reservation, see fixed addresses for that.

Remove-B1AddressBlock -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
  Removes an Address Block from IPAM.

Remove-B1Subnet -Subnet 10.0.0.1 -CIDR 24 -Space "Global"
  Removes a Subnet from IPAM.

Remove-B1Host -Name "bloxoneddihost1.mydomain.corp"
  Removes a host from within BloxOne.

Revoke-B1DNSConfigProfile -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
  Used to remove DNS Configuration Profiles from BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.

Revoke-B1DHCPConfigProfile -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
  Used to remove DHCP Configuration Profiles from BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.
  
Remove-B1Range -Start "10.250.20.20" -End "10.250.20.100"
  Used to remove a DHCP Range
  
Remove-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Strict
  Used to remove a BloxOneDDI Service

Remove-B1TDSecurityPolicy -Name "My Policy"
  Used to remove BloxOne Threat Defense Security Policies

Remove-B1TDNetworkList
  Used to remove Network Lists from BloxOne Threat Defense

Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"
  Newly registered devices are given a random name which is updated when using the -IP and -Name parameters together. -IP is used to reference the object, -Name is used as the updated DNS Name. TimeZone and Space can also be configured using this cmdlet.

Set-B1AddressBlock -Subnet "10.10.100.0" -Name "MySupernet" -Space "Global" -Description "Comment for description" -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";})
  Used to update settings on an existing Address Block.

Set-B1Subnet -Subnet "10.10.10.0" -Name "MySubnet" -Space "Global" -Description "Comment for description" -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "router").id;"option_value"="10.10.10.1";})
  Used to update settings on an existing BloxOne Subnet.
  
Set-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 -Description -Tags @{"siteCOde"="12345"}
  Used to update settings associated with a DHCP Range

Set-B1Record -Type "A" -Name "test" -Zone "app1.prod.mydomain.corp" -rdata "10.10.100.225" -TTL "60" -Description "My App"
  Used to update the configuration of an existing DNS record.
  
Set-B1FixedAddress -IP "10.10.1.10" -Name "Updated name" -Description "Updated comment" -MatchType mac -MatchValue "12:23:45:ab:cd:12" -Space Global -Tags @{"environment"="test"}
  Used to update an existing fixed address.

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

Set-B1TideDataProfile -Name "My Profile" -Description "My TIDE Data Profile" -RPZFeed "my-rpz-feed" -DefaultTTL $false -State "Activated"
  Updates an existing TIDE Data Profile. The -State parameter can be used to enable/disable the profile.

Set-B1APIKey -Name "mykey" -Type "interactive" -User "user@domain.corp" -State "Disabled"
  Used to update an existing API Key, such as enabling/disabling it.
	
Enable-B1OnPremHostApplication -Name "bloxoneddihost1.mydomain.corp" -DNS -DHCP -NTP
  Allows you to enable BloxOne On-Prem Host Applications using the DNS/DHCP/NTP switches

Disable-B1OnPremHostApplication -Name "bloxoneddihost1.mydomain.corp" -DNS -DHCP -NTP
  Allows you to Disable BloxOne On-Prem Host Applications using the DNS/DHCP/NTP switches
  
Grant-B1DNSConfigProfile -Name "Edge Profile" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
  Used to add DNS Configuration Profiles to BloxOne hosts. The -Hosts parameter accepts a PSObject for long lists.

Grant-B1DHCPConfigProfile -Name "Edge Profile" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
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
  
Reboot-B1Host -OnPremHost "bloxoneddihost1.mydomain.corp" -NoWarning
  Used to reboot a BloxOneDDI Host

Deploy-B1Appliance -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.100.10" -Netmask "255.255.255.0" -Gateway "10.10.100.1" -DNSServers "10.30.10.10,10.30.10.10" -NTPServers "time.mydomain.corp" -DNSSuffix "prod.mydomain.corp" -JoinToken "JoinTokenGoesHere" -OVAPath .\BloxOne_OnPrem_VMWare_v3.1.0-4.3.10.ova -vCenter "vcenter.mydomain.corp" -Cluster "CLUSTER-001" -Datastore "DATASTORE-001" -PortGroup "PORTGROUP" -PortGroupType "VDS"
  Used to deploy the BloxOne Virtual Appliance. Requires VMware PowerCLI to be installed. All parameters are mandatory. -PortGroupType can be Standard or VDS.
```

## NIOS Cmdlets
```
Store-NIOSCredentials -Credentials ${$CredentialObject} -Persist
  Stores NIOS Credentials encrypted, can be run without -Credentials parameter for it to prompt instead. The optional -Persist parameter will persist the credentials for that user on that machine. This requires a restart of the powershell session before credentials can be used.

Get-NIOSCredentials
  Retrieves stored NIOS Credentials

Get-NIOSAuthoritativeZone -Server gridmaster.domain.corp -View External -FQDN my-dns.zone
  Retrieves a list of authoritative zones from NIOS

Get-NIOSForwardZone -Server gridmaster.domain.corp -View External -FQDN my-dns.zone
  Retrieves a list of forward zones from NIOS

Get-NIOSDelegatedZone -Server gridmaster.domain.corp -View External -FQDN my-dns.zone
  Retrieves a list of delegated zones from NIOS

New-NIOSDelegatedZone -Server gridmaster.domain.corp -FQDN delegated.my-dns.zone -Hosts @(@{"address"="1.2.3.4";"name"="bloxoneddihost1.dev.mydomain.corp";},@{"address"="2.3.4.5";"name"="bloxoneddihost2.dev.mydomain.corp";}) -View External
  Used to create a new delegated zone within NIOS

Migrate-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -CreateZones -AuthNSGs "Core DNS Group" -Confirm:$false
  Used to migrate Authoritative Subzones from NIOS to BloxOneDDI
```

## To-Do

All work below will be committed to the [dev branch](https://github.com/TehMuffinMoo/ibPS/tree/dev) until updates are posted to main.

### Implement pipeline input for all Set- & Remove- cmdlets
Pipeline input for Set- & Remove- cmdlets is being developed, to allow more flexible usage of ibPS. The table below shows the current support for this feature.
Cmdlet                           | Pipeline Input Supported                                           | Supported Input Cmdlets
-------------------------------- | ------------------------------------------------------------------ | ----------------------------
Reboot-B1Host                    | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Remove-B1AddressBlock            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock
Remove-B1AddressReservation      | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Address
Remove-B1AuthoritativeZone       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AuthoritativeZone
Remove-B1ForwardZone             | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1ForwardZone
Remove-B1FixedAddress            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1FixedAddress
Remove-B1Host                    | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Remove-B1Range                   | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Range
Remove-B1Record                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Record
Remove-B1Service                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Service
Remove-B1Subnet                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Subnet
Remove-B1APIKey                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1APIKey
Set-B1AddressBlock               | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock
Set-B1AuthoritativeZone          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AuthoritativeZone
Set-B1DHCPConfigProfile          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1DHCPConfigProfile
Set-B1FixedAddress               | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1FixedAddress
Set-B1ForwardNSG                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1ForwardNSG
Set-B1ForwardZone                | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1ForwardZone
Set-B1Host                       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Set-B1Range                      | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Range
Set-B1Record                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Record
Set-B1Subnet                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Subnet
Set-B1APIKey                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1APIKey
Start-B1DiagnosticTask           | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Start-B1Service                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Service
Stop-B1Service                   | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Service
Set-B1TDTideDataProfile          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TDTideDataProfile
Remove-B1TDSecurityPolicy        | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TDSecurityPolicy
Remove-B1TDNetworkList           | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TDNetworkList
Get-B1TDDossierLookup            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Start-B1TTDDossierLookup


### Replace old for new APIs
This is a work in progress.

Old Cmdlet           | New Cmdlet        | Old API Endpoint     | New API Endpoint    | Status
---------------------|------------------ | -------------------- | ------------------- | --------
Get-B1DNSHost        | Get-B1DNSService  | /dns/host            | /dns/service        | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)
Set-B1DNSHost        | Set-B1DNSService  | /dns/host            | /dns/service        | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)
Get-B1DHCPHost       | Get-B1DHCPService | /dhcp/host           | /dhcp/service       | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)
Get-B1DHCPHost       | Set-B1DHCPService | /dhcp/host           | /dhcp/service       | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)


## Resources
This PowerShell Module makes use of the following InfoBlox APIs;

- [CSP Cloud](https://csp.infoblox.com/apidoc)
- [NIOS](https://www.infoblox.com/wp-content/uploads/infoblox-deployment-infoblox-rest-api.pdf)

## License

MIT

---

> [Mat Cox]()
