- Add `New-B1DelegatedZone` and `Remove-B1DelegatedZone` functions
- Add `-ForwardOnly` flag to `New-B1ForwardZone` function
- Add `-Tags` parameter to `New-B1AddressReservation`, `New-B1ForwardZone`, `Set-B1Record`, `Set-B1ForwardZone` & `Set-B1DHCPConfigProfile`
- Remove mandatory flag for `-Name` and `-Description` parameters on `New-B1AddressReservation` & `New-B1FixedAddress`
- Add `-DevelopmentMode` parameter to `Get-ibPSVersion` to enable exporting private functions for the purpose of development
- Add numerous pester tests
- Add auto/tab completion for `-Container` parameter on `Get-B1ServiceLog`
- Removed mandatory flag for `-DNSServers`, `-NTPServers` & `-DNSSuffix` parameters on `Deploy-B1Appliance`
- Add `-Offset` parameter to `Get-B1DHCPLease`
- Add new `Get-B1DHCPHardwareFilter` function
- When specifying >10K and <50K as the `-Limit` parameter on `Get-B1DNSLog`, the function will now call the **export** API endpoint allowing retrieval of larger datasets.
- Add `Get-B1ZoneChild` and `Get-B1IPAMChild` functions for listing child objects related to IP Spaces, Subnets, Address Blocks, Ranges, DNS Views & Zones.
- Add pipeline support for `Get-B1AddressBlock` into `Get-B1AddressBlockNextAvailable`
- Add support for entering fully qualified CIDR addresses using the `-Subnet` parameter on `Get-B1AddressBlock` and `Get-B1Subnet`
- Add `Get-B1SubnetNextAvailable` and `Get-B1AddressNextAvailable` for next available subnets and IP addresses respectively.
- Add `ConvertTo-RNAME` and `ConvertTo-PunyCode` functions

| Breaking Changes - **Deploy-B1Appliance**|
|:--------------------------------------------------|
| The `-DNSServers` parameter has had its type changed to `[IPAddress[]]` and `-NTPServers` has changed to `[String[]]` and so both should now be entered as a list rather than a comma-separated string |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Platform/Deploy-B1Appliance/#example-1">Documentation</a> for further details |