- Fix invalid error returned when using `Set-B1Host`
- Add new `Set-B1Service` function [#211](https://github.com/TehMuffinMoo/ibPS/issues/211)
- Add aliases for Host functions

|      Function     |       Alias       |
|:------------------|:------------------|
| `Get-B1Host`      | `Get-B1Server`    |
| `Set-B1Host`      | `Set-B1Server`    |
| `New-B1Host`      | `New-B1Server`    |
| `Remove-B1Host`   | `Remove-B1Server` |
| `Restart-B1Host`  | `Restart-B1Server`|

- Add various functions to begin aligning with the new IPAM model
- Add `Get-B1FederatedRealm`, `New-B1FederatedRealm` & `Remove-B1FederatedRealm`
- Add `Get-B1FederatedPool`, `New-B1FederatedPool` & `Remove-B1FederatedPool`
- Add `Get-B1FederatedBlock`, `New-B1FederatedBlock` (Awaiting backend fixes)
- Add `Get-B1ForwardLookingDelegation` 
- Add `Get-B1OverlappingBlock`
- Add `Get-B1ReservedBlock`
- Add `Get-B1Delegation`
- Fix bug with `Get-B1ZoneChild` and add `-RecordType` filter parameter
- Add `Update-B1AuthoritativeZoneSerial` to increment the SOA Serial Number of an Authoritative Zone by 1,000, or to a specific value.