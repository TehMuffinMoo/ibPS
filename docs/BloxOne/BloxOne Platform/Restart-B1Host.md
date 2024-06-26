---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Restart-B1Host

## SYNOPSIS
Restarts a BloxOneDDI Host

## SYNTAX

### Default
```
Restart-B1Host -B1Host <String> [-NoWarning] [<CommonParameters>]
```

### With ID
```
Restart-B1Host [-NoWarning] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to initiate a reboot of a BloxOneDDI Host

## EXAMPLES

### EXAMPLE 1
```powershell
Restart-B1Host -B1Host "bloxoneddihost1.mydomain.corp" -NoWarning
```

## PARAMETERS

### -B1Host
The FQDN of the host to reboot

```yaml
Type: String
Parameter Sets: Default
Aliases: OnPremHost

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWarning
If this parameter is used, there will be no prompt for confirmation before rebooting

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

### -id
The id of the BloxOneDDI Host.
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
