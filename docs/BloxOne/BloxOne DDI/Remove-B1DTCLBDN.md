---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DTCLBDN

## SYNOPSIS
Removes an existing BloxOne DTC LBDN

## SYNTAX

### Default
```
Remove-B1DTCLBDN -Name <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Remove-B1DTCLBDN -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOne DTC LBDN

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DTCLBDN -Name "webmail.company.corp."

Successfully removed DTC LBDN: webmail.company.corp.
```

### EXAMPLE 2
```powershell
Get-B1DTCLBDN -Name "webmail.company.corp"| Remove-B1DTCLBDN

Successfully removed DTC LBDN: Exchange-LBDN
```

## PARAMETERS

### -Name
The name of the DTC LBDN to remove (FQDN)

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
The DTC LBDN Object(s) to remove.
Accepts pipeline input.

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
