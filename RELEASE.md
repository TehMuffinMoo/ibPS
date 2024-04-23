- Add `Get-B1DTCLBDN`, `Get-B1DTCServer`, `New-B1DTCServer`, `Get-B1DTCHealthCheck`, `Get-B1DTCPool`, `Get-B1DTCPolicy` & `Get-B1DTCStatus` functions for new DTC feature
- Fix regression where `-IncludeInheritance` was not working on `Get-B1DHCPConfigProfile`
- Add `Get-B1CSPCurrentUser` function to enable querying the user associated with the current API Key
- Add `Get-ibPSConfiguration` function to display current ibPS Configuration, including CSP URL, API User, ibPS Version, etc.
- Replace `Set-B1CSPUrl` with `Set-ibPSConfiguration` using the `-CSPRegion [Region]` or `-CSPUrl [URL]` parameters.
- Removed `Get-B1CSPUrl` in favour of output from `Get-ibPSConfiguration`
- Replace `Set-B1CSPAPIKey` with `Set-ibPSConfiguration` using the `-CSPAPIKey [API Key]` parameter.
- Removed `Get-B1CSPAPIKey` in favour of output from `Get-ibPSConfiguration` with the optional `-IncludeAPIKey` parameter

### Breaking Changes

|  **API Keys**  |
|:-------------------------|
| API Keys are converting to an encrypted format using Secure Strings. After updating to this version, any existing API keys need to be updated to avoid errors. |
| The `Set-B1CSPAPIKey` function has been removed in favour of `Set-ibPSConfiguration -CSPAPIKey <ApiKey>` |
| See the <a href="https://ibps.readthedocs.io/en/latest/General/Set-ibPSConfiguration/">Documentation</a> for further details |
