---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1AddressBlock

## SYNOPSIS
Creates a new address block in Universal DDI IPAM

## SYNTAX

```
New-B1AddressBlock [-Subnet] <String> [-CIDR] <Int32> [-Space] <String> [-Name] <String>
 [[-Description] <String>] [[-DHCPOptions] <Object>] [[-DDNSDomain] <String>] [[-Compartment] <String>]
 [[-Tags] <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new address block in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
##Example usage when combined with Get-B1DHCPOptionCode
$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

PS> New-B1AddressBlock -Subnet "10.30.0.0" -CIDR "20" -Space "Global" -Name "My Subnet" -Description "My Production Subnet" -DHCPOptions $DHCPOptions
```

## PARAMETERS

### -Subnet
The network address of the address block you want to create

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
The CIDR suffix of the address block you want to create

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
The IPAM space for the address block to be placed in

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
The name of the address block you want to create

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

### -Description
The description of the address block you want to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPOptions
A list of DHCP Options you want to apply to the new address block.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSDomain
The DDNS Domain to apply to the new address block

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compartment
The name of the compartment to assign to this address block

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
Any tags you want to apply to the address block

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
