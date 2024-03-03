---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1CSPAPIKey

## SYNOPSIS
Stores a new BloxOneDDI API Key

## SYNTAX

```
Set-B1CSPAPIKey [-APIKey] <String> [-Persist] [<CommonParameters>]
```

## DESCRIPTION
This function will store a new BloxOneDDI API Key for the current user on the local machine.
If a previous API Key exists, it will be overwritten.

## EXAMPLES

### EXAMPLE 1
```
Set-B1CSPAPIKey -APIKey "mylongapikeyfromcsp" -Persist
```

## PARAMETERS

### -APIKey
This is the BloxOneDDI API Key retrieves from the Cloud Services Portal

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

### -Persist
Using the -Persist switch will save the API Key across powershell sessions.
Without using this switch, the API Key will only be stored for the current powershell session.

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
