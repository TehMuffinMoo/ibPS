---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1APIKey

## SYNOPSIS
Creates a new BloxOne Cloud API Key

## SYNTAX

```
New-B1APIKey [[-Type] <String>] [-Name] <String> [[-Expires] <DateTime>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new API Key from the BloxOne Cloud.

## EXAMPLES

### EXAMPLE 1
```
New-B1APIKey -Name "somename" -Type Interactive
```

### EXAMPLE 2
```
New-B1APIKey -Name "serviceapikey" -Type Service -UserName "svc-account-name"
```

## PARAMETERS

### -Type
The type of API Key to create.
Interactive will create a user API Key assigned to your user.
Service will create a service API Key assigned to the selected service user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name for the new API Key

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

### -Expires
The date/time when the key will expire

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Get-Date).AddYears(1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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
