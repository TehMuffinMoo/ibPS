---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DTCPolicy

## SYNOPSIS
Removes an existing BloxOne DTC Policy

## SYNTAX

### Default
```
Remove-B1DTCPolicy -Name <String> [<CommonParameters>]
```

### With ID
```
Remove-B1DTCPolicy -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOne DTC Policy

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DTCPolicy -Name "Exchange-Policy"

Successfully removed DTC Policy: Exchange-Policy
```

### EXAMPLE 2
```powershell
Get-B1DTCPolicy -Name "Exchange-Policy" | Remove-B1DTCPolicy

Successfully removed DTC Policy: Exchange-Policy
```

## PARAMETERS

### -Name
The name of the DTC Policy to remove

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
The DTC Policy Object(s) to remove.
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
