---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# New-B1TDLookalikeTarget

## SYNOPSIS
Adds a new lookalike target domain for the account

## SYNTAX

```
New-B1TDLookalikeTarget [-Domain] <String[]> [[-Description] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to add a new lookalike target domain for the account.

The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1TDLookalikeTarget -Domain "mydomain.com" -Description "Some description.."
```

### EXAMPLE 2
```powershell
New-B1TDLookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "Description 1","Description 2"
```

### EXAMPLE 3
```powershell
New-B1TDLookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "Common description"
```

## PARAMETERS

### -Domain
This is the domain to be added to the watched lookalike domain list

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
The description to apply to the selected domain

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
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
