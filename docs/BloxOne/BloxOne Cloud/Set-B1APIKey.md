---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1APIKey

## SYNOPSIS
Updates an existing BloxOne Cloud API Key

## SYNTAX

### Default
```
Set-B1APIKey -Name <Object> [-User <Object>] [-Type <Object>] [-State <Object>] [<CommonParameters>]
```

### Object
```
Set-B1APIKey [-State <Object>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing API Key from the BloxOne Cloud, such as disabling/enabling it.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled
```

## PARAMETERS

### -Name
Filter the results by the name of the API Key

```yaml
Type: Object
Parameter Sets: Default
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
Parameter Sets: Default
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
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Toggle the state of the API Key

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The API Key Object.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
