---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1CustomList

## SYNOPSIS
Removes a Custom List from BloxOne Threat Defense

## SYNTAX

### Default (Default)
```
Remove-B1CustomList [-Name <String>] [<CommonParameters>]
```

### Pipeline
```
Remove-B1CustomList -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove named lists from BloxOne Threat Defense.
These are referred to and displayed as Custom Lists within the CSP.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1CustomList | Where-Object {$_.name -eq "My Custom List"} | Remove-B1CustomList
```

## PARAMETERS

### -Name
The name of the Custom List to remove.

Whilst this is here, the API does not currently support filtering by name.
(01/04/24)

For now, you should instead use pipeline to remove objects as shown in the examples.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The Custom List Object.
This accepts pipeline input from Get-B1CustomList

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
