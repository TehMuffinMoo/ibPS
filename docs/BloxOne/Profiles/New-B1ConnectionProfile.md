---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1ConnectionProfile

## SYNOPSIS
This function is used to create new BloxOne connection profiles.
By default, the new profile will be set as active.

## SYNTAX

### Region
```
New-B1ConnectionProfile -Name <String> -CSPRegion <String> -APIKey <String> [-NoSwitchProfile]
 [<CommonParameters>]
```

### URL
```
New-B1ConnectionProfile -Name <String> -CSPUrl <String> -APIKey <String> [-NoSwitchProfile]
 [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving API Keys for multiple BloxOne Accounts.
These can then easily be switched between by using [Switch-B1ConnectionProfile](https://ibps.readthedocs.io/en/latest/BloxOne/Profiles/Switch-B1ConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
New-BCP
```

### EXAMPLE 2
```powershell
New-B1ConnectionProfile
```

## PARAMETERS

### -Name
Specify the name for the new connection profile

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
Specify the BloxOne API Key to save as part of this profile

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
Do not make this profile active upon creation

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
