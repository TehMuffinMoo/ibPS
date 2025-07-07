---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TideThreatCounts

## SYNOPSIS
Queries the threats count from TIDE API

## SYNTAX

```
Get-B1TideThreatCounts [-Historical] [<CommonParameters>]
```

## DESCRIPTION
This function will query the threat counts TIDE API which returns threat counts organized by type over time.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TideThreatCounts
```

### EXAMPLE 2
```powershell
Get-B1TideThreatCounts | Select-Object -ExpandProperty class_counts | Select-Object -ExpandProperty ip | Select-Object -ExpandProperty iid

APT                    : 1010
Cryptocurrency         : 6
InternetInfrastructure : 209
MalwareC2              : 61
MalwareDownload        : 5
Phishing               : 5
Proxy                  : 4113
Suspicious             : 192
UnwantedContent        : 8
```

## PARAMETERS

### -Historical
Specify this switch to retrieve historical threat counts

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
