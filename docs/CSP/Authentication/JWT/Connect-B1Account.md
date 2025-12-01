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

### JWT
```
Connect-B1Account -Email <String> [-CSPRegion <String>] [-SecurePassword <SecureString>] [<CommonParameters>]
```

### API
```
Connect-B1Account [-APIKey] [-CSPRegion <String>] [-SecureAPIKey <SecureString>] [<CommonParameters>]
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

Successfully connected to MyAccount using: my.name@email.com.
```

## PARAMETERS

### -Email
The email address of the Infoblox Portal account to use when connecting.

```yaml
Type: String
Parameter Sets: JWT
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIKey
{{ Fill APIKey Description }}

```yaml
Type: SwitchParameter
Parameter Sets: API
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CSPRegion
{{ Fill CSPRegion Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: US
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePassword
The password of the Infoblox Portal account to use when connecting, in SecureString format.

```yaml
Type: SecureString
Parameter Sets: JWT
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecureAPIKey
{{ Fill SecureAPIKey Description }}

```yaml
Type: SecureString
Parameter Sets: API
Aliases:

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
