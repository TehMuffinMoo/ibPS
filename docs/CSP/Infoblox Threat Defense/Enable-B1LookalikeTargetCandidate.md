---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Enable-B1LookalikeTargetCandidate

## SYNOPSIS
Enables a lookalike from the Common Watched Domains list

## SYNTAX

```
Enable-B1LookalikeTargetCandidate [-Domain] <String[]> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to enable a lookalike from the Common Watched Domains list

## EXAMPLES

### EXAMPLE 1
```powershell
Enable-B1LookalikeTargetCandidate -Domain "adobe.com","airbnb.com"

Successfully enabled lookalike candidate: adobe.com
Successfully enabled lookalike candidate: airbnb.com
```

### EXAMPLE 2
```powershell
Enable-B1LookalikeTargetCandidate -Domain <TabComplete>

alibaba.com                  flickr.com                   navyfederal.org              secureserver.net
americanexpressbusiness.com  fortisbc.com                 nytimes.com                  sedoparking.com
arrow.com                    foxnews.com                  odnoklassniki.ru             squarespace.com
...
```

## PARAMETERS

### -Domain
One or more common watched domain to enable.

This parameter auto-completes based on the current list of disabled domains

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

## RELATED LINKS
