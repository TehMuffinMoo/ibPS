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
Get-B1Subnet -Subnet 10.37.34.0/24 | Get-B1AddressNextAvailable -Count 10 -Contiguous | ft address

address
    -------
    10.37.34.16
    10.37.34.17
    10.37.34.18
    10.37.34.19
    10.37.34.20
    10.37.34.21
    10.37.34.22
    10.37.34.23
    10.37.34.24
    10.37.34.25
```

### EXAMPLE 2
```powershell
Get-B1AddressBlock -Subnet 10.57.124.0/24 | Get-B1AddressNextAvailable -Count 5 -Contiguous | ft address

address
    -------
    10.57.124.83
    10.57.124.84
    10.57.124.85
    10.57.124.86
    10.57.124.87
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
The ID of the Subnet or Address Block.
This accepts pipeline input from Get-B1AddressBlock & Get-B1Subnet

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
