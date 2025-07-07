---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DTCServer

## SYNOPSIS
Creates a new server object within Universal DDI DTC

## SYNTAX

### FQDN
```
New-B1DTCServer -Name <String> [-Description <String>] -FQDN <String> [-AutoCreateResponses <String>]
 [-SynthesizedA <IPAddress[]>] [-SynthesizedCNAME <String>] [-State <String>] [-Tags <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### IP
```
New-B1DTCServer -Name <String> [-Description <String>] -IP <IPAddress> [-AutoCreateResponses <String>]
 [-SynthesizedA <IPAddress[]>] [-SynthesizedCNAME <String>] [-State <String>] [-Tags <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new server object within Universal DDI DTC

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DTCServer -Name 'Exchange Server A' -Description 'Exchange Server - Active Node' -FQDN 'exchange-1.company.corp' -AutoCreateResponses

id                           : dtc/server/fsfsef8f3-3532-643h-jhjr-sdgfrgrg51349
 name                         : Exchange Server A
 comment                      : Exchange Server - Active Node
 tags                         :
 disabled                     : False
 address                      :
 records                      : {@{type=CNAME; rdata=; dns_rdata=exchange-1.company.corp}}
 fqdn                         : exchange-1.company.corp.
 endpoint_type                : fqdn
 auto_create_response_records : False
 metadata                     :
```

## PARAMETERS

### -Name
The name of the DTC server object to create

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

### -Description
The description for the new DTC server

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

### -FQDN
The FQDN of the server to associate the DTC object with.
The -FQDN and -IP option are mutually exclusive.

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

### -IP
The IP of the server to associate the DTC object with.
The -IP and -FQDN option are mutually exclusive.

```yaml
Type: IPAddress
Parameter Sets: IP
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoCreateResponses
If enabled, DTC response will contain an auto-created A (IPv4), AAAA (IPv6), CNAME(FQDN) record with endpoint defined using -IP or -FQDN.

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

### -SynthesizedA
The Synthesized A record(s) to add to the DTC Server.

```yaml
Type: IPAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SynthesizedCNAME
The Synthesized CNAME record to add to the DTC Server.
This cannot be used in conjunction with -AutoCreateResponses

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

### -State
Whether or not the new server is created as enabled or disabled.
Defaults to enabled

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Enabled
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the DTC Server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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
