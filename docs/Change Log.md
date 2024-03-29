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
- Add `-Page` parameter to `Get-B1DNSEvent` to enable better pagination
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
| See the <a href="https://ibps.readthedocs.io/en/dev/Change%20Log/#:~:text=BloxOne%20Platform-,BloxOne%20Threat%20Defense,-Generic%20Wrapper">Documentation</a> for further details |



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
| See the <a href="https://ibps.readthedocs.io/en/dev/BloxOne/BloxOne%20Cloud/Get-B1DFPLog/">Documentation</a> for further details |

## 1.9.2.10
- Remove mandatory flag in the `New-B1Subnet` & `New-B1Space` cmdlets for the `-Name` parameter
- Split BloxOne DDI & BloxOne Threat Defense functions to aid better documentation separation
- Updated most of the BloxOne Threat Defense Help Information/Documentation

| Breaking Changes - **`Get-B1DFPLog`**     |
|:--------------------------------------------------|
|The `-Source` parameter has been renamed to `-IP` to make it consistent with `Get-B1DNSLog`<br>A new `-Source` parameter has been created. This is used to specify the Source of the DNS Event (i.e DFP, External Network or Endpoint) and allows multiple values to be inputted |
| See the <a href="https://ibps.readthedocs.io/en/dev/BloxOne/BloxOne%20Cloud/Get-B1DFPLog/">Documentation</a> for further details |

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

