---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AsAServiceCapabilities

## SYNOPSIS
Retrieves a list of NIOS-XaaS Service Capabilities for a particular Service

## SYNTAX

### ByService
```
Get-B1AsAServiceCapabilities -Service <String> [<CommonParameters>]
```

### ByServiceID
```
Get-B1AsAServiceCapabilities -ServiceID <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used query a list of NIOS-XaaS Service Capabilities for a particular Service

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AsAServiceCapabilities -Service Production | ft -AutoSize
```

## PARAMETERS

### -Service
{{ Fill Service Description }}

```yaml
Type: String
Parameter Sets: ByService
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceID
{{ Fill ServiceID Description }}

```yaml
Type: String
Parameter Sets: ByServiceID
Aliases:

Required: True
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
