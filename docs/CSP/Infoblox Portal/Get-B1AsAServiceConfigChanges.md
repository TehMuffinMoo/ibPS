---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AsAServiceConfigChanges

## SYNOPSIS
Retrieves a list of configuration changes for NIOS-X As A Service

## SYNTAX

```
Get-B1AsAServiceConfigChanges [[-Service] <String>] [[-Location] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used query a list of configuration changes for NIOS-X As A Service, optionally filtering by service or location.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AASConfigChanges -Service NIOS-XaaS | ft -AutoSize

id        resource_id                      change_message                          created_at           user_name                      request_id
--        -----------                      --------------                          ----------           ---------                      ----------
864953773 4t4t44tsfsdfdsfdfsdsfdisemg3vfr4 Updated Access Location VMo2-Swansea-DC 6/25/2025 6:37:22 PM example.user@domain.com        494ddfdsfsfsdfgt5heeeccd7fd4a616
864953771 dvfdg45ythzxer5hs5h5ygavr4vfagr5 Updated Endpoint NIOS-XaaS-Swansea      6/25/2025 6:37:22 PM example.user@domain.com        494ddfdsfsfsdfgt5heeeccd7fd4a616
864953769 dfsdsemniu9frhn4e9ufn9w48th4fgws Updated Universal Service               6/25/2025 6:37:22 PM example.user@domain.com        494ddfdsfsfsdfgt5heeeccd7fd4a616
864951938 4t4t44tsfsdfdsfdfsdsfdisemg3vfr4 Updated Access Location VMo2-Swansea-DC 6/25/2025 6:36:34 PM example.user@domain.com        7fdr9fdsdffr4gf4g5ey5hy219c939f8
```

## PARAMETERS

### -Service
The name of the Universal DDI Service to query configuration changes for.
Either Service or ServiceID is required.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
The name of the Access Location to filter the configuration changes by.
This parameter is optional.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
