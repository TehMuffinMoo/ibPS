---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideThreatClassDefaultTTL

## SYNOPSIS
Queries the default TTL for threat classes

## SYNTAX

```
Get-B1TDTideThreatClassDefaultTTL
```

## DESCRIPTION
This function will query the default TTL applied to threat classes

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDTideThreatClassDefaultTTL

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
