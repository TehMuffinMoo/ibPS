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
