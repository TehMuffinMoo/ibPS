---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1Location

## SYNOPSIS
Removes a Location from the BloxOne Cloud

## SYNTAX

### Default
```
Remove-B1Location -Name <String> [<CommonParameters>]
```

### Pipeline
```
Remove-B1Location -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a Location from the BloxOne Cloud

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1Location -Name "Madrid"

Successfully deleted Location: Madrid
```

### EXAMPLE 2
```powershell
Get-B1Location -Name "Madrid" | Remove-B1Location

Successfully deleted Location: Madrid
```

## PARAMETERS

### -Name
Filter the results by the name of the Location

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
The Location Object.
Accepts pipeline input from Get-B1Location

```yaml
Type: Object
Parameter Sets: Pipeline
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
