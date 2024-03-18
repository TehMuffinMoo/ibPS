---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Get-NetworkInfo

## SYNOPSIS
Used to generate commonly used network information from a subnet

## SYNTAX

```
Get-NetworkInfo [-IP] <String> [[-MaskBits] <Int32>] [[-GatewayAddress] <Object>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
This function is used to generate commonly used network information from a subnet

This accepts pipeline input from Get-B1Subnet & Get-B1AddressBlock

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NetworkInfo 10.10.10.0/24          
                                                                                                                  
IPAddress        : 10.10.10.0
MaskBits         : 24
NetworkAddress   : 10.10.10.0
BroadcastAddress : 10.10.10.255
SubnetMask       : 255.255.255.0
NetworkClass     : A
Range            : 10.10.10.0 ~ 10.10.10.255
HostAddresses    : {10.10.10.1, 10.10.10.2, 10.10.10.3, 10.10.10.4…}
HostAddressCount : 254
```

### EXAMPLE 2
```powershell
Get-B1Subnet -Subnet 10.37.34.0 -CIDR 27 | Get-NetworkInfo
                                                                                                                  
IPAddress        : 10.37.34.0
MaskBits         : 27
NetworkAddress   : 10.37.34.0
BroadcastAddress : 10.37.34.31
SubnetMask       : 255.255.255.224
NetworkClass     : A
Range            : 10.37.34.0 ~ 10.37.34.31
HostAddresses    : {10.37.34.1, 10.37.34.2, 10.37.34.3, 10.37.34.4…}
HostAddressCount : 30
```

### EXAMPLE 3
```powershell
Get-B1AddressBlock -Limit 1 | Get-NetworkInfo                                                                                                                                                                 
                                                                                                                  
IPAddress        : 10.41.163.0
MaskBits         : 24
NetworkAddress   : 10.41.163.0
BroadcastAddress : 10.41.163.255
SubnetMask       : 255.255.255.0
NetworkClass     : A
Range            : 10.41.163.0 ~ 10.41.163.255
HostAddresses    : {10.41.163.1, 10.41.163.2, 10.41.163.3, 10.41.163.4…}
HostAddressCount : 254
```

## PARAMETERS

### -IP
The network IP of the subnet

This parameter is also aliased to -Address

```yaml
Type: String
Parameter Sets: (All)
Aliases: Address

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MaskBits
The Mask Bits / CIDR of the subnet

This parameter is also aliased to -CIDR

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: CIDR

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GatewayAddress
When using the -GatewayAddress parameter, an optional Gateway value will be added to the results.
Available options are First & Last.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Subnets larger than a /16 will take a longer time to generate the list of host addresses.
Using -Force will override this limit and generate them anyway.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1](https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1)

