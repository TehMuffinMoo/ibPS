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
- Add `-State`, `-NotifyExternalSecondaries` & `-Tags` parameters to `Set-B1AuthoritativeZone`
- Add `-NewName`, `-Description` & `-Tags` parameters to `Set-B1ForwardNSG`
- Add `-ForwardOnly` & `-Description` parameter to `Set-B1ForwardZone`
- Refactor code on the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Set-B1ForwardNSG`        | `Set-B1DNSHost`           | `Set-B1AuthoritativeZone` |
| `Set-B1ForwardZone`       | `Set-B1AddressBlock`      | `Set-B1DHCPConfigProfile` |
| `Set-B1FixedAddress`      |  |  |