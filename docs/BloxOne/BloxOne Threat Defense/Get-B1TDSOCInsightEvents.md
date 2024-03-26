---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDSOCInsightEvents

## SYNOPSIS
Queries a list of events related to a specific SOC Insight

## SYNTAX

```
Get-B1TDSOCInsightEvents [[-ThreatLevel] <String>] [[-ConfidenceLevel] <String>] [[-Query] <String>]
 [[-QueryType] <String>] [[-Source] <String>] [[-IP] <String>] [[-Indicator] <String>] [[-Limit] <String>]
 [[-Start] <DateTime>] [[-End] <DateTime>] [-insightId] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of events related to a specific SOC Insight

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightEvents | ft -AutoSize

confidenceLevel deviceName           macAddress        source           osVersion    action         policy                   deviceIp       query                                                                                                   queryType
--------------- ----------           ----------        ------           ---------    ------         ------                   --------       -----                                                                                                   ---------
High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 shrijyotishgurukulam.com                                                                                A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   80.187.83.226  shrijyotishgurukulam.com                                                                                A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   80.187.83.226  shrijyotishgurukulam.com                                                                                A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 652.0b47e9309fb5620e056948650f7555d2603ab1f3b003fa2c07ed52.dxkeu0.scrn.586a62459e.veryfastsecureweb.com SRV
High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 638.e23d3d370f0dfd11bed838eaa21a7f40dff881736ea3d693cd1d23.dxkeu0.scrn.586a62459e.youfastsecureweb.com  A
High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 640.ca7a785bcb1c518c35a3d4b6111111111111111111111111111111.dxkeu0.scrn.586a62459e.veryfastsecureweb.com CNAME
...
```

## PARAMETERS

### -ThreatLevel
{{ Fill ThreatLevel Description }}

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
{{ Fill ConfidenceLevel Description }}

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
{{ Fill Query Description }}

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
{{ Fill QueryType Description }}

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
{{ Fill Source Description }}

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
{{ Fill IP Description }}

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
{{ Fill Indicator Description }}

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
{{ Fill Limit Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
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
