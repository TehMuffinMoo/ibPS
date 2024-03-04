---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideThreatEnrichment

## SYNOPSIS
Used to retrieve threat enrichment data from BloxOne Threat Defense

## SYNTAX

```
Get-B1TDTideThreatEnrichment [-Type] <String> [-Indicator] <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve threat enrichment data from BloxOne Threat Defense

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDTideDataProfiles -Name "My Profile"
```

## PARAMETERS

### -Type
Use this parameter to specify the type of enrichment search to perform

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

### -Indicator
Use this parameter to specify the indicator to search by.
This will be either the domain name, URL or IP.
When using the Threat Actor lookup, the indicator should be the name of the Threat Actor, e.g "APT1","Carbanak","FIN6", etc.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
