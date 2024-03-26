---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDSOCInsightComments

## SYNOPSIS
Queries a list of comments related to a specific SOC Insight

## SYNTAX

```
Get-B1TDSOCInsightComments [[-Start] <DateTime>] [[-End] <DateTime>] [-insightId] <String[]>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of comments related to a specific SOC Insight

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightComments
```

## PARAMETERS

### -Start
Filter comments which were added after the -Start date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
Filter comments which were added before the -End date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -insightId
The insightId of the Insight to retrieve impacted comments for. 
Accepts pipeline input (See examples)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
