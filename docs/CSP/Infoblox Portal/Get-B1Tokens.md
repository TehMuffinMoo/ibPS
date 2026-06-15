---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Tokens

## SYNOPSIS
Provides a summary of token utilization

## SYNTAX

```
Get-B1Tokens [-Bucket] <String> [[-Granularity] <String>] [[-Start] <DateTime>] [[-End] <DateTime>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to provide a summary of token utilization

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Tokens -Bucket Management
```

## PARAMETERS

### -Bucket
Management, Server or Reporting

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

### -Granularity
The grouping granularity of the data to retrieve.
Valid values are: second, minute, hour, day, week, month, quarter, year

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Now
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
The start date/time for the data to retrieve.
If not specified, defaults to 1 month ago.
The date/time must be in UTC format.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
The end date/time for the data to retrieve.
If not specified, defaults to now.
The date/time must be in UTC format.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
