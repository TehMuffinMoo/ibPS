---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1NetworkList

## SYNOPSIS
Removes a network list from Infoblox Threat Defense

## SYNTAX

### Default (Default)
```
Remove-B1NetworkList [-Name <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Pipeline
```
Remove-B1NetworkList -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a network list from Infoblox Threat Defense

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1NetworkList -Name "My Network List"
```

### EXAMPLE 2
```powershell
Get-B1NetworkList -Name "My Network List" | Remove-B1NetworkList
```

## PARAMETERS

### -Name
The name of the network list to remove

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The network list object(s) to remove.
Accepts pipeline input.

```yaml
Type: Object
Parameter Sets: Pipeline
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
