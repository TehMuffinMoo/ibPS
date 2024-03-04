---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1APIKey

## SYNOPSIS
Removes a BloxOne Cloud API Key

## SYNTAX

### noID
```
Remove-B1APIKey -Name <Object> [-User <Object>] [-Type <Object>] [-State <Object>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ID
```
Remove-B1APIKey -id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an API Key from the BloxOne Cloud
The API Key must be disabled prior to deleting

## EXAMPLES

### EXAMPLE 1
```
Remove-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled
```

### EXAMPLE 2
```
Get-B1APIKey -Name "MyAPIKey" | Set-B1APIKey -State Disabled | Remove-B1APIKey
```

## PARAMETERS

### -Name
Filter the results by the name of the API Key

```yaml
Type: Object
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
Filter the results by user_email

```yaml
Type: Object
Parameter Sets: noID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Filter the results by the API Key Type

```yaml
Type: Object
Parameter Sets: noID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Filter the results by the state of the API Key

```yaml
Type: Object
Parameter Sets: noID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the API Key.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
