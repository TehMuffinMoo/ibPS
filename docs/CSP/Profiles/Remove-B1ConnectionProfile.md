---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1ConnectionProfile

## SYNOPSIS
This function is used to remove a saved Infoblox Portalconnection profile.

## SYNTAX

```
Remove-B1ConnectionProfile [-Name] <String> [[-Confirm] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Portal Accounts, with the ability to quickly switch between them.
A list of connection profiles can be retrieved using [`Get-B1ConnectionProfile`](../Get-B1ConnectionProfile/).

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
Remove-BCP Test -Confirm:$false

Removed connection profile: Test
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
