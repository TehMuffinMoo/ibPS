---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1TDLookalikeTarget

## SYNOPSIS
Remove a lookalike target domain from the account

## SYNTAX

```
Remove-B1TDLookalikeTarget [-Domain] <String[]> [-NoWarning] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a lookalike target domain from the account
The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1TDLookalikeTarget -Domain "mydomain.com"
```

## PARAMETERS

### -Domain
This is the domain to be removed from the watched lookalike domain list

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

### -NoWarning
Using -NoWarning will stop warnings prior to deleting a lookalike

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Credits: Ollie Sheridan

## RELATED LINKS
