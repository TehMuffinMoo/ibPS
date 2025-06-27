---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AsAServiceDeployments

## SYNOPSIS
Retrieves a list of NIOS-XaaS Service Deployments for a particular Service

## SYNTAX

### ByService
```
Get-B1AsAServiceDeployments -Service <String> [-Location <String>] [<CommonParameters>]
```

### ByServiceID
```
Get-B1AsAServiceDeployments -ServiceID <String> [-Location <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used query a list of NIOS-XaaS Service Deployments for a particular Service

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AsAServiceDeployments -Service Production | ft -AutoSize

id                               name        service_location          service_ip     cnames                          access_location_count size  neighbour_ips                    preferred_provider routing_type
--                               ----        ----------------          ----------     ------                          --------------------- ----  -------------                    ------------------ ------------
g3oox35c6wgsjuk2dl76zmofqzzgobsf mcox-demo-2 AWS US East (N. Virginia) 192.168.200.10 {52.71.149.43, 44.215.57.240}   1                     Small {192.168.200.11, 192.168.200.12} Any                static
jca2xysvhkhhaef6gqlchg335zaqmrsr mcox-demo   AWS Europe (London)       192.168.100.10 {18.169.197.52, 18.132.218.240} 1                     Small {192.168.100.11, 192.168.100.12} AWS                static
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

### -Location
{{ Fill Location Description }}

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
