---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1AuthoritativeZoneSerial

## SYNOPSIS
Increments the serial number of an existing Authoritative Zone in Universal DDI

## SYNTAX

### FQDN
```
Set-B1AuthoritativeZoneSerial -FQDN <String> -View <String> [-Serial <String>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
Set-B1AuthoritativeZoneSerial [-Serial <String>] -Object <Object> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to increment an Authoritative Zone SOA Serial Number in Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1AuthoritativeZoneSerial -FQDN my.corp -View "default"

Set-B1AuthoritativeZoneSerial
    Increment Serial Number by 1,000 on Authoritative Zone: my.corp. (dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a) from 27 to 1,027
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

    absolute_name_spec     : my.corp.
    absolute_zone_name     : my.corp.
    comment                :
    compartment_id         :
    created_at             : 24/11/2025 15:04:49
    delegation             :
    disabled               : False
    dns_absolute_name_spec : my.corp.
    dns_absolute_zone_name : my.corp.
    dns_name_in_zone       :
    dns_rdata              : ns.my.corp. hostmaster.my.corp. 28 10800 3600 2419200 900
    id                     : dns/record/095ds3de-7793-469b-9159-7e62fd80278d
    inheritance_sources    :
    ipam_host              :
    last_queried           : 01/01/1970 00:00:00
    name_in_zone           :
    nios_metadata          :
    options                :
    protection             :
    provider_metadata      :
    rdata                  : @{expire=2419200; mname=ns.my.corp.; negative_ttl=900; refresh=10800; retry=3600; rname=hostmaster@my.corp; serial=1027}
    source                 : {SYSTEM}
    subtype                :
    tags                   :
    ttl                    : 28800
    type                   : SOA
    updated_at             : 2026-07-03T10:40:20.668283186Z
    view                   : dns/view/e3ebc1f6-c493-441a-b2b8-d509cc2e3ee5
    view_name              : default
    zone                   : dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a
```

### EXAMPLE 2
```powershell
Get-B1AuthoritativeZone -FQDN my.corp | Set-B1AuthoritativeZoneSerial -Serial 1028

Set-B1AuthoritativeZoneSerial
    Increment Serial Number by 1 on Authoritative Zone: my.corp. (dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a) from 1,027 to 1,028
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

    absolute_name_spec     : my.corp.
    absolute_zone_name     : my.corp.
    comment                :
    compartment_id         :
    created_at             : 24/11/2025 15:04:49
    delegation             :
    disabled               : False
    dns_absolute_name_spec : my.corp.
    dns_absolute_zone_name : my.corp.
    dns_name_in_zone       :
    dns_rdata              : ns.my.corp. hostmaster.my.corp. 28 10800 3600 2419200 900
    id                     : dns/record/095ds3de-7793-469b-9159-7e62fd80278d
    inheritance_sources    :
    ipam_host              :
    last_queried           : 01/01/1970 00:00:00
    name_in_zone           :
    nios_metadata          :
    options                :
    protection             :
    provider_metadata      :
    rdata                  : @{expire=2419200; mname=ns.my.corp.; negative_ttl=900; refresh=10800; retry=3600; rname=hostmaster@my.corp; serial=1028}
    source                 : {SYSTEM}
    subtype                :
    tags                   :
    ttl                    : 28800
    type                   : SOA
    updated_at             : 2026-07-03T10:40:20.668283186Z
    view                   : dns/view/e3ebc1f6-c493-441a-b2b8-d509cc2e3ee5
    view_name              : default
    zone                   : dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a
```

## PARAMETERS

### -FQDN
The FQDN of the zone to update

```yaml
Type: String
Parameter Sets: FQDN
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS View the zone is located in

```yaml
Type: String
Parameter Sets: FQDN
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Serial
The new serial number to set for the Authoritative Zone.
If not specified, the serial will be incremented by 1,000

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

### -Object
The Authoritative Zone Object to update.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to High.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
