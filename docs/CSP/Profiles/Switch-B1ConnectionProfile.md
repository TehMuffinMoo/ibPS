---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Switch-B1ConnectionProfile

## SYNOPSIS
This function is used to switch between saved Infoblox Portalconnection profiles.

## SYNTAX

```
Switch-B1ConnectionProfile [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Portal Accounts, with the ability to quickly switch between them.

## EXAMPLES

### EXAMPLE 1
```powershell
Switch-NCP Dev

Dev has been set as the active connection profile.
```

### EXAMPLE 2
```powershell
Switch-B1ConnectionProfile Test

Test has been set as the active connection profile.
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
