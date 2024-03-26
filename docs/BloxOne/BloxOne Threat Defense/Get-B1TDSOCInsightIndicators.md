---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDSOCInsightIndicators

## SYNOPSIS
Queries a list of indicators related to a specific SOC Insight

## SYNTAX

```
Get-B1TDSOCInsightIndicators [[-Confidence] <String>] [[-Indicator] <String>] [[-Action] <String>]
 [[-Actor] <String>] [[-Limit] <String>] [[-Start] <DateTime>] [[-End] <DateTime>] [-insightId] <String[]>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of indicators related to a specific SOC Insight

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightIndicators | ft -AutoSize

action      confidence count threatLevelMax indicator                                    timeMax              timeMin
------      ---------- ----- -------------- ---------                                    -------              -------
Blocked     3              3 3              gsgedgbdf.com                     3/26/2024 8:00:00AM  3/26/2024 8:00:00AM
Blocked     3            270 2              gfsdfg.scrn.twgfdgfdrt.veryfastsecureweb.com 3/26/2024 1:00:00PM  3/26/2024 1:00:00PM
Blocked     3            319 2              gddg43.scrn.gergdrgxd†.youfastsecureweb.com  3/26/2024 1:00:00PM  3/26/2024 1:00:00PM
Blocked     3             17 2              scrn.dgrdegrdf.veryfastsecureweb.com         3/26/2024 1:00:00PM  3/26/2024 1:00:00PM
...
```

## PARAMETERS

### -Confidence
{{ Fill Confidence Description }}

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

### -Indicator
{{ Fill Indicator Description }}

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

### -Action
{{ Fill Action Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Actor
{{ Fill Actor Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
{{ Fill Limit Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
Filter indicators which were added after the -Start date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
Filter indicators which were added before the -End date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -insightId
The insightId of the Insight to retrieve impacted indicators for. 
Accepts pipeline input (See examples)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
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
