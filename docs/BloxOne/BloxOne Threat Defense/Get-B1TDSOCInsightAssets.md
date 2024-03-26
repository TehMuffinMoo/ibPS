---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDSOCInsightAssets

## SYNOPSIS
Queries a list of assets related to a specific SOC Insight

## SYNTAX

```
Get-B1TDSOCInsightAssets [[-IP] <IPAddress>] [[-MACAddress] <String>] [[-OSVersion] <String>]
 [[-Start] <DateTime>] [[-End] <DateTime>] [[-User] <String>] [[-Limit] <Int32>] [-insightId] <String[]>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of assets related to a specific SOC Insight

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightAssets
```

## PARAMETERS

### -IP
Filter the asset results by source IP

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MACAddress
Filter the asset results by source MAC address

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

### -OSVersion
Filter the asset results by the detected source OS Version

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

### -Start
Filter the asset results by observed start time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
Filter the asset results by observed end time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
Filter the asset results by associated user

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

### -Limit
Limit the number of results

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -insightId
The insightId of the Insight to retrieve impacted assets for. 
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
