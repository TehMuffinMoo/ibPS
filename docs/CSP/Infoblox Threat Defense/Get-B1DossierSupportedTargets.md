---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DossierSupportedTargets

## SYNOPSIS
Queries a list of available dossier indicator types

## SYNTAX

```
Get-B1DossierSupportedTargets [[-Source] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Dossier Indicators cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) indicator types and whether or not they are available for the caller.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DossierSupportedTargets

ip
host
url
hash
email
```

## PARAMETERS

### -Source
Filter the supported targets based on Source

You can get a list of supported sources using Get-B1DossierSupportedSources

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
