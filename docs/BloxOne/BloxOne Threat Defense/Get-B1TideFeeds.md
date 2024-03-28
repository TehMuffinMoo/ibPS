---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TideFeeds

## SYNOPSIS
Queries a list BYOF RPZ threat feeds

## SYNTAX

```
Get-B1TideFeeds
```

## DESCRIPTION
This function is used to query a list of Bring Your Own File RPZ threat feeds

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TideFeeds | ft -AutoSize

id                        name                   description                  profiles                                        csp_id storage_id
--                        ----                   -----------                  --------                                        ------ ----------
123456.amfeed             amfeed                 AntiMalware Feed            {0014B00014BaC3hQKF:AntiMalware-Profile}         123456    654321
123456.kbfeed             kbfeed                 Known Bad Feed              {0014B00014BaC3hQKF:KnownBad-Profile}            123456    654321
123456.tsfeed             tsfeed                 Test Feed                   {0014B00014BaC3hQKF:Test-Profile}                123456    654321
123456.scfeed             scfeed                 Secure Feed                 {0014B00014BaC3hQKF:Secure-Profile}              123456    654321
...
```

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
