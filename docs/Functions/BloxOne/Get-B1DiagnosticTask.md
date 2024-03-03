---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DiagnosticTask

## SYNOPSIS
Query a list of BloxOneDDI Diagnostic Tasks

## SYNTAX

```
Get-B1DiagnosticTask [-id] <String> [-download] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of BloxOneDDI Diagnostic Tasks

## EXAMPLES

### EXAMPLE 1
```
Get-B1DiagnosticTask -id diagnostic/task/abcde634-2113-ddef-4d05-d35ffs1sa4 -download
```

## PARAMETERS

### -id
The id of the diagnostic task to filter by

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

### -download
This switch indicates if to download the results returned

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
