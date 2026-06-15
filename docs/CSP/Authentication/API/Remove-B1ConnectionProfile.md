---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1ConnectionProfile

## SYNOPSIS
This function is used to remove a saved Infoblox Cloud connection profile.

## SYNTAX

### Name
```
Remove-B1ConnectionProfile -Name <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### All
```
Remove-B1ConnectionProfile [-All] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Cloud Accounts, with the ability to quickly switch between them.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1ConnectionProfile Dev

WARNING: Are you sure you want to delete the connection profile: Dev?

Confirm
Continue with this operation?
[Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"): y

Removed connection profile: Dev
```

### EXAMPLE 2
```powershell
Remove-BCP -All

Remove All Connection Profiles
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
Removed all connection profiles.
```

### EXAMPLE 3
```powershell
Remove-BCP Test -Confirm:$false

Removed connection profile: Test
```

## PARAMETERS

### -Name
Specify the connection profile name to remove.
This field supports tab completion.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Use this switch to remove all saved connection profiles, including the active connection profile.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
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
