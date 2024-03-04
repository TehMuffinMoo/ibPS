---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1Space

## SYNOPSIS
Removes an IP Space from BloxOneDDI IPAM

## SYNTAX

### noID
```
Remove-B1Space -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ID
```
Remove-B1Space -id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an IP Space from BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```
Remove-B1Space -Name "My IP Space"
```

### EXAMPLE 2
```
Get-B1Space -Name "My IP Space" | Remove-B1Space
```

## PARAMETERS

### -Name
The name of the IP Space to remove

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the IP Space.
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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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
