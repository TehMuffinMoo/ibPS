---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1Range

## SYNOPSIS
Removes a DHCP Range from Universal DDI

## SYNTAX

### Default
```
Remove-B1Range -StartAddress <String> -EndAddress <String> -Space <String> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
Remove-B1Range -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DHCP Range from Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1Range -StartAddress "10.250.20.20" -EndAddress "10.250.20.100" -Space "Global"
```

## PARAMETERS

### -StartAddress
The start address of the DHCP Range

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

### -EndAddress
The end address of the DHCP Range

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

### -Object
The range object to remove.
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
