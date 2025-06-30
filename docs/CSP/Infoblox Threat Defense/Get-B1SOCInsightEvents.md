---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1SOCInsightEvents

## SYNOPSIS
Queries a list of events related to a specific SOC Insight

## SYNTAX

```
Get-B1SOCInsightEvents [[-ThreatLevel] <String>] [[-ConfidenceLevel] <String>] [[-Query] <String>]
 [[-QueryType] <String>] [[-Source] <String>] [[-IP] <String>] [[-Indicator] <String>] [[-Limit] <Int32>]
 [[-Start] <DateTime>] [[-End] <DateTime>] [-insightId] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of events related to a specific SOC Insight

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1SOCInsight -Priority CRITICAL | Get-B1SOCInsightEvents | ft -AutoSize

confidenceLevel deviceName           macAddress        source                   osVersion    action         policy                   deviceIp       query                                                                                                   queryType
--------------- ----------           ----------        ------                   ---------    ------         ------                   --------       -----                                                                                                   ---------
High            CORP-C123F987AB      ab:cd:ef:12:34:56 Threat Defense Endpoint  macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 gdgdxsrgbxdfbgcxv.com                                                                                   A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 Threat Defense Endpoint  macOS 14.2.1 Block          Global_Security_Policy   80.153.81.224  fsfsef4wetrfeswg.com                                                                                    A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 Threat Defense Endpoint  macOS 14.2.1 Block          Global_Security_Policy   80.153.81.224  fsfsef4wetrfeswg.com                                                                                    A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 Threat Defense Endpoint  macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 vvv.fsgfsdxvxgddbn.vxgvr.xvfd.xvdxsv.dodgywebsite.com                                                   SRV
High            CORP-C123F987AB      ab:cd:ef:12:34:56 Threat Defense Endpoint  macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 vvv.fsgfsdxvxgddbn.vxgvr.xvfd.xvdxsv.dodgywebsite.com                                                   A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 Threat Defense Endpoint  macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 vvv.fsgfsdxvxgddbn.vxgvr.xvfd.xvdxsv.dodgywebsite.com                                                   CNAME
...
```

## PARAMETERS

### -ThreatLevel
Filter events by Threat Level

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

### -ConfidenceLevel
Filter events by Confidence Level

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

### -Query
Filter events by DNS Query

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

### -QueryType
Filter events by DNS Query Type

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

### -Source
Filter events by Network Source (i.e Threat Defense Endpoint or specific DNS Forwarding Proxies)

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

### -IP
Filter events by the Source IP

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Indicator
Filter events by the indicator

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Set the limit for the quantity of event results (defaults to 100)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
Filter events which were added after the -Start date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
Filter events which were added before the -End date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -insightId
The insightId of the Insight to retrieve impacted events for. 
Accepts pipeline input (See examples)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
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
