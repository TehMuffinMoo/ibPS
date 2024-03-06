---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Revoke-B1DNSConfigProfile

## SYNOPSIS
Removes a DNS Config Profile from one or more BloxOneDDI hosts

## SYNTAX

```
Revoke-B1DNSConfigProfile [-Hosts] <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DNS Config Profile from one or more BloxOneDDI hosts

## EXAMPLES

### EXAMPLE 1
```powershell
Revoke-B1DNSConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
```

## PARAMETERS

### -Hosts
A list of BloxOneDDI Hosts to remove the DNS Config Profile from

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
