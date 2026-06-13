---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1ConnectionProfile

## SYNOPSIS
This function is used to update existing connection profiles.

## SYNTAX

### Region
```
Set-B1ConnectionProfile -Name <String> -CSPRegion <String> -APIKey <String> [-NoSwitchProfile] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URL
```
Set-B1ConnectionProfile -Name <String> -CSPUrl <String> -APIKey <String> [-NoSwitchProfile] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Portal Accounts.
These can then easily be switched between by using \[Switch-B1ConnectionProfile\](https://ibps.readthedocs.io/en/latest/CSP/Profiles/Switch-B1ConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
Set-BCP -Name 'Dev' -CSPRegion 'US' -APIKey 'MyNewAPIKey'
```

### EXAMPLE 2
```powershell
Set-B1ConnectionProfile -Name 'Dev' -CSPRegion 'US' -APIKey 'MyNewAPIKey'
```

## PARAMETERS

### -Name
Specify the name of the connection profile to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CSPRegion
Optionally configure the the CSP Region to use (i.e EU for the EMEA instance).
You only need to use -CSPRegion OR -CSPUrl.

```yaml
Type: String
Parameter Sets: Region
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CSPUrl
Optionally configure the the CSP URL to use manually.
You only need to use -CSPUrl OR -CSPRegion.

```yaml
Type: String
Parameter Sets: URL
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIKey
Specify the Infoblox Portal API Key to update as part of this profile

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoSwitchProfile
{{ Fill NoSwitchProfile Description }}

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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
