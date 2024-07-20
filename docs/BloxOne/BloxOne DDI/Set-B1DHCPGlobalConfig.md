---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DHCPGlobalConfig

## SYNOPSIS
Updates the BloxOneDDI Global DHCP Configuration

## SYNTAX

### Default (Default)
```
Set-B1DHCPGlobalConfig [-Object <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AddDDNSZones
```
Set-B1DHCPGlobalConfig [-AddDDNSZones] -DDNSZones <Object> -DNSView <String> [-Object <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RemoveDDNSZones
```
Set-B1DHCPGlobalConfig [-RemoveDDNSZones] -DDNSZones <Object> [-DNSView <String>] [-Object <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update the BloxOneDDI Global DHCP Configuration

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DHCPGlobalConfig -AddDDNSZones -DDNSZones "mysubzone.corp.mycompany.com" -DNSView "default"
```

## PARAMETERS

### -AddDDNSZones
Using this switch indicates the zones specified in -DDNSZones are to be added to the Global DHCP Configuration

```yaml
Type: SwitchParameter
Parameter Sets: AddDDNSZones
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveDDNSZones
Using this switch indicates the zones specified in -DDNSZones are to be removed from the Global DHCP Configuration

```yaml
Type: SwitchParameter
Parameter Sets: RemoveDDNSZones
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSZones
Provide a list of DDNS Zones to add or remove to/from the Global DHCP Configuration.

This is to be used in conjunction with -AddDDNSZones and -RemoveDDNSZones respectively.

```yaml
Type: Object
Parameter Sets: AddDDNSZones, RemoveDDNSZones
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSView
The DNS View for applying the configuration to

```yaml
Type: String
Parameter Sets: AddDDNSZones
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: RemoveDDNSZones
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
{{ Fill Object Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
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
