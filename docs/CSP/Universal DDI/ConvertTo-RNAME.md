---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# ConvertTo-RNAME

## SYNOPSIS
Uses the Infoblox Portal API to convert an email address to RNAME format

## SYNTAX

```
ConvertTo-RNAME [-Email] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function uses the Infoblox Portal API to convert an email address to RNAME format

## EXAMPLES

### EXAMPLE 1
```powershell
ConvertTo-RNAME -Email 'admin.user@company.corp'

Email                   RNAME
-----                   -----
admin.user@company.corp admin\.user.company.corp
```

## PARAMETERS

### -Email
The email address to convert into RNAME format

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
