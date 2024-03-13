---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Disable-B1TDLookalikeTargetCandidate

## SYNOPSIS
Disables a lookalike from the Common Watched Domains list

## SYNTAX

```
Disable-B1TDLookalikeTargetCandidate [-Domain] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to disable a lookalike from the Common Watched Domains list

## EXAMPLES

### EXAMPLE 1
```powershell
Disable-B1TDLookalikeTargetCandidate -Domain "adobe.com","airbnb.com"
```

## PARAMETERS

### -Domain
One or more common watched domain to disable

This parameter auto-completes based on the current list of enabled domains

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
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
