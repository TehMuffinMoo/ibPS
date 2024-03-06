---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideThreatClass

## SYNOPSIS
Queries a list of threat classes

## SYNTAX

```
Get-B1TDTideThreatClass [[-id] <String>]
```

## DESCRIPTION
This function will query a list of threat classes

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDTideThreatClass

link                                                            id                     name                      updated
----                                                            --                     ----                      -------
{@{href=/data/threat_classes/APT; rel=self}}                    APT                    APT                       3/2/2016 6:57:24PM
{@{href=/data/threat_classes/Bot; rel=self}}                    Bot                    Bot                       3/2/2016 6:57:24PM
{@{href=/data/threat_classes/CompromisedDomain; rel=self}}      CompromisedDomain      Compromised Domain        
{@{href=/data/threat_classes/CompromisedHost; rel=self}}        CompromisedHost        Compromised Host          
...
```

## PARAMETERS

### -id
Filter the results by class ID

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
