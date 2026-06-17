- Fix bug with `Remove-B1Space` & `Remove-B1Subnet` where id was incorrectly processed due to old references
- Fix bug with `Remove-B1Record` where the WhatIf message was invalid
- Fix bug with `New-B1LookalikeTarget` failing to submit if there were no existing domains
- Fix bug with `Remove-B1LookalikeTarget` throwing an error (but completing the operation) when it is removing the last domain in the list
- Removed various `Write-Host` statements during object creation, in favour of returning the created object
- Bugfix with `Get-B1DIagnosticTask` not retrieving information due to misaligned CSP URL
- Updated `-B1Host` parameter to `-Server` to better reflect what it is. `-B1Host` has been retained as an alias for backwards compatibility.
- Refactor argument completion, to enable better maintainability and continued improvements
- Fix bug with Start-B1Export with inconsistencies between EU/US realm
- Enable support for .csv backups via Start-B1Export
- Add various new tab-completion parameters

|        Parameter           |         Functions          |
|:---------------------------|:---------------------------|
| `-Server`                  | `Disable-B1HostLocalAccess`,`Enable-B1HostLocalAccess`,`Get-B1HealthCheck`,`Get-B1BootstrapConfig`,`Get-B1HostLocalAccess`,`Get-B1ServiceLog`,`New-B1Service`,`Restart-B1Host`,`Start-B1DiagnosticTask` |
| `-Name`                    | `Get-B1Host`, `Set-B1Host`, `Remove-B1Host` |
| `-Space`                   | `Get-B1Host`,`New-B1Host`,`Set-B1Host`,`Get-B1Address`,`Get-B1AddressBlock`,`Get-B1AddressBlockNextAvailable`,`Get-B1DHCPLease`,`Get-B1DNSUsage`,`Get-B1FixedAddress`,`Get-B1Range`,`Get-B1Subnet`,`Get-B1SubnetNextAvailable`,`New-B1AddressBlock`,`New-B1AddressReservation`,`New-B1DNSView`,`New-B1FixedAddress`,`New-B1Range`,`New-B1Subnet`,`Remove-B1AddressBlock`,`Remove-B1AddressReservation`,`Remove-B1FixedAddress`,`Remove-B1Range`,`Remove-B1Subnet`,`Set-B1AddressBlock`,`Set-B1FixedAddress`,`Set-B1Range`,`Set-B1Subnet` |
| `-PrimaryNode`, `SecondaryNode` | `New-B1HAGroup`, `Set-B1HAGroup` |
| `-Name`                    | `Get-B1HAGroup`, `Set-B1HAGroup`, `Remove-B1HAGroup` |
| `-View`                    | `Remove-B1DNSView`,`Get-B1AuthoritativeZone`,`Get-B1DelegatedZone`,`Get-B1DTCLBDN`,`Get-B1ForwardZone`,`Get-B1Record`,`New-B1AuthoritativeZone`,`New-B1DelegatedZone`,`New-B1ForwardZone`,`New-B1Record`,`Remove-B1AuthoritativeZone`,`Remove-B1DelegatedZone`,`Remove-B1ForwardZone`,`Remove-B1Record`,`Set-B1AuthoritativeZone`,`Set-B1ForwardZone`,`Set-B1Record`,`Set-B1DTCLBDN`,`New-B1DTCLBDN`,`Set-B1DHCPGlobalConfig`,`Set-B1DHCPConfigProfile`,`New-B1DHCPConfigProfile`,`Get-B1DNSEvent` |
| `-Name`                    | `Get-B1DNSView`, `Set-B1DNSView`, `Remove-B1DNSView` |
| `-DHCPServer`              | `Get-B1DHCPLog`, `Get-B1DHCPLease` |
