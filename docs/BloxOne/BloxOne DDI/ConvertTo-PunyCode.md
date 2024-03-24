---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# ConvertTo-PunyCode

## SYNOPSIS
Uses the BloxOne API to convert a domain name to Punycode

## SYNTAX

```
ConvertTo-PunyCode [-FQDN] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function uses the BloxOne API to convert a domain name to Punycode

## EXAMPLES

### EXAMPLE 1
```powershell
ConvertTo-PunyCode -FQDN "bbс.co.uk"

idn       punycode
---       --------
bbс.co.uk xn--bb-pmc.co.uk
```

## PARAMETERS

### -FQDN
The fully qualified domain name to convert to Punycode

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
