---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1Subnet

## SYNOPSIS
Removes a subnet from Universal DDI IPAM

## SYNTAX

### Default
```
Remove-B1Subnet -Subnet <String> -CIDR <Int32> [-Name <String>] -Space <String> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
Remove-B1Subnet [-Name <String>] -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a subnet from Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global"
```

### EXAMPLE 2
```powershell
Get-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global" | Remove-B1Subnet
```

## PARAMETERS

### -Subnet
The network address of the subnet you want to remove

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

### -CIDR
The CIDR suffix of the subnet you want to remove

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the subnet to remove

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the subnet is located

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

### -Object
The subnet object to remove.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Perform the operation without prompting for confirmation.
By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

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
