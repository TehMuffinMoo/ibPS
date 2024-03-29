---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ServiceLog

## SYNOPSIS
Queries the BloxOneDDI Service Log

## SYNTAX

```
Get-B1ServiceLog [[-B1Host] <String>] [[-Container] <String>] [[-Start] <DateTime>] [[-End] <DateTime>]
 [[-Limit] <Int32>] [[-Offset] <Int32>]
```

## DESCRIPTION
This function is used to query the BloxOneDDI Service Log.
This log contains information from all containers on all BloxOneDDI Hosts, allowing you to query various types of diagnostic related data.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1ServiceLog -B1Host "bloxoneddihost1.mydomain.corp" -Container "DNS" -Start (Get-Date).AddHours(-2)
```

## PARAMETERS

### -B1Host
Use this parameter to filter the log for events relating to a specific BloxOneDDI Host

```yaml
Type: String
Parameter Sets: (All)
Aliases: OnPremHost

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Container
A pre-defined list of known containers to filter against.

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

### -Start
A date parameter used as the starting date/time of the log search.
By default, the search will start from 24hrs ago and returns the latest results first.
You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
A date parameter used as the end date/time of the log search.

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
