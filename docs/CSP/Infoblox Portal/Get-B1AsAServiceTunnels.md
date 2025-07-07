---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AsAServiceTunnels

## SYNOPSIS
Retrieves the connection information of NIOS-X As A Service IPSEC Tunnels

## SYNTAX

### ByService
```
Get-B1AsAServiceTunnels -Service <String> -Location <String> [-ReturnStatus] [<CommonParameters>]
```

### ByServiceID
```
Get-B1AsAServiceTunnels -ServiceID <String> -Location <String> [-ReturnStatus] [<CommonParameters>]
```

## DESCRIPTION
This function is used query the connection information of NIOS-X As A Service IPSEC Tunnels

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AsAServiceTunnels -Service Production

id               : fdsdfoi9sdejf98ewsgfn98e4whfsue
name             : GB-DC
wan_ip           : 66.66.66.66
identity_type    : FQDN
physical_tunnels : {@{path=secondary; remote_id=infoblox.cloud; identity=df43ewf34rf444g.infoblox.com; credential_id=fdsfsfdse-fesfsfs-seffe43gf45-g444gg4g4;
                  credential_name=Path-A-PSK; status=Connected}, @{path=primary; remote_id=infoblox.cloud; identity=fsef4f4f4thd4rt.infoblox.com;
                  credential_id=fdfsdf4e-87iik87i-h656urf9ddf-fdsgsd9sx; credential_name=Path-B-PSK; status=Connected}}
remote_id        : infoblox.cloud
```

### EXAMPLE 2
```powershell
Get-B1AsAServiceTunnels -Service Production -ReturnStatus

path      remote_id      identity                      credential_id                        credential_name      status
----      ---------      --------                      -------------                        ---------------      ------
secondary infoblox.cloud df43ewf34rf444g.infoblox.com fdsfsfdse-fesfsfs-seffe43gf45-g444gg4g4 Path-A-PSK         Connected
primary   infoblox.cloud fsef4f4f4thd4rt.infoblox.com fdfsdf4e-87iik87i-h656urf9ddf-fdsgsd9sx Path-B-PSK         Connected
```

## PARAMETERS

### -Service
The name of the Universal DDI Service to query the tunnel status for.
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
The id of the Universal DDI Service to query the tunnel status for.
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
The name of the Access Location to filter the the tunnel status by.
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnStatus
If specified, the function will return only the status of the tunnels.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
