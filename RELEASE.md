- Add new `Get-NetworkTopology` function to provide either a text or HTML based visual topology of an IP Space, Address Block, Subnet or Range.
- Add `-Recurse` option to `Get-B1IPAMChild` to optionally retrieve recursive child objects and append to a new "Children" value
- Add `-Cleanup` parameter to `Get-ibPSVersion` to optionally cleanup old versions still lingering around. Best to run as Administrator.
- Add the ability to enter more than one `-Type` when using `Get-B1IPAMChild`
- Add `-AccountSpecific` parameter to `Get-B1LookalikeTargetCandidates`
- Add new `Get-B1InternalDomainList` function
- Add `-Offset` parameter to `Get-B1ServiceLog` & `Get-B1Service`
- Add `-tfilter` parameter to `Get-B1DNSACL`, ,`Get-B1SecurityPolicy` & `Get-B1ThreatFeeds`
- Add `-Fields` parameter to `Get-B1SecurityPolicy`,`Get-B1ThreatFeeds` & `Get-B1LookalikeTargetSummary`
- Add `-Limit` & `-Offset` parameters to the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Get-B1Tag`               | `Get-B1AuthoritativeNSG`  | `Get-B1DFP`               |
| `Get-B1DHCPOptionCode`    | `Get-B1DHCPOptionGroup`   | `Get-B1DHCPOptionSpace`   |
| `Get-B1DNSACL`            | `Get-B1PoPRegion`         | `Get-B1SecurityPolicy`    |
| `Get-B1ThreatFeeds`       |                           |                           |

- Add `-OrderBy` parameter to the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Get-B1APIKey`            | `Get-B1DNSACL`            | `Get-B1Service`           |
| `Get-B1AuditLog`          | `Get-B1DNSConfigProfile`  | `Get-B1Host`              | 
| `Get-B1User`              | `Get-B1DNSHost`           | `Get-B1BootstrapConfig`   |
| `Get-B1Address`           | `Get-B1DNSView`           | `Get-B1DHCPOptionSpace`   |
| `Get-B1AddressBlock`      | `Get-B1FixedAddress`      | `Get-B1ZoneChild`         |
| `Get-B1AuthoritativeNSG`  | `Get-B1ForwardNSG`        | `Get-B1DHCPOptionGroup`   |
| `Get-B1AuthoritativeZone` | `Get-B1ForwardZone`       | `Get-B1Subnet`            |
| `Get-B1DelegatedZone`     | `Get-B1HAGroup`           | `Get-B1DHCPOptionCode`    |
| `Get-B1DHCPConfigProfile` | `Get-B1IPAMChild`         | `Get-B1Space`             |
| `Get-B1DHCPHardwareFilter`| `Get-B1Range`             | `Get-B1DHCPLease`         |
| `Get-B1DHCPHost`          | `Get-B1Record`            |

- Add `-OrderByTag` parameter to the following functions

|                           |                           |                           |
|:--------------------------|:--------------------------|:--------------------------|
| `Get-B1Address`           | `Get-B1AddressBlock`      | `Get-B1AuthoritativeNSG`  |
| `Get-B1AuthoritativeZone` | `Get-B1DelegatedZone`     | `Get-B1DFP`               | 
| `Get-B1DHCPConfigProfile` | `Get-B1DHCPHardwareFilter`| `Get-B1DHCPHost`          |
| `Get-B1DNSACL`            | `Get-B1DNSConfigProfile`  | `Get-B1DNSHost`           |
| `Get-B1DNSView`           | `Get-B1FixedAddress`      | `Get-B1ForwardNSG`        |
| `Get-B1ForwardZone`       | `Get-B1HAGroup`           | `Get-B1IPAMChild`         |
| `Get-B1Range`             | `Get-B1Space`             | `Get-B1Subnet`            |
| `Get-B1ZoneChild`         | `Get-B1Host`              | `Get-B1Service`           |
| `Get-B1InternalDomainList`|                           |                           |
