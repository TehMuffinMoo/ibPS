---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1Subnet

## SYNOPSIS
Creates a new subnet in BloxOneDDI IPAM

## SYNTAX

```
New-B1Subnet [-Subnet] <String> [-CIDR] <Int32> [-Space] <String> [-Name] <String> [[-HAGroup] <Object>]
 [[-Description] <String>] [[-DHCPOptions] <Object>] [[-DDNSDomain] <String>] [[-Tags] <Object>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new subnet in BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1Subnet -Subnet "10.30.5.0" -CIDR "24" -Space "Global" -Name "My Subnet" -Description "My Production Subnet"
```

### EXAMPLE 2
```powershell
## Example showing building DHCP options using Get-B1DHCPOptionCode
$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

PS> New-B1Subnet -Subnet "10.30.5.0" -CIDR "24" -Space "Global" -Name "My Subnet" -Description "My Production Subnet" -DHCPOptions $DHCPOptions
```

## PARAMETERS

### -Subnet
The network address of the subnet you want to create

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

### -CIDR
The CIDR suffix of the subnet you want to create

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space for the subnet to be placed in

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the subnet you want to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HAGroup
The name of the HA group to apply to this subnet

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the subnet you want to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPOptions
A list of DHCP Options you want to apply to the new subnet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSDomain
The DDNS Domain to apply to the new subnet

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the subnet

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
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
