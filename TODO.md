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
- [ ] Add `-Tags` to Set-B1ForwardNSG
- [ ] Add `-Tags` to Set-B1DNSHost
- [ ] Replace API calls for `dns/host` with `dns/service`
- [ ] Replace API calls for `dhcp/host` with `dhcp/service`
- [ ] Improve coverage of Pester Tests
- [ ] Add `-CustomFilters` parameter to all functions where filters are supported. See [docs](https://ibps.readthedocs.io/en/dev/#-customfilters)
- [X] Add support for response content filtering when creating or updating DTC health checks
- [ ] Add support for response content conversion when using Copy-NIOSDTCToBloxOne

## Bug Fixes
- [ ] Investigate occasional errors when using `Get-ibPSVersion -Cleanup`