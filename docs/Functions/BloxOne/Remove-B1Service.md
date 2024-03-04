---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1Service

## SYNOPSIS
Removes an existing BloxOneDDI Service

## SYNTAX

### noID
```
Remove-B1Service -Name <String> [-NoWarning] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ID
```
Remove-B1Service -id <String> [-NoWarning] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOneDDI Service

## EXAMPLES

### EXAMPLE 1
```
Remove-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the BloxOneDDI Service to remove

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
The id of the BloxOneDDI Host.
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

### -NoWarning
Using -NoWarning will stop warnings prior to deleting a host

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
