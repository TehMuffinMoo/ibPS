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

```
Get-B1AddressBlockNextAvailable [-ParentAddressBlock] <String> [-Space] <String> [-SubnetCIDRSize] <Int32>
 [[-SubnetCount] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to get one or more next available address blocks from IPAM based on the criteria entered

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AddressBlockNextAvailable -ParentAddressBlock 10.0.0.0/16 -Space mcox-ipspace -SubnetCIDRSize 24 -SubnetCount 5 | ft address,cidr

address  cidr
-------  ----
10.0.0.0   24
10.0.2.0   24
10.0.3.0   24
10.0.4.0   24
10.0.5.0   24
```

## PARAMETERS

### -ParentAddressBlock
Parent Address Block in CIDR format (i.e 10.0.0.0/8)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
Use this parameter to filter the list of Address Blocks by Space

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubnetCIDRSize
The size of the desired subnet specified using CIDR suffix

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubnetCount
The desired number of subnets to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
