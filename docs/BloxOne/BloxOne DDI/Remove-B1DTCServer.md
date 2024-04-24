---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DTCServer

## SYNOPSIS
Removes an existing BloxOne DTC Server

## SYNTAX

### Default
```
Remove-B1DTCServer -Name <String> [<CommonParameters>]
```

### With ID
```
Remove-B1DTCServer -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOne DTC Server

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DTCServer -Name "EXCHANGE-MAIL01"

Successfully removed DTC Server: EXCHANGE-MAIL01
```

### EXAMPLE 2
```powershell
Get-B1DTCServer -Name "EXCHANGE-" | Remove-B1DTCServer

Successfully removed DTC Server: EXCHANGE-MAIL01
Successfully removed DTC Server: EXCHANGE-MAIL02
```

## PARAMETERS

### -Name
The name of the DTC Server to remove

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
The DTC Server Object(s) to remove.
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
