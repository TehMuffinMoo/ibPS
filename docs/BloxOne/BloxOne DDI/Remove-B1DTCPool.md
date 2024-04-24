---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DTCPool

## SYNOPSIS
Removes an existing BloxOne DTC Pool

## SYNTAX

### Default
```
Remove-B1DTCPool -Name <String> [<CommonParameters>]
```

### With ID
```
Remove-B1DTCPool -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOne DTC Pool

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DTCPool -Name "Exchange-Pool"

Successfully removed DTC Pool: Exchange-Pool
```

### EXAMPLE 2
```powershell
Get-B1DTCPool -Name "Exchange-Pool"| Remove-B1DTCPool

Successfully removed DTC Pool: Exchange-Pool
```

## PARAMETERS

### -Name
The name of the DTC Pool to remove

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
The DTC Pool Object(s) to remove.
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
