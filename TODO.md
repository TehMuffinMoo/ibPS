# To Do List
The list of items below are those which are not yet implemented within ibPS. Once implemented, they are removed from this list and added to the [release notes](https://github.com/TehMuffinMoo/ibPS/blob/dev/RELEASE.md).

## New Functions
- [ ] New-B1ForwardNSG
- [ ] New-B1AuthoritativeNSG
- [ ] New-B1DNSConfigProfile
- [ ] Set-B1DNSConfigProfile
- [ ] New-B1BypassCode
- [ ] Set-B1BypassCode
- [ ] Add discovery APIs when GA
- [ ] Set-B1DNSView
- [ ] New-B1DNSACL
- [ ] Remove-B1DNSACL
- [ ] Set-B1Endpoint
- [ ] Remove-B1Endpoint
- [ ] New-B1EndpointGroup
- [ ] Set-B1EndpointGroup
- [ ] Remove-B1EndpointGroup
- [ ] Get-B1CustomRedirect

## Improvements
- [ ] Replace API calls for `dns/host` with `dns/service`
- [ ] Replace API calls for `dhcp/host` with `dhcp/service`
- [ ] Improve coverage of Pester Tests
- [ ] Add `-CustomFilters` parameter to all functions where filters are supported. See [docs](https://ibps.readthedocs.io/en/dev/#-customfilters)
- [ ] Investigate the naming convention of Set-B1NTPServiceConfiguration
- [ ] Add TSIG_KEY support to `Set-B1DNSACL` & `New-B1DNSACLItem`
- [ ] Add IPAM Hosts, Tags & Metadata Network Scope support for `New-B1SecurityPolicy` & `Set-B1SecurityPolicy`

## Bug Fixes