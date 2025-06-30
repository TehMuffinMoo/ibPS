## Remove one or more objects based on tag
This example shows how you can remove objects in bulk based on selected tag(s)

```powershell
$tfilter = '("Owner"=="Me")'

Get-B1Record -tfilter $tfilter | Remove-B1Record
Get-B1Range -tfilter $tfilter | Remove-B1Range
Get-B1Subnet -tfilter $tfilter | Remove-B1Subnet
Get-B1AddressBlock -tfilter $tfilter | Remove-B1AddressBlock
Get-B1DHCPConfigProfile -tfilter $tfilter | Remove-B1DHCPConfigProfile
Get-B1AuthoritativeZone -tfilter $tfilter | Remove-B1AuthoritativeZone
Get-B1DNSView -tfilter $tfilter | Remove-B1DNSView
Get-B1Space -tfilter $tfilter | Remove-B1Space
```