---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1TDSOCInsight

## SYNOPSIS
Updates the status of an Insight from SOC Insights

## SYNTAX

```
Set-B1TDSOCInsight [-Status] <String> [[-Comment] <String>] [-insightId] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update the status of an Insight from SOC Insights

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSOCInsight -ThreatType 'Lookalike Threat' -Priority LOW | Set-B1TDSOCInsight -Status Closed
```

## PARAMETERS

### -Status
Which status the Insight should be updated to (Active/Closed)

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

### -Comment
Optionally add a comment to be added to the Insight

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -insightId
The insightId of the Insight to update.
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
