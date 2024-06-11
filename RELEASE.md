- Add `Get-B1Compartment` function
- Add support for configuring Compartments when using `New-B1AddressBlock`, `Set-B1AddressBlock`, `New-B1AuthoritativeZone` & `Set-B1AuthoritativeZone`
- Add/Align `-CustomFilters` support to:

|                            |                            |                            |
|:---------------------------|:---------------------------|:---------------------------|
| `Get-B1AuthoriativeNSG`    | `Get-B1AuthoriativeZone`   | `Get-B1CloudProvider`      |
| `Get-B1DelegatedZone`      | `Get-B1DFP`                | `Get-B1DHCPConfigProfile`  |
| `Get-B1DHCPHardwareFilter` | `Get-B1DHCPHost`           | `Get-B1DHCPLease`          |
| `Get-B1DHCPOptionCode`     | `Get-B1DHCPOptionGroup`    | `Get-B1DHCPOptionSpace`    |
| `Get-B1DNSACL`             | `Get-B1DNSConfigProfile`   | `Get-B1DNSHost`            |
| `Get-B1DNSView`            | `Get-B1DTCHealthCheck`     | `Get-B1DTCLBDN`            |
| `Get-B1DTCPolicy`          | `Get-B1DTCPool`            | `Get-B1DTCServer`          |
| `Get-B1FixedAddress`       | `Get-B1ForwardNSG`         | `Get-B1ForwardZone`        |
| `Get-B1HAGroup`            | `Get-B1Range`              | `Get-B1Record`             |
| `Get-B1Space`              | `Get-B1Subnet`             | `Get-B1Address`            |
| `Get-B1AddressBlock`       | `Get-B1AuditLog`           | `Get-B1APIKey`             |
| `Get-B1DNSEvent`           | `Get-B1Location`           | `Get-B1SecurityLog`        |
| `Get-B1Tag`                | `Get-B1User`               | `Get-B1UserAPIKey`         |
| `Get-B1Host`               | `Get-B1Service`            | `Get-B1ApplicationFilter`  |
| `Get-B1BypassCode`         | `Get-B1CategoryFilter`     | `Get-B1CustomList`         |
| `Get-B1InternalDomainList` | `Get-B1LookalikeDomains`   | `Get-B1Lookalikes`         |
| `Get-B1NetworkList`        | `Get-B1PoPRegion`          | `Get-B1SecurityPolicy`     |
| `Get-B1SecurityPolicyRules`| `Get-B1ThirdPartyProvider` |                            |