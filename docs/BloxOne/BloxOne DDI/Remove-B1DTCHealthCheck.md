---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DTCHealthCheck

## SYNOPSIS
Removes an existing BloxOne DTC Health Check

## SYNTAX

### Default
```
Remove-B1DTCHealthCheck -Name <String> [<CommonParameters>]
```

### With ID
```
Remove-B1DTCHealthCheck -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOne DTC Health Check

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DTCHealth Check -Name "Exchange-HealthCheck"

Successfully removed DTC Health Check: Exchange-HealthCheck
```

### EXAMPLE 2
```powershell
Get-B1DTCHealth Check -Name "Exchange-HealthCheck"| Remove-B1DTCHealthCheck

Successfully removed DTC Health Check: Exchange-HealthCheck
```

## PARAMETERS

### -Name
The name of the DTC Health Check to remove

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The DTC Health Check Object(s) to remove.
Accepts pipeline input.

```yaml
Type: Object
Parameter Sets: With ID
Aliases:

Required: True
Position: Named
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
