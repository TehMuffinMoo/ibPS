---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DTCServer

## SYNOPSIS
Updates a server object within Universal DDI DTC

## SYNTAX

### Default (Default)
```
Set-B1DTCServer -Name <String> [-NewName <String>] [-Description <String>] [-FQDN <String>] [-IP <IPAddress>]
 [-AutoCreateResponses <String>] [-SynthesizedA <IPAddress[]>] [-SynthesizedCNAME <String>] [-State <String>]
 [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### With ID
```
Set-B1DTCServer [-NewName <String>] [-Description <String>] [-FQDN <String>] [-IP <IPAddress>]
 [-AutoCreateResponses <String>] [-SynthesizedA <IPAddress[]>] [-SynthesizedCNAME <String>] [-State <String>]
 [-Tags <Object>] -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a server object within Universal DDI DTC

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DTCServer -Name 'Exchange Server A' -Description 'New Exchange Node' -FQDN 'exchange-3.company.corp'

id                           : dtc/server/fsfsef8f3-3532-643h-jhjr-sdgfrgrg51349
 name                         : Exchange Server A
 comment                      : New Exchange Node
 tags                         :
 disabled                     : False
 address                      :
 records                      : {@{type=CNAME; rdata=; dns_rdata=exchange-3.company.corp}}
 fqdn                         : exchange-3.company.corp.
 endpoint_type                : fqdn
 auto_create_response_records : False
 metadata                     :
```

### EXAMPLE 2
```powershell
Get-B1DTCServer -Name 'Exchange Server B' | Set-B1DTCServer -State Disabled

id                           : dtc/server/fg5hh56-3tf2-g54r-jbh6r-xsdvsrgzdv45
 name                         : Exchange Server B
 comment                      : New Exchange Node
 tags                         :
 disabled                     : True
 address                      :
 records                      : {@{type=CNAME; rdata=; dns_rdata=exchange-2.company.corp}}
 fqdn                         : exchange-2.company.corp.
 endpoint_type                : fqdn
 auto_create_response_records : False
 metadata
```

## PARAMETERS

### -Name
The name of the DTC server object to update

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the DTC Server object

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

### -Description
The new description for the DTC server

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
The new FQDN for the DTC Server.
The -FQDN and -IP option are mutually exclusive.

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

### -IP
The new IP for the DTC Server.
The -IP and -FQDN option are mutually exclusive.

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
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
The Synthesized A record(s) to update on the DTC Server.

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
The Synthesized CNAME record to update on the DTC Server.
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
Default value: None
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

### -Object
The DTC Server Object(s) to update.
Accepts pipeline input.

```yaml
Type: Object
Parameter Sets: With ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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
