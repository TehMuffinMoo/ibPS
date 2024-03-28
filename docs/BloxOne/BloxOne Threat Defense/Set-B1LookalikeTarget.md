---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1LookalikeTarget

## SYNOPSIS
Updates an existing lookalike target domain for the account

## SYNTAX

```
Set-B1LookalikeTarget [-Domain] <String[]> [-Description] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing lookalike target domain for the account.

The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1LookalikeTarget -Domain "mydomain.com" -Description "New description.."
```

### EXAMPLE 2
```powershell
Set-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "New Description 1","New Description 2"
```

### EXAMPLE 3
```powershell
Set-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "New Common description"
```

## PARAMETERS

### -Domain
This is the domain to be updated from the watched lookalike domain list

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

### -Description
The updated description from the selected domain

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
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
