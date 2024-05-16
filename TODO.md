# To Do List
The list of items below are those which are not yet implemented within ibPS. Once implemented, they are removed from this list and added to the [release notes](https://github.com/TehMuffinMoo/ibPS/blob/dev/RELEASE.md).

## New Functions
- [ ] New-B1ForwardNSG
- [ ] New-B1AuthoritativeNSG
- [ ] New-B1DNSConfigProfile
- [ ] Set-B1DNSConfigProfile
- [X] New-B1CustomList
- [X] Set-B1CustomList
- [X] Remove-B1CustomList
- [ ] New-B1BypassCode
- [ ] Set-B1BypassCode
- [X] Remove-B1BypassCode
- [ ] Add discovery APIs when GA
- [X] Get-B1CategoryFilter
- [X] Get-B1ApplicationFilter

## Improvements
- [X] Add `-Tags` to Set-B1ForwardNSG
- [ ] Replace API calls for `dns/host` with `dns/service`
- [ ] Replace API calls for `dhcp/host` with `dhcp/service`
- [ ] Improve coverage of Pester Tests
- [ ] Add `-CustomFilters` parameter to all functions where filters are supported. See [docs](https://ibps.readthedocs.io/en/dev/#-customfilters)
- [X] Add support for response content filtering when creating or updating DTC health checks
- [ ] Add support for response content conversion when using Copy-NIOSDTCToBloxOne
- [ ] Standardise code model for Set- cmdlets.
  - [X] Set-B1AddressBlock
  - [X] Set-B1AuthoritativeZone
  - [X] Set-B1DNSHost
  - [X] Set-B1ForwardNSG
  - [X] Set-B1ForwardZone
  - [X] Set-B1DHCPConfigProfile
  - [X] Set-B1FixedAddress
  - [X] Set-B1HAGroup
  - [ ] Set-B1NTPServiceConfiguration
  - [ ] Set-B1Range
  - [ ] Set-B1Record
  - [ ] Set-B1Subnet
  - [ ] Set-B1Location
  - [ ] Set-B1APIKey
  - [ ] Set-B1Host
  - [ ] Set-B1CustomList
  - [ ] Set-B1InternalDomainList
  - [ ] Set-B1LookalikeTarget
  - [ ] Set-B1SOCInsight
  - [ ] Set-B1TideDataProfile
  - [ ] Set-B1DHCPGlobalConfig
## Bug Fixes
- [ ] Investigate occasional errors when using `Get-ibPSVersion -Cleanup`