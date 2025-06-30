---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Licenses

## SYNOPSIS
Retrieves a list of licenses associated with the Infoblox Portal Account

## SYNTAX

```
Get-B1Licenses [[-State] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used query a list of licenses associated with the Infoblox Portal Account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Licenses -State all
```

## PARAMETERS

### -State
Use the -State parameter to filter by license state.
(all/active/expired)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
