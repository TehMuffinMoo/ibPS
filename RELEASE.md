- Add `New-B1DelegatedZone` and `Remove-B1DelegatedZone` functions
- Add `-ForwardOnly` flag to `New-B1ForwardZone` function
- Add `-Tags` parameter to `New-B1AddressReservation`, `New-B1ForwardZone`, `Set-B1Record`, `Set-B1ForwardZone` & `Set-B1DHCPConfigProfile`
- Remove mandatory flag for `-Name` and `-Description` parameters on `New-B1AddressReservation` & `New-B1FixedAddress`
- Add `-DevelopmentMode` parameter to `Get-ibPSVersion` to enable exporting private functions for the purpose of development
- Add numerous pester tests
- Add auto/tab completion for `-Container` parameter on `Get-B1ServiceLog`
- Removed mandatory flag for `-DNSServers`, `-NTPServers` & `-DNSSuffix` parameters on `Deploy-B1Appliance`
| Breaking Changes - **Deploy-B1Appliance**|
|:--------------------------------------------------|
| The `-DNSServers` parameter has had its type changed to `[IPAddress[]]`, so should now be entered as a list rather than a comma-separated string |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Platform/Deploy-B1Appliance/#example-1">Documentation</a> for further details |