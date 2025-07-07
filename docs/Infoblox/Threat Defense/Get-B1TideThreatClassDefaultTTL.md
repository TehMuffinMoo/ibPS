---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TideThreatClassDefaultTTL

## SYNOPSIS
Queries the default TTL for threat classes

## SYNTAX

```
Get-B1TideThreatClassDefaultTTL [<CommonParameters>]
```

## DESCRIPTION
This function will query the default TTL applied to threat classes

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TideThreatClassDefaultTTL

class                  property                              ttl
-----                  --------                              ---
APT                                                          2 years
Bot                                                          7 days
CompromisedHost                                              30 days
Cryptocurrency                                               1 year
Cryptocurrency         Cryptocurrency_Coinhive               60 days
Cryptocurrency         Cryptocurrency_Cryptojacking          60 days
Cryptocurrency         Cryptocurrency_Exchange               60 days
Cryptocurrency         Cryptocurrency_Generic                14 days
Cryptocurrency         Cryptocurrency_GenericThreat          14 days
...
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
