- Add new `Resolve-DoHQuery` function to enable querying DNS over HTTPS endpoints
- Add new `-DoHServer` parameter to `Set-ibPSConfiguration` to set persistent DoH Server URL
- Add new `DoH Server` value to `Get-ibPSConfiguration` to get the configured DoH Server URL
- Add Global DNS AnyCast Addresses to `Get-B1PopRegion` output
- Add `Get-B1CloudProvider` function to enable retrieving configured AWS/GCP/Azure Cloud Providers
- Add `Get-B1ThirdPartyProvider` function to enable retrieving configured Third Party DNS & IPAM/DHCP Providers
- Add `Set-B1DNSACL` function to update existing DNS Access Control Lists
- Add `New-B1DNSACLItem` function to enable easy creation of DNS ACL Objects to add/remove from DNS ACLs. See [Set-B1DNSACL](https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20DDI/Set-B1DNSACL/) & [New-B1DNSACLItem](https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20DDI/New-B1DNSACLItem/) for further details.
- Add `New-B1SecurityPolicy` for creating new BloxOne Threat Defense Security Policies
- Add `New-B1SecurityPolicyRule` for providing a simple way to build a list of rules to apply to a Security Policy
- Add `Set-B1SecurityPolicy` for updating existing BloxOne Threat Defense Security Policies
- Add `New-B1DoHFQDN` for generating new DNS over HTTPS FQDNs for BloxOne Threat Defense.
- Add `Get-B1Endpoint` for retrieving BloxOne Threat Defense Endpoints
- Add `Get-B1EndpointGroup` for retrieving BloxOne Threat Defense Endpoint Groups
- Fixed some issues with `Get-B1DNSLog` & `Get-B1DHCPLog` in large environments. (1000+ DNS or DHCP Services)
- Remove `-Branch` parameter from Set-ibPSConfiguration. Branch is now determind by the `build.json` file, switching branches should be performed using [this method](https://github.com/TehMuffinMoo/ibPS?tab=readme-ov-file#installing-from-github).

### Breaking Changes

|  **Add `-NewName` parameter to `Set-B1Host` to align it with other functions**  |
|:-------------------------|
| Previously, if the `-IP` parameter was set then the `-Name` parameter would be used to update the host name. |
| This functionality is changing to use the `-NewName` parameter instead. |
| See the <a href="https://ibps.readthedocs.io/en/latest/BloxOne/BloxOne%20Platform/Set-B1Host/">Documentation</a> for further details |
