---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDDossierSupportedTargets

## SYNOPSIS
Queries a list of available dossier indicator types

## SYNTAX

```
Get-B1TDDossierSupportedTargets [[-Source] <String>]
```

## DESCRIPTION
The Dossier Indicators cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) indicator types and whether or not they are available for the caller.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDDossierSupportedTargets

ip
host
url
hash
email
```

## PARAMETERS

### -Source
Filter the supported targets based on Source

You can get a list of supported sources using Get-B1TDDossierSupportedSources

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
