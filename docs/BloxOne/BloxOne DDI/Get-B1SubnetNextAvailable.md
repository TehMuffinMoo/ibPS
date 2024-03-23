---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1SubnetNextAvailable

## SYNOPSIS
Gets one or more next available subnets from IPAM

## SYNTAX

### Default
```
Get-B1SubnetNextAvailable -CIDRSize <Int32> [-Count <Int32>] -ParentAddressBlock <String> -Space <String>
 [<CommonParameters>]
```

### ID
```
Get-B1SubnetNextAvailable -CIDRSize <Int32> [-Count <Int32>] -ID <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to get one or more next available subnets from IPAM based on the criteria entered

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1SubnetNextAvailable -ParentAddressBlock 10.0.0.0/16 -Space my-ipspace -CIDRSize 24 -Count 5 | ft address,cidr

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
Get-B1AddressBlock -Subnet 10.10.10.0/16 -Space my-ipspace | Get-B1SubnetNextAvailable -CIDRSize 24 -Count 5 | ft address,cidr

address  cidr
-------  ----
10.0.0.0   24
10.0.2.0   24
10.0.3.0   24
10.0.4.0   24
10.0.5.0   24
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
Use the -Space parameter to determine which IP Space the parent is located in

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
