---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1NTPServiceConfiguration

## SYNOPSIS
Updates the NTP configuration for a particular service

## SYNTAX

```
Set-B1NTPServiceConfiguration [-Name] <String> [-Strict] [-UseGlobalNTPConfig] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update the NTP configuration for a particular service

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1NTPServiceConfiguration -Name "mybloxonehost.corp.domain.com" -Strict -UseGlobalNTPConfig
```

## PARAMETERS

### -Name
The name of the BloxOneDDI service to check the NTP configuration for

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

### -UseGlobalNTPConfig
Use this parameter to apply the NTP Configuration from the Global NTP Configuration

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
