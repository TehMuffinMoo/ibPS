---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1LookalikeTarget

## SYNOPSIS
Updates an existing lookalike target domain for the account

## SYNTAX

```
Set-B1LookalikeTarget [-Domain] <String[]> [-Description] <String[]> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing lookalike target domain for the account.

The Lookalike Target Domains are second-level domains Threat Defense uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
