---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DNSHost

## SYNOPSIS
Updates an existing DNS Host

## SYNTAX

```
Set-B1DNSHost [-Name] <String> [[-DNSConfigProfile] <String>] [[-DNSName] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to updates an existing DNS Host

## EXAMPLES

### EXAMPLE 1
```
Set-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -DNSConfigProfile "Data Centre" -DNSName "bloxoneddihost1.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the BloxOneDDI DNS Host

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSConfigProfile
The name of the DNS Config Profile to apply to the DNS Host.
This will overwrite the existing value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSName
The DNS FQDN to use for this DNS Server.
This will overwrite the existing value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
