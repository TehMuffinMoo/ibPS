---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AddressNextAvailable

## SYNOPSIS
Gets one or more next available IP addresses from IPAM

## SYNTAX

### Address Block
```
Get-B1AddressNextAvailable [-Count <Int32>] [-Contiguous] -ParentAddressBlock <String> -Space <String>
 [<CommonParameters>]
```

### Subnet
```
Get-B1AddressNextAvailable [-Count <Int32>] [-Contiguous] -ParentSubnet <String> -Space <String>
 [<CommonParameters>]
```

### ID
```
Get-B1AddressNextAvailable [-Count <Int32>] [-Contiguous] -ID <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to get one or more next available IP addresses from IPAM based on the criteria entered

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AddressBlockNextAvailable -ParentAddressBlock 10.0.0.0/16 -Space my-ipspace -CIDRSize 24 -Count 5 | ft address,cidr

address  cidr
-------  ----
10.0.0.0   24
10.0.2.0   24
10.0.3.0   24
10.0.4.0   24
10.0.5.0   24
```

### EXAMPLE 2
```powershell
Get-B1AddressBlock -Subnet 10.10.10.0/16 -Space my-ipspace | Get-B1AddressBlockNextAvailable -CIDRSize 29 -Count 2
```

## PARAMETERS

### -Count
The desired number of IP addresses to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Contiguous
Use the -Contiguous switch to indicate whether the IP addresses should belong to a contiguous block.
Default is false

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

### -ParentAddressBlock
Parent Address Block in CIDR format (i.e 10.0.0.0/8)

-ParentAddressBlock and -ParentSubnet are mutually exclusive parameters.

```yaml
Type: String
Parameter Sets: Address Block
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentSubnet
Parent Subnet in CIDR format (i.e 10.0.0.0/8)

-ParentSubnet and -ParentAddressBlock are mutually exclusive parameters.

```yaml
Type: String
Parameter Sets: Subnet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
Use the -Space parameter to determine which IP Space the parent Subnet or Address Block is in

```yaml
Type: String
Parameter Sets: Address Block, Subnet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
{{ Fill ID Description }}

```yaml
Type: String[]
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
