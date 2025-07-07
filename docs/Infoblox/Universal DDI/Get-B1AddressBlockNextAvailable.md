---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AddressBlockNextAvailable

## SYNOPSIS
Gets one or more next available address blocks from IPAM

## SYNTAX

### Default
```
Get-B1AddressBlockNextAvailable -CIDRSize <Int32> [-Count <Int32>] -ParentAddressBlock <String> -Space <String>
 [<CommonParameters>]
```

### ID
```
Get-B1AddressBlockNextAvailable -CIDRSize <Int32> [-Count <Int32>] -ID <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to get one or more next available address blocks from IPAM based on the criteria entered

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

### -CIDRSize
The size of the desired subnet specified using CIDR suffix

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
The desired number of subnets to return

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

### -ParentAddressBlock
Parent Address Block in CIDR format (i.e 10.0.0.0/8)

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
Use this parameter to filter the list of Address Blocks by Space

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The ID of the Parent Address Block.
This accepts pipeline input from Get-B1AddressBlock

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
