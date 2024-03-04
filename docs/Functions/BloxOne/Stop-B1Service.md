---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Stop-B1Service

## SYNOPSIS
Stops a BloxOneDDI Service

## SYNTAX

### noID
```
Stop-B1Service -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ID
```
Stop-B1Service -id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to stop a BloxOneDDI Service

## EXAMPLES

### EXAMPLE 1
```
Stop-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the BloxOneDDI Service to stop

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
The id of the BloxOneDDI Service to stop.
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
