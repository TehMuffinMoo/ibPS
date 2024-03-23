## Create IPAM Tree
This example shows how you can create a simple IPAM structure, incorporating an IP Space, Address Block, 10 Subnets & Tagging

```powershell
$IPSpace = "ibPS Space"         ## IP Space Name
$ParentSubnet = "10.10.0.0/20"  ## Parent Address Block Subnet in CIDR format
$ParentSubnetName = "Corporate" ## Parent Address Block Name
$ChildSubnetSize = 24           ## Child Subnet Size (CIDR Notation)
$ChildSubnetCount = 10          ## Number of child subnets
$Tags = @{                      ## A collection of tags to apply
    "OwnedBy" = "Me"
    "Location" = "The Moon"
}

## Create new IP Space
New-B1Space -Name $IPSpace -Description $IPSpace -Tags $Tags

## Create new parent address block
New-B1AddressBlock -Subnet $ParentSubnet.Split('/')[0] -CIDR $ParentSubnet.Split('/')[1] -Name $ParentSubnetName -Space $IPSpace -Tags $Tags

## Create Child Subnets
$NextAvailable = Get-B1AddressBlockNextAvailable -ParentAddressBlock $ParentSubnet -Space $IPSpace -Count $ChildSubnetCount -CIDRSize $ChildSubnetSize
foreach ($NextSN in $NextAvailable) {
    New-B1Subnet -Subnet $NextSN.address -CIDR $NextSN.cidr -Space $IPSpace -Tags $Tags
}
```