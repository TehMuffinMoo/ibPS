---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Search-B1

## SYNOPSIS
Query the Universal DDI CSP Global Search

## SYNTAX

```
Search-B1 [-Query] <String> [-IncludeQueryDetails] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query the Universal DDI CSP Global Search

## EXAMPLES

### EXAMPLE 1
```powershell
Search-B1 "10.10.100.1"
```

### EXAMPLE 2
```powershell
Search-B1 "mysubzone.corp.com"
```

## PARAMETERS

### -Query
Search query

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

### -IncludeQueryDetails
Use this parameter to include the query shard, aggregation, state, and duration data.
By default, the hits property is auto-expanded

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
