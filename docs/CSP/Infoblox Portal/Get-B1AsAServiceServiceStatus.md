---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AsAServiceServiceStatus

## SYNOPSIS
Retrieves the connection status of NIOS-X As A Service connections

## SYNTAX

### ByService
```
Get-B1AsAServiceServiceStatus -Service <String> [-Location <String>] [<CommonParameters>]
```

### ByServiceID
```
Get-B1AsAServiceServiceStatus -ServiceID <String> [-Location <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used query the connection status of NIOS-X As A Service connections

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AsAServiceServiceStatus -Service Production | ft -AutoSize

universal_service_id             service_location          endpoint_id                       access_location_id               access_location_name access_location_country status    identity                    wan_ip_addresses  lan_subnets
--------------------             ----------------          -----------                       ------------------               -------------------- ----------------------- ------    --------                    ----------------  -----------
4t4t44tsfsdfdsfdfsdsfdisemg3vfr4 AWS Europe (London)       q7xmxm5qhmavsq3v6eetwfkvlvg5uqk5  ay7ng7ggcisiolqya4iafozsisemg3vf Head-Office          United Kingdom          Connected dfsgfsrt443f.infoblox.com   {88.88.88.88}     {10.12.0.0/16}
ej7vgf7hlwxmyubjitxdatpnidk3a32r AWS US East (N. Virginia) dffsf43trgd8j489tjg89e4hrgregdfs  xzf4k74qfdsf4fsegf4tgr4etgedsg45 US-Office            United Kingdom          Connected fdsfsdfg54gf.infoblox.com   {66.66.66.66}     {10.13.0.0/16}
```

## PARAMETERS

### -Service
The name of the Universal DDI Service to query the service status for.
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
The id of the Universal DDI Service to query the service status for.
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

### -Location
The name of the Access Location to filter the the service status by.
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
