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
| See the <a href="https://ibps.readthedocs.io/en/latest/Change%20Log/#:~:text=BloxOne%20Platform-,BloxOne%20Threat%20Defense,-Generic%20Wrapper">Documentation</a> for further details |

