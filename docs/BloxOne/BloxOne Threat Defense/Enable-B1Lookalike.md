---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Enable-B1Lookalike

## SYNOPSIS
Unmutes a lookalike domain

## SYNTAX

```
Enable-B1Lookalike [-LookalikeDomain] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to unmute a lookalike domain

## EXAMPLES

### EXAMPLE 1
```powershell
Enable-B1Lookalike -LookalikeDomain "google98.pro","return-tax-hmrc.com"

Successfully unmuted lookalike: google98.pro
Successfully unmuted lookalike: return-tax-hmrc.com
```

## PARAMETERS

### -LookalikeDomain
One or more identified lookalikes to unmute

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
Used in combination with Disable-B1Lookalike to mute/unmute lookalike domains.

## RELATED LINKS
