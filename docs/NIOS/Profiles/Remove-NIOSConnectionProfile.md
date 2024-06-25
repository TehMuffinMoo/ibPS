---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-NIOSConnectionProfile

## SYNOPSIS
This function is used to remove a saved connection profile.

## SYNTAX

```
Remove-NIOSConnectionProfile [-Name] <String> [[-Confirm] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids.
A list of connection profiles can be retrieved using \[Get-NIOSConnectionProfile\](https://ibps.readthedocs.io/en/latest/NIOS/Profiles/Get-NIOSConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-NIOSConnectionProfile Corp-GM

WARNING: Are you sure you want to delete the connection profile: Corp-GM?

Confirm
Continue with this operation?
[Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"): y

Removed connection profile: Corp-GM
```

### EXAMPLE 2
```powershell
Remove-NCP Corp-GM -Confirm:$false

Removed connection profile: Corp-GM
```

## PARAMETERS

### -Name
Specify the connection profile name to remove.
This field supports tab completion.

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
