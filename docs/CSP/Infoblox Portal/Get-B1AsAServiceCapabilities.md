---
external help file: ibPS-Main-help.xml
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

type  service_status  profile_id                            profile_name              association_count
----  --------------  ----------                            ------------              -----------------
dns   Available       fdsu98uv-rgg5-5ge4d-g5eg-cgecgcgfdfgf NIOS-XaaS DNS Profile     459
ntp   Available
dhcp  Available       sdfdsxfb-rbf5-dxzvdx-dxvd-cxdvdxvvxd4 NIOS-XaaS DHCP Profile    2931
```

## PARAMETERS

### -Service
The name of the Universal DDI Service to query capabilities for.
Either Service or ServiceID is required.

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
The id of the Universal DDI Service to query capabilities for.
Either ServiceID or Service is required.

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
