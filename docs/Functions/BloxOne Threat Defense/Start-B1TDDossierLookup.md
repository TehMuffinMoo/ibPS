---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Start-B1TDDossierLookup

## SYNOPSIS
Performs a single lookup against the BloxOne Threat Defense Dossier

## SYNTAX

```
Start-B1TDDossierLookup [-Type] <String> [-Value] <String> [[-Source] <String[]>] [-Wait] [<CommonParameters>]
```

## DESCRIPTION
This function is used to perform a single lookup against the BloxOne Threat Defense Dossier

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1TDDossierLookup -Type ip -Value 1.1.1.1
```

### EXAMPLE 2
```powershell
Start-B1TDDossierLookup -Type host -Value eicar.co
```

## PARAMETERS

### -Type
The indicator type to search on

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

### -Value
The indicator value to search on

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

### -Source
The sources to query.
Multiple sources can be specified, if no source is specified, the call will search on all available sources.
A list of supported sources can be obtained by using the Get-B1TDDossierSupportedSources cmdlet

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
If this switch is set, the API call will wait for job completion before returning

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
