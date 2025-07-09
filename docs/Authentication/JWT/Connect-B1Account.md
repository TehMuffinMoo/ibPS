---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Connect-B1Account

## SYNOPSIS
Connects to the Infoblox Portal and retrieves an interactive JWT session token, enabling the use of account switching.

## SYNTAX

```
Connect-B1Account [-Email] <String> [-Password] <String> [<CommonParameters>]
```

## DESCRIPTION
Connects to the Infoblox Portal and retrieves an interactive JWT session token, enabling the use of account switching.

In most cases, I would recommend using API Keys as they remain persistent for the length of the key's lifetime, and do not require re-authentication.

However, in cases such as automating the creation of Sandboxes; you will not have received an API Key for the sandbox account yet.
Using a JWT session token with this function will enable you to switch into the Sandbox account(s) and perform the necessary operations and optionally create persistent API Key(s).

When connected to the Infoblox Portal using this function, it will override any active connection profile configured in Get-B1ConnectionProfile for the duration of the session.
You can disconnect from the Infoblox Portal using Disconnect-B1Account, which will restore the previous connection profile.

## EXAMPLES

### EXAMPLE 1
```powershell
Connect-B1Account -Email "my.name@domain.com" -Password "mySuperSecurePassword"

Successfully connected to BloxOne account.
```

## PARAMETERS

### -Email
The email address of the Infoblox Portal account to use when connecting.

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

### -Password
The password of the Infoblox Portal account to use when connecting.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
