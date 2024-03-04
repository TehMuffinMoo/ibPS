---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Start-B1TDDossierBatchLookup

## SYNOPSIS
Perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

## SYNTAX

```
Start-B1TDDossierBatchLookup [-Type] <String> [-Target] <String[]> [-Source] <String[]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

## EXAMPLES

### EXAMPLE 1
```
Start-B1TDDossierBatchLookup -Type ip -Target "1.1.1.1","1.0.0.1" -Source "apt","mandiant"
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

### -Target
{{ Fill Target Description }}

```yaml
Type: String[]
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
Multiple sources can be specified.
A list of supported sources can be obtained by using the Get-B1TDDossierSupportedSources cmdlet

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
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
