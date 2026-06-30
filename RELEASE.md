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

- Add `Get-B1FederatedRealm`, `Get-B1FederatedPool`, `Get-B1FederatedBlock`, `Get-B1ForwardLookingDelegation`, `Get-B1OverlappingBlock`, `Get-B1ReservedBlock` & `Get-B1Delegation` functions to begin aligning with the new IPAM model