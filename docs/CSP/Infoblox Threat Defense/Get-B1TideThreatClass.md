---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TideThreatClass

## SYNOPSIS
Queries a list of threat classes

## SYNTAX

```
Get-B1TideThreatClass [[-id] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will query a list of threat classes

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TideThreatClass

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
