---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1SOCInsightAssets

## SYNOPSIS
Queries a list of assets related to a specific SOC Insight

## SYNTAX

```
Get-B1SOCInsightAssets [[-IP] <IPAddress>] [[-MACAddress] <String>] [[-OSVersion] <String>]
 [[-Start] <DateTime>] [[-End] <DateTime>] [[-User] <String>] [[-Limit] <Int32>] [-insightId] <String[]>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of assets related to a specific SOC Insight

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1SOCInsight -Priority CRITICAL | Get-B1SOCInsightAssets | Sort-Object threatIndicatorDistinctCount -Descending | ft -AutoSize

cid                                                               cmac              count qip             location                   osVersion      threatLevelMax threatIndicatorDistinctCount timeMax              timeMin
---                                                               ----              ----- ---             --------                   ---------      -------------- ---------------------------- -------              -------
cscuygwfybfsebfy4b4hf34h798fsbew:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l ab:cd:ef:12:34:56  4845 81.42.14.78     Alcalá de Henares,Spain    macOS 14.2.1   3              9                            3/1/2024 9:00:00AM   2/29/2024 7:00:00PM
fsdfnje98jnsdxng984tjngmdhj6m6uj:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l 12:34:56:ab:cd:ef  2028 43.54.25.86     Marcq-en-Baroeul,France    macOS 14.2.1   2              8                            3/26/2024 11:00:00AM 3/26/2024 8:00:00AM
fsdfnje98jnsdxng984tjngmdhj6m6uj:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l 12:34:56:ab:cd:ef  1097 43.54.25.86     Houilles,France            macOS 14.2.1   2              5                            3/25/2024 9:00:00PM  3/22/2024 8:00:00AM
jmjkumfdadguyg76fvgdglniuhvoxdbd:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l ab:12:cd:34:ef:56  1300 120.134.53.53   Prague,Czechia             macOS 14.3.1   3              4                            2/26/2024 9:00:00AM  2/26/2024 8:00:00AM
...
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
