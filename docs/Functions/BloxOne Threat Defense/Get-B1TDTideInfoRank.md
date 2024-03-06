---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideInfoRank

## SYNOPSIS
Queries the InfoRank List

## SYNTAX

```
Get-B1TDTideInfoRank [-Domain] <String> [-Strict] [<CommonParameters>]
```

## DESCRIPTION
This function will query the InfoRank List for specific or related domains

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDTideInfoRank -Domain "amazonaws.com" -Strict

domain        rank interval
------        ---- --------
amazonaws.com    1 [1, 1]
```

### EXAMPLE 2
```powershell
Get-B1TDTideInfoRank -Domain amazonaws.com

domain           rank interval
------           ---- --------
amazonaws.com       1 [1, 1]
amazonaws.com.cn  401 [393, 408]
```

## PARAMETERS

### -Domain
Return results based on this domain name.
When -Strict is not specified, this will match on whole or part domain names.

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

### -Strict
Return results for this domain name only, by default all related domains will be returned

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
