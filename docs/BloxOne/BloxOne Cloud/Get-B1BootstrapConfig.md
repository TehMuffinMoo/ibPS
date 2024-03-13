---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1BootstrapConfig

## SYNOPSIS
Retrieves the bootstrap configuration for a BloxOneDDI Host

## SYNTAX

```
Get-B1BootstrapConfig [-OnPremHost] <String> [-Strict] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve the bootstrap configuration for a BloxOneDDI Host

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1BootstrapConfig -OnPremHost "myonpremhost.corp.domain.com"
```

## PARAMETERS

### -OnPremHost
The name of the BloxOneDDI host to check the NTP configuration for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
Use strict filter matching.
By default, filters are searched using wildcards where possible.
Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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

## RELATED LINKS
