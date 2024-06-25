---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Switch-NIOSConnectionProfile

## SYNOPSIS
This function is used to switch between saved connection profiles.

## SYNTAX

```
Switch-NIOSConnectionProfile [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids, with the ability to quickly switch between them.

New connection profiles can be created using [`New-NIOSConnectionProfile`](../New-NIOSConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
Switch-NCP Corp-GM

Corp-GM has been set as the active connection profile.
```

### EXAMPLE 2
```powershell
Switch-NIOSConnectionProfile BloxOne-GM

BloxOne-GM has been set as the active connection profile.
```

## PARAMETERS

### -Name
Specify the connection profile name to switch to.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
