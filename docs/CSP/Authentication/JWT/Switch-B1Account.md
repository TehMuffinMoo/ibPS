---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Switch-B1Account

## SYNOPSIS
Switches an interactive JWT session token to a different Infoblox Portal account.

## SYNTAX

### name
```
Switch-B1Account -Name <String> [<CommonParameters>]
```

### id
```
Switch-B1Account -id <String> [<CommonParameters>]
```

## DESCRIPTION
Switches an interactive JWT session token to a different Infoblox Portal account.
This can be used to switch into the context of Sandboxes/Subtenants using the parent account's JWT session token.

This only works when connected to the Infoblox Portal using Connect-B1Account and an Email / Password.
API Keys do not support account switching.

## EXAMPLES

### EXAMPLE 1
```powershell
Switch-B1Account -Name "Sandbox Account"

Successfully switched to Sandbox Account using: my.name@email.com.
```

## PARAMETERS

### -Name
The name of the Infoblox Portal account to switch to.
This is the name as displayed in the Infoblox Portal.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The ID of the Infoblox Portal account to switch to.
This is the unique identifier for the account, which can be obtained by using Get-B1CSPCurrentUser -Accounts.

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: True
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
