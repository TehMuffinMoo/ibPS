## 1.9.7.3
- Add Azure support to `Deploy-B1Appliance`
- Fix paths issue when using `Deploy-B1Appliance -Type VMware` on Mac/Linux

## 1.9.7.2
- Improve `Get-B1CustomList`
- Add `-Compartments` paremeter to `Get-B1CSPCurrentUser`
- Fix some typos
- Fix bug when updating tags using `Set-B1AddressBlock` and `Set-B1Subnet` [#139](https://github.com/TehMuffinMoo/ibPS/issues/139)

## 1.9.7.1
- Add `Get-B1Compartment` for listing Organizational Compartments
- Add support for configuring Organizational Compartments when using:

|                            |                            |                            |
|:---------------------------|:---------------------------|:---------------------------|
| `New-B1AuthoritativeZone`  | `New-B1AddressBlock`       | `New-B1Space`              |
| `Set-B1AuthoritativeZone`  | `Set-B1AddressBlock`       |                            |

- Add support for filtering by Organizational Compartment when using:

|                            |                            |                            |
|:---------------------------|:---------------------------|:---------------------------|
| `Get-B1Subnet`             | `Get-B1AddressBlock`       | `Get-B1Range`              |
| `Get-B1AuthoritativeZone`  | `Get-B1ForwardZone`        | `Get-B1Record`             |
| `Get-B1Address`            | `Get-B1Space`              |                            |

- Add/Align `-CustomFilters` support to:

|                            |                            |                            |
|:---------------------------|:---------------------------|:---------------------------|
| `Get-B1AuthoriativeNSG`    | `Get-B1AuthoriativeZone`   | `Get-B1CloudProvider`      |
| `Get-B1DelegatedZone`      | `Get-B1DFP`                | `Get-B1DHCPConfigProfile`  |
| `Get-B1DHCPHardwareFilter` | `Get-B1DHCPHost`           | `Get-B1DHCPLease`          |
| `Get-B1DHCPOptionCode`     | `Get-B1DHCPOptionGroup`    | `Get-B1DHCPOptionSpace`    |
| `Get-B1DNSACL`             | `Get-B1DNSConfigProfile`   | `Get-B1DNSHost`            |
| `Get-B1DNSView`            | `Get-B1DTCHealthCheck`     | `Get-B1DTCLBDN`            |
| `Get-B1DTCPolicy`          | `Get-B1DTCPool`            | `Get-B1DTCServer`          |
| `Get-B1FixedAddress`       | `Get-B1ForwardNSG`         | `Get-B1ForwardZone`        |
| `Get-B1HAGroup`            | `Get-B1Range`              | `Get-B1Record`             |
| `Get-B1Space`              | `Get-B1Subnet`             | `Get-B1Address`            |
| `Get-B1AddressBlock`       | `Get-B1AuditLog`           | `Get-B1APIKey`             |
| `Get-B1DNSEvent`           | `Get-B1Location`           | `Get-B1SecurityLog`        |
| `Get-B1Tag`                | `Get-B1User`               | `Get-B1UserAPIKey`         |
| `Get-B1Host`               | `Get-B1Service`            | `Get-B1ApplicationFilter`  |
| `Get-B1BypassCode`         | `Get-B1CategoryFilter`     | `Get-B1CustomList`         |
| `Get-B1InternalDomainList` | `Get-B1LookalikeDomains`   | `Get-B1Lookalikes`         |
| `Get-B1NetworkList`        | `Get-B1PoPRegion`          | `Get-B1SecurityPolicy`     |
| `Get-B1SecurityPolicyRules`| `Get-B1ThirdPartyProvider` |                            |

## 1.9.7.0
- Add new `Resolve-DoHQuery` function to enable querying DNS over HTTPS endpoints
- Add new `-DoHServer` parameter to `Set-ibPSConfiguration` to set persistent DoH Server URL
- Add new `DoH Server` value to `Get-ibPSConfiguration` to get the configured DoH Server URL
- Add Global DNS AnyCast Addresses to `Get-B1PopRegion` output
- Add `Get-B1CloudProvider` function to enable retrieving configured AWS/GCP/Azure Cloud Providers
- Add `Get-B1ThirdPartyProvider` function to enable retrieving configured Third Party DNS & IPAM/DHCP Providers
- Add `Set-B1DNSACL` function to update existing DNS Access Control Lists
- Add `New-B1DNSACLItem` function to enable easy creation of DNS ACL Objects to add/remove from DNS ACLs. See [Set-B1DNSACL](https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20DDI/Set-B1DNSACL/) & [New-B1DNSACLItem](https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20DDI/New-B1DNSACLItem/) for further details.
- Add `New-B1SecurityPolicy` for creating new BloxOne Threat Defense Security Policies
- Add `New-B1SecurityPolicyRule` for providing a simple way to build a list of rules to apply to a Security Policy
- Add `Set-B1SecurityPolicy` for updating existing BloxOne Threat Defense Security Policies
- Add `New-B1DoHFQDN` for generating new DNS over HTTPS FQDNs for BloxOne Threat Defense.
- Add `Get-B1Endpoint` for retrieving BloxOne Threat Defense Endpoints
- Add `Get-B1EndpointGroup` for retrieving BloxOne Threat Defense Endpoint Groups
- Fixed some issues with `Get-B1DNSLog` & `Get-B1DHCPLog` in large environments. (1000+ DNS or DHCP Services)
- Remove `-Branch` parameter from Set-ibPSConfiguration. Branch is now determind by the `build.json` file, switching branches should be performed using [this method](https://github.com/TehMuffinMoo/ibPS?tab=readme-ov-file#installing-from-github).

### Breaking Changes

|  **Add `-NewName` parameter to `Set-B1Host` to align it with other functions**  |
|:-------------------------|
| Previously, if the `-IP` parameter was set then the `-Name` parameter would be used to update the host name. |
| This functionality is changing to use the `-NewName` parameter instead. |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Platform/Set-B1Host/">Documentation</a> for further details |


## 1.9.6.0
- Fix bug with `Get-B1DTCStatus` when objects are in a specific status
- Various improvements to `Copy-NIOSDTCToBloxOne`
- Add `Copy-NIOSDTCToBloxOne` function to enable migration of Dynamic Traffic Control (DTC) LBDNs from NIOS to the new DTC in BloxOne DDI.
- Add `Get-B1Location`, `New-B1Location`, `Set-B1Location` & `Remove-B1Location` functions for managing Locations within BloxOne DDI
- Add `-Location` parameter to `Set-B1Host` and `New-B1Host` to set the location of the host
- Add `Get-B1CustomList`, `New-B1CustomList`, `Set-B1CustomList` & `Remove-B1CustomList` functions for managing custom lists
- Add `Get-B1BypassCode` & `Remove-B1BypassCode` to manage bypass codes
- Add `Get-B1ApplicationFilter` & `Get-B1CategoryFilter` functions to manage BloxOne Threat Defense filters
- Removed `-NoIPSpace` parameter from `Set-B1Host` as it was not necessary.
- Add optional telemetry data, this is DISABLED by default and must be manually enabled using `Set-ibPSConfiguration -Telemetry Enabled`. The only data which is submitted is a random identifier, the ibPS Version and the ibPS function which was called (without arguments).
- Add the CSP Account name to the output of `Get-ibPSConfiguration`
- Add `-Name` and `-Strict` parameters to `Get-B1FixedAddress`
- Add `-NewName`, `-Description`, `-EnableDDNS`, `-Send-DDNSUpdates` & `-DDNSDomain` parameters to `Set-B1DHCPConfigProfile`
- Add `-NewName` parameter to `Set-B1AddressBlock`
- Add `-NewName` parameter to `Set-B1Subnet`
- Add `-NewName` parameter to `Set-B1Range`
- Add `-NewName` parameter to `Set-B1Record`
- Add `-NewName` parameter to `Set-B1HAGroup`
- Add `-State`, `-NotifyExternalSecondaries` & `-Tags` parameters to `Set-B1AuthoritativeZone`
- Add `-NewName`, `-Description` & `-Tags` parameters to `Set-B1ForwardNSG`
- Add `-NewName` & `-Description` parameters to `Set-B1HAGroup`
- Add `-ForwardOnly` & `-Description` parameters to `Set-B1ForwardZone`
- Add `-CollectStats` to `Get-B1HAGroup` to grab additional status / metrics for the HA Group and its members
- Refactor code on the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Set-B1ForwardNSG`        | `Set-B1DNSHost`           | `Set-B1AuthoritativeZone` |
| `Set-B1ForwardZone`       | `Set-B1AddressBlock`      | `Set-B1DHCPConfigProfile` |
| `Set-B1FixedAddress`      | `Set-B1HAGroup`           | `Set-B1HAGroup`           |
| `Set-B1Range`             | `Set-B1Record`            | `Set-B1Subnet`            |
| `Set-B1APIKey`            |                           |                           |

## 1.9.5.0
- Add `Get-B1DTCLBDN`, `Get-B1DTCServer`, `Get-B1DTCHealthCheck`, `Get-B1DTCPool`, `Get-B1DTCPolicy` & `Get-B1DTCStatus` functions for new DTC feature
- Add `New-B1DTCLBDN`, `New-B1DTCServer`, `New-B1DTCHealthCheck`, `New-B1DTCPool`, `New-B1DTCPolicy` & `New-B1DTCTopologyRule` functions for new DTC feature
- Add `Set-B1DTCLBDN`, `Set-B1DTCServer`, `Set-B1DTCHealthCheck`, `Set-B1DTCPool` & `Set-B1DTCPolicy` functions for new DTC feature
- Add `Remove-B1DTCLBDN`, `Remove-B1DTCServer`, `Remove-B1DTCHealthCheck`, `Remove-B1DTCPool` & `Remove-B1DTCPolicy` functions for new DTC feature
- Add `-CloudCheckTimeout` to `Deploy-B1Appliance`. Default increased from 120s to 300s
- Fix regression where `-IncludeInheritance` was not working on `Get-B1DHCPConfigProfile`
- Add `Get-B1CSPCurrentUser` function to enable querying the user associated with the current API Key
- Add `Get-ibPSConfiguration` function to display current ibPS Configuration, including CSP URL, API User, ibPS Version, etc.
- Replace `Set-B1CSPUrl` with `Set-ibPSConfiguration` using the `-CSPRegion [Region]` or `-CSPUrl [URL]` parameters.
- Removed `Get-B1CSPUrl` in favour of output from `Get-ibPSConfiguration`
- Replace `Set-B1CSPAPIKey` with `Set-ibPSConfiguration` using the `-CSPAPIKey [API Key]` parameter.
- Removed `Get-B1CSPAPIKey` in favour of output from `Get-ibPSConfiguration` with the optional `-IncludeAPIKey` parameter

### Breaking Changes

|  **API Keys Will Need Updating!**  |
|:-------------------------|
| API Keys used by ibPS are converting to an encrypted format. After updating to this version, any existing API keys stored on your machine will need to be updated to avoid errors. |
| This can be done by using `Set-ibPSConfiguration -CSPAPIKey <ApiKey>` |
| See the <a href="https://ibps.readthedocs.io/en/latest/General/Set-ibPSConfiguration/">Documentation</a> for further details |


## 1.9.4.3
- Fix parallelisation bug with new `Get-NetworkTopology` cmdlet when running on PowerShell 7.x
- Remove old Write-Host debug message from `Get-B1Service`
- Rename `Query-CSP` and `Query-NIOS` to `Invoke-CSP` and `Invoke-NIOS`
- Export `Invoke-CSP` and `Invoke-NIOS` as usable functions where raw API usage is desired. See [Invoke-CSP](https://ibps.readthedocs.io/en/latest/BloxOne/Generic%20Wrapper/Invoke-CSP/) and [Invoke-NIOS](https://ibps.readthedocs.io/en/latest/NIOS/) for further details on usage.
- Rename `Reboot-B1Host` to `Restart-B1Host`

## 1.9.4.2
- Fix bug when creating new services [#123](https://github.com/TehMuffinMoo/ibPS/issues/123)
- Add new `Get-NetworkTopology` function to provide either a text or HTML based visual topology of an IP Space, Address Block, Subnet or Range.
- Add new `Get-B1InternalDomainList`, `Set-B1InternalDomainList`, `New-B1InternalDomainList` & `Remove-B1InternalDomainList` functions
- Add `-Recurse` option to `Get-B1IPAMChild` to optionally retrieve recursive child objects and append to a new "Children" value
- Add `-Cleanup` parameter to `Get-ibPSVersion` as a helper to optionally cleanup old versions still lingering around. Best to run as Administrator.
- Add the ability to enter more than one `-Type` when using `Get-B1IPAMChild`
- Standardise and improve the Debug logging when Debug mode is enabled (`Set-ibPSConfiguration -DebugMode Enabled`)
- Add `-AccountSpecific` parameter to `Get-B1LookalikeTargetCandidates`
- Add `-Offset` parameter to `Get-B1ServiceLog` & `Get-B1Service`
- Add `-tfilter` parameter to `Get-B1DNSACL`, ,`Get-B1SecurityPolicy` & `Get-B1ThreatFeeds`
- Add `-Fields` parameter to `Get-B1SecurityPolicy`,`Get-B1ThreatFeeds` & `Get-B1LookalikeTargetSummary`
- Add `-Limit` & `-Offset` parameters to the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Get-B1Tag`               | `Get-B1AuthoritativeNSG`  | `Get-B1DFP`               |
| `Get-B1DHCPOptionCode`    | `Get-B1DHCPOptionGroup`   | `Get-B1DHCPOptionSpace`   |
| `Get-B1DNSACL`            | `Get-B1PoPRegion`         | `Get-B1SecurityPolicy`    |
| `Get-B1ThreatFeeds`       |                           |                           |

- Add `-OrderBy` parameter to the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Get-B1APIKey`            | `Get-B1DNSACL`            | `Get-B1Service`           |
| `Get-B1AuditLog`          | `Get-B1DNSConfigProfile`  | `Get-B1Host`              | 
| `Get-B1User`              | `Get-B1DNSHost`           | `Get-B1BootstrapConfig`   |
| `Get-B1Address`           | `Get-B1DNSView`           | `Get-B1DHCPOptionSpace`   |
| `Get-B1AddressBlock`      | `Get-B1FixedAddress`      | `Get-B1ZoneChild`         |
| `Get-B1AuthoritativeNSG`  | `Get-B1ForwardNSG`        | `Get-B1DHCPOptionGroup`   |
| `Get-B1AuthoritativeZone` | `Get-B1ForwardZone`       | `Get-B1Subnet`            |
| `Get-B1DelegatedZone`     | `Get-B1HAGroup`           | `Get-B1DHCPOptionCode`    |
| `Get-B1DHCPConfigProfile` | `Get-B1IPAMChild`         | `Get-B1Space`             |
| `Get-B1DHCPHardwareFilter`| `Get-B1Range`             | `Get-B1DHCPLease`         |
| `Get-B1DHCPHost`          | `Get-B1Record`            |

- Add `-OrderByTag` parameter to the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Get-B1Address`           | `Get-B1AddressBlock`      | `Get-B1AuthoritativeNSG`  |
| `Get-B1AuthoritativeZone` | `Get-B1DelegatedZone`     | `Get-B1DFP`               | 
| `Get-B1DHCPConfigProfile` | `Get-B1DHCPHardwareFilter`| `Get-B1DHCPHost`          |
| `Get-B1DNSACL`            | `Get-B1DNSConfigProfile`  | `Get-B1DNSHost`           |
| `Get-B1DNSView`           | `Get-B1FixedAddress`      | `Get-B1ForwardNSG`        |
| `Get-B1ForwardZone`       | `Get-B1HAGroup`           | `Get-B1IPAMChild`         |
| `Get-B1Range`             | `Get-B1Space`             | `Get-B1Subnet`            |
| `Get-B1ZoneChild`         | `Get-B1Host`              | `Get-B1Service`           |
| `Get-B1InternalDomainList`|                           |                           |


## 1.9.4.1
- Fix bug when updating Subnets/Address blocks [#118](https://github.com/TehMuffinMoo/ibPS/issues/118)


## 1.9.4.0
- Add `New-B1DelegatedZone` and `Remove-B1DelegatedZone` functions
- Add `-ForwardOnly` flag to `New-B1ForwardZone` function
- Add `-Tags` parameter to `New-B1AddressReservation`, `New-B1ForwardZone`, `Set-B1Record`, `Set-B1ForwardZone` & `Set-B1DHCPConfigProfile`
- Add numerous pester tests
- Add auto/tab completion for `-Container` parameter on `Get-B1ServiceLog`
- Add `-Offset` parameter to `Get-B1DHCPLease`
- Add new `Get-B1DHCPHardwareFilter` function
- Add `Get-B1ZoneChild` and `Get-B1IPAMChild` functions for listing child objects related to IP Spaces, Subnets, Address Blocks, Ranges, DNS Views & Zones.
- Add pipeline support for `Get-B1AddressBlock` into `Get-B1AddressBlockNextAvailable`
- Add support for entering fully qualified CIDR addresses using the `-Subnet` parameter on `Get-B1AddressBlock` and `Get-B1Subnet`
- Add `Get-B1SubnetNextAvailable` and `Get-B1AddressNextAvailable` for next available subnets and IP addresses respectively.
- Add `ConvertTo-RNAME` and `ConvertTo-PunyCode` functions
- Add threat class description to results for `Get-B1TideThreatClass` where available
- Add `Get-B1SOCInsight`,`Get-B1SOCInsightAssets`,`Get-B1SOCInsightComments`,`Get-B1SOCInsightEvents`,`Get-B1SOCInsightIndicators` functions for querying a list of Insights & associated data from SOC Insights
- Add `Set-B1SOCInsight` to allow adding comments or toggling the Insight state between Active & Closed
- Add threat insight classes both as a function `Get-B1TideThreatInsightClasses` and also as part of the `-ThreatClass` auto-completion
- Add `Get-B1HostLocalAccess`, `Enable-B1HostLocalAccess` and `Disable-B1HostLocalAccess` functions to obtain the current state and enable/disable the Local Access Bootstrap UI
- Add new `Set-ibPSConfiguration` function for enabling Development and/or Debug mode
- When specifying >10K and <50K as the `-Limit` parameter on `Get-B1DNSLog`, the function will now call the **export** API endpoint allowing retrieval of larger datasets.
- Remove mandatory flag for `-Name` and `-Description` parameters on `New-B1AddressReservation` & `New-B1FixedAddress`
- Removed mandatory flag for `-DNSServers`, `-NTPServers` & `-DNSSuffix` parameters on `Deploy-B1Appliance`
- The `-OnPremHost` parameter has been renamed to `-B1Host` for following functions: `Get-B1ServiceLog`, `Start-B1Export`, `Get-B1HealthCheck`, `New-B1Service`, `Reboot-B1Host`, `Start-B1DiagnosticTask`. Parameter aliases have been put in place to prevent breaking of existing scripts. These aliases will be deprecated eventually.

### Breaking Changes

|  **Deploy-B1Appliance**  |
|:-------------------------|
| The `-DNSServers` parameter has had its type changed to `[IPAddress[]]` and `-NTPServers` has changed to `[String[]]` and so both should now be entered as a list rather than a comma-separated string |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Platform/Deploy-B1Appliance/#example-1">Documentation</a> for further details |

|**BloxOne Threat Defense**|
|:-------------------------|
| All BloxOne Threat Defense related functions have been renamed to remove the `TD` part of the command suffix. |
| Functions previously using `Get-B1TD...` `Set-B1TD...` etc. will now move to `Get-B1...` and `Set-B1...`.This is to align with the rest of the module. |
| See the <a href="https://ibps.readthedocs.io/en/latest/Change%20Log/#:~:text=BloxOne%20Platform-,BloxOne%20Threat%20Defense,-Generic%20Wrapper">Documentation</a> for further details |



## 1.9.3.0
- Add `New-B1TDLookalikeTarget`, `Remove-B1TDLookalikeTarget`, `Set-B1TDLookalikeTarget` cmdlets
- Add `Get-B1Licenses` cmdlet to retrieve license information
- Add `Get-B1TDLookalikeTargetSummary` cmdlet for lookalike summary, the same as the Activity page within the CSP.
- Add `Enable-B1TDLookalikeTargetCandidate` & `Disable-B1TDLookalikeTargetCandidate` cmdlets. The -Domain parameter auto-completes based on available domains.
- Add `Enable-B1TDLookalike` and `Disable-B1TDLookalike` for Unmuting/Muting lookalike domains
- Add `Submit-B1TDTideData` for submitting TIDE data either as individual records, or from CSV/TSV/PSV, JSON & XML files. The `ThreatClass` and `-ThreatProperty` parameters support tab-completion.
- Added tab-completion to the `-ThreatClass` and `-ThreatProperty` parameters on `Get-B1DNSEvent` 
- Split BloxOne Platform cmdlets into separate directory for better documentation structure
- Update all parameter set names to something more friendly

| Breaking Changes - **`Get-B1DFPLog`**     |
|:--------------------------------------------------|
| The new `-Source` parameter has been renamed to `-Network` to make it consistent with `Get-B1DNSEvent` and the underlying API naming scheme |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Cloud/Get-B1DFPLog/">Documentation</a> for further details |

## 1.9.2.10
- Remove mandatory flag in the `New-B1Subnet` & `New-B1Space` cmdlets for the `-Name` parameter
- Split BloxOne DDI & BloxOne Threat Defense functions to aid better documentation separation
- Updated most of the BloxOne Threat Defense Help Information/Documentation

| Breaking Changes - **`Get-B1DFPLog`**     |
|:--------------------------------------------------|
|The `-Source` parameter has been renamed to `-IP` to make it consistent with `Get-B1DNSLog`<br>A new `-Source` parameter has been created. This is used to specify the Source of the DNS Event (i.e DFP, External Network or Endpoint) and allows multiple values to be inputted |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Cloud/Get-B1DFPLog/">Documentation</a> for further details |

- v1.9.2.7, v1.9.2.8 & v1.9.2.9 were skipped due to issues with the automated package provisioning.


## 1.9.2.6
- New documentation available at <a href="https://ibps.readthedocs.io/">ibPS</a>
- Update comment-based help of various cmdlets
- Create new provisioning workflow for future updates, including full change and release history in the RELEASE.md and CHANGELOG.md files


## 1.9.2.5
- Add New-B1Object cmdlet to the generic cmdlet offering. This now includes all Get, Set, New & Remove cmdlets.


## 1.9.2.4
- Update New-B1Service & Get-B1Service to replace service specific parameters to a dynamically generated -Type parameter.

| Breaking Changes  |
|:--------------------------------------------------|
|The -DNS, -DHCP & -NTP parameters have been removed from New-B1Service in favour of a -Type parameter where the options are generated automatically.<br>The syntax would now be something like; |
| `New-B1Service -Type dns -Name "dns_myb1host -OnPremHost "myb1host"` |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Platform/New-B1Service/">Documentation</a> for further details |


## 1.9.2.3
- Fix issue deploying BloxOne OVA with Infoblox self-signed certificate


## 1.9.2.2
- Add support for secondary zones when using Get-B1AuthoritativeZone & New-B1AuthoritativeZone


## 1.9.2.1
- Fix to Set-B1HAGroup on Windows devices


## 1.9.2
- Fixes to Set-B1Object, creds for VMware deployments, introduce a new Set-B1HAGroup cmdlet and an optional -Associations parameter to list associated subnets/ranges when querying Get-B1DHCPHost


## 1.9.1.9
- Update Start-B1Export with latest version control + some minor enhancement


## 1.9.1.8
- Add -Branch parameter to Get-ibPSVersion to support changing between main/dev branches


## 1.9.1.7
- Introduce -DownloadLatestImage and -ImagesPath for automatically obtaining latest image and providing local cache to avoid duplicate downloads


## 1.9.1.6
- Hyper-V deployment integration using Deploy-B1Appliance


## 1.9.1.1
- Add -Fields parameter on all supported Get- cmdlets


## 1.9.1.0
- Minor updates & begin testing -CustomFilters parameter


## 1.9.0.108
- Improve multiple version checking


## 1.9.0.107
- Cleanup misc functions


## 1.9.0.106
- Add warning when multiple versions of ibPS are present on the computer


## 1.9.0.105
- Import Miscellaneous Functions


## 1.9.0.104
- Cleanup Miscellaneous Functions


## 1.9.0.103
- Fix issue with version being displayed when using Get-ibPSVersion on Windows


## 1.9.0.99
- Initial Gallery Publication










