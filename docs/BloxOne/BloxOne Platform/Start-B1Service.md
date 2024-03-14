---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Start-B1Service

## SYNOPSIS
Starts a BloxOneDDI Service

## SYNTAX

### Default
```
Start-B1Service -Name <String> [<CommonParameters>]
```

### With ID
```
Start-B1Service -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to start a BloxOneDDI Service

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the BloxOneDDI Service to start

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

### -id
The id of the BloxOneDDI Service to start.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: With ID
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
