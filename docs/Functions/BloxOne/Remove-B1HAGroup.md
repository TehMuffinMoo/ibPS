---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1HAGroup

## SYNOPSIS
Removes a DHCP HA Group

## SYNTAX

### notid (Default)
```
Remove-B1HAGroup [-Name <String>] [<CommonParameters>]
```

### ID
```
Remove-B1HAGroup -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DHCP HA Group

## EXAMPLES

### EXAMPLE 1
```
Remove-B1HAGroup -Name "My HA Group"
```

### EXAMPLE 2
```
Get-B1HAGroup -Name "My HA Group" | Remove-B1HAGroup
```

## PARAMETERS

### -Name
The name of the HA Group to remove

```yaml
Type: String
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the HA Group to remove.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
