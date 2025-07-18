---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TopMetrics

## SYNOPSIS
Retrieves top metrics from Universal DDI

## SYNTAX

### default (Default)
```
Get-B1TopMetrics [-TopCount <Int32>] [-Start <DateTime>] [-End <DateTime>] [<CommonParameters>]
```

### topQueries
```
Get-B1TopMetrics [-TopQueries] -QueryType <String> [-TopCount <Int32>] [-Start <DateTime>] [-End <DateTime>]
 [<CommonParameters>]
```

### topClients
```
Get-B1TopMetrics [-TopClients] [-TopClientLogType <String>] [-TopCount <Int32>] [-Start <DateTime>]
 [-End <DateTime>] [<CommonParameters>]
```

### topDNSServers
```
Get-B1TopMetrics [-TopDNSServers] [-Granularity <String>] [-TopCount <Int32>] [-Start <DateTime>]
 [-End <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve top metrics from Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TopMetrics -TopQueries DFP -TopCount 50 -Start (Get-Date).AddDays(-1)
```

### EXAMPLE 2
```powershell
Get-B1TopMetrics -TopDNSServers -Start (Get-Date).AddDays(-31)
```

## PARAMETERS

### -TopQueries
Use this parameter to select Top Queries as the top metric category

```yaml
Type: SwitchParameter
Parameter Sets: topQueries
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryType
Use this parameter to specify the query type when using -TopQueries

Available options: NXDOMAIN, NXRRSET, DNS & DFP

```yaml
Type: String
Parameter Sets: topQueries
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopClients
Use this parameter to select Top Clients as the top metric category

```yaml
Type: SwitchParameter
Parameter Sets: topClients
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopClientLogType
Use this parameter to specify the top client log type when using -TopClients

Available options: DNS, DFP & DHCP

```yaml
Type: String
Parameter Sets: topClients
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopDNSServers
Use this parameter to return a list of DNS Servers by query count

```yaml
Type: SwitchParameter
Parameter Sets: topDNSServers
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Granularity
Use this parameter to return results based on intervals instead of aggregated across the whole time period

Available options: Minute, Hour, Day, Week, Month & Year

```yaml
Type: String
Parameter Sets: topDNSServers
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopCount
Use this parameter to return X results for the top metric selected.
Default is 20.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
The start date/time for searching aggregated metrics.
Default is 1 day ago.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
The end date/time for searching aggregated metrics.
Default is now.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
